//
//  CSIOCoreNetworking.m
//  Contentstack
//
//  Created by Reefaq on 22/06/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import "CSIOCoreHTTPNetworking.h"
#import "CSIOInternalHeaders.h"
#import "CSIOConstants.h"
#import "CSIOAPIURLs.h"
#import <Contentstack/Stack.h>
#import "CSIOURLCache.h"
#import "NSObject+Extensions.h"
#import "CSURLSessionManager.h"

NSString *const sdkVersion = @"3.10.1";

@interface CSIOCoreHTTPNetworking (){
    id networkChangeObserver;
}

//@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;
@property (nonatomic, strong) CSURLSessionManager *urlSessionManager;

@end

@interface CSIOQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (instancetype)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValue;
@end

static NSString * CSIOPercentEscapedStringFromString(NSString *string) {
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}
@implementation CSIOQueryStringPair

- (instancetype)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.field = field;
    self.value = value;
    
    return self;
}

- (NSString *)URLEncodedStringValue {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return CSIOPercentEscapedStringFromString([self.field description]);
    } else {
        return [NSString stringWithFormat:@"%@=%@", CSIOPercentEscapedStringFromString([self.field description]), CSIOPercentEscapedStringFromString([self.value description])];
    }
}

@end
FOUNDATION_EXPORT NSArray * CSIOQueryStringPairsFromDictionary(NSDictionary *dictionary);
FOUNDATION_EXPORT NSArray * CSIOQueryStringPairsFromKeyAndValue(NSString *key, id value);

static NSString * CSIOQueryStringFromParameters(NSDictionary *parameters) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (CSIOQueryStringPair *pair in CSIOQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValue]];
    }
    
    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * CSIOQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return CSIOQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * CSIOQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:CSIOQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:CSIOQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:CSIOQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[CSIOQueryStringPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}
@implementation CSIOCoreHTTPNetworking

-(instancetype)initWithDelegate: (id<CSURLSessionDelegate>) delegate {
    if (self=[super init]) {
//        _httpSessionManager = [AFHTTPSessionManager manager];
        _urlSessionManager = [CSURLSessionManager manager:[self configuration] delegate:delegate];
        [NSURLCache setSharedURLCache:[CSIOURLCache standardURLCache]];
//        [self sessionManagerQueryStringSerialization];
    }
    return self;
}

-(NSString*) userAgent {
    NSString *userAgent = nil;
    #if TARGET_OS_IOS
        // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
        userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    #elif TARGET_OS_WATCH
        // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
        userAgent = [NSString stringWithFormat:@"%@/%@ (%@; watchOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[WKInterfaceDevice currentDevice] model], [[WKInterfaceDevice currentDevice] systemVersion], [[WKInterfaceDevice currentDevice] screenScale]];
    #elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
        userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
    #endif
    return userAgent;
}
- (NSURLSessionConfiguration* )configuration {
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
     NSString *userAgent = [self userAgent];
        if (userAgent) {
            if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                NSMutableString *mutableUserAgent = [userAgent mutableCopy];
                if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                    userAgent = mutableUserAgent;
                }
            }
            NSString *version = sdkVersion;
            configuration.HTTPAdditionalHeaders = @{
                @"User-Agent": userAgent,
                @"X-User-Agent": [NSString stringWithFormat:@"contentstack-ios/%@",version]
            };

        }
    return configuration;
}
    
//- (void)sessionManagerQueryStringSerialization {
//    __weak typeof(self) weakSelf = self;
//    [self.httpSessionManager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
//        NSMutableDictionary *requestParameters = [NSMutableDictionary dictionaryWithDictionary:[parameters copy]];
//        [requestParameters removeObjectForKey:@"query"];
//        NSString * query = CSIOQueryStringFromParameters(requestParameters);
//        NSDictionary *queryJson = [parameters objectForKey:@"query"];
//        if (queryJson) {
//            NSString *queryValue = [[weakSelf jsonStringFromDictonary:queryJson] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            query = [NSString stringWithFormat:@"%@&query=%@",query,queryValue];
//        }
//        return query;
//    }];
//
//}
    
- (NSString *)protocolStringForSSL {
    return @"https";
}

//MARK: - Cache
- (id)fullfillRequestWithCache:(NSURLRequest *)request error:(NSError **)outError {
    id JSON = [self cachedJSONResponseForRequest:request];
    if (JSON && (![JSON isKindOfClass:[NSNull class]])) {
        return JSON;
    } else {
        NSError *error = [NSError errorWithDomain:@"CacheError" code:-4001 userInfo:@{@"error": @"Failed to retreive data from Cache."}];
        if (outError != nil) *outError = error;
    }
    return nil;
}

- (void)fullfillRequestWithCache:(NSURLRequest *)request completion:(CSIONetworkCompletionHandler)completionBlock {
    id JSON = [self cachedJSONResponseForRequest:request];
    if (JSON && (![JSON isKindOfClass:[NSNull class]])) {
        completionBlock(CACHE, JSON, nil);
    } else {
        NSError *error = [NSError errorWithDomain:@"CacheError" code:-4001 userInfo:@{@"error": @"Failed to retreive data from Cache."}];
        completionBlock(CACHE, nil, error);
    }
}

- (void)saveToCacheDataTask:(NSURLSessionDataTask *)task responseObject:(nonnull id) responseObject{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:(NSJSONWritingPrettyPrinted) error:&error];
    NSCachedURLResponse *cacheResponse = [[NSCachedURLResponse alloc] initWithResponse:task.response data:data];
    [[NSURLCache sharedURLCache] storeCachedResponse:cacheResponse forRequest:task.originalRequest];
}

- (id)cachedJSONResponseForRequest:(NSURLRequest *)request {
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    id JSON = nil;
    if (cachedResponse != nil && [[cachedResponse data] length] > 0) {
        NSError *error = nil;
        JSON = [NSJSONSerialization JSONObjectWithData:cachedResponse.data options:0 error:&error];
    }
    return JSON;
}

- (NSString *)reqestMethodStringForRequestType:(CSIOCoreNetworkingRequestType)requestType {
    NSString *requestMethod = nil;
    switch (requestType) {
        case CSIOCoreNetworkingRequestTypeGET:
            requestMethod = kCSIO_HTTPGET;
            break;
        case CSIOCoreNetworkingRequestTypePOST:
            requestMethod = kCSIO_HTTPPOST;
            break;
        case CSIOCoreNetworkingRequestTypePUT:
            requestMethod = kCSIO_HTTPPUT;
            break;
        case CSIOCoreNetworkingRequestTypeDELETE:
            requestMethod = kCSIO_HTTPDELETE;
            break;
        default:
            requestMethod = kCSIO_HTTPGET;
            break;
    }
    return requestMethod;
}

- (NSMutableURLRequest *)urlRequestForStack:(Stack*)stack
                                withURLPath:(NSString*)urlPath
                                requestType:(CSIOCoreNetworkingRequestType)requestType
                                     params:(NSDictionary*)paramDict
                          additionalHeaders:(NSDictionary*)additionalHeaders {
    
    NSString* urlString = urlPath;
    if (urlPath && !([urlPath hasPrefix:@"http"] || [urlPath hasPrefix:@"https"])) {
        urlString = [NSString stringWithFormat:@"%@://%@%@", [self protocolStringForSSL], stack.hostURL, urlPath];
    }
    NSString* method = [self reqestMethodStringForRequestType:requestType];
    
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionaryWithDictionary:[paramDict copy]];
    [requestParameters removeObjectForKey:@"query"];
    NSString * query = CSIOQueryStringFromParameters(requestParameters);
    NSDictionary *queryJson = [paramDict objectForKey:@"query"];
    if (queryJson) {
        NSString *queryValue = [[self jsonStringFromDictonary:queryJson] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        query = [NSString stringWithFormat:@"%@&query=%@",query,queryValue];
    }
    NSURL *url = [NSURL URLWithString:urlPath];
    if (query && query.length > 0) {
       url = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:url.query ? @"&%@" : @"?%@", query]];
    }
     NSParameterAssert(url);

     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
     request.HTTPMethod = method;

    [stack.stackHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    [additionalHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];

    NSString *userAgent = [self userAgent];
    NSString *version = sdkVersion;
    [request setValue:[NSString stringWithFormat:@"contentstack-ios/%@",version] forHTTPHeaderField:@"X-User-Agent"];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    if (stack.config.branch != nil) {
        [request setValue:stack.config.branch forHTTPHeaderField:kCSIO_Branch];
    }
    return request;
}

//MARK: - CSIOCoreNetworkingProtocol

//MARK: - async

- (NSURLSessionDataTask*)requestForStack:(Stack*)stack
                  withURLPath:(NSString*)urlPath
                  requestType:(CSIOCoreNetworkingRequestType)requestType
                       params:(NSDictionary*)paramDict
            additionalHeaders:(NSDictionary*)additionalHeaders
                   completion:(CSIONetworkCompletionHandler)completionBlock {

    return [self requestForStack:stack withURLPath:urlPath requestType:requestType params:paramDict additionalHeaders:additionalHeaders cachePolicy:NETWORK_ONLY completion:completionBlock];
}

- (NSURLSessionDataTask*)requestForStack:(Stack*)stack
                  withURLPath:(NSString*)urlPath
                  requestType:(CSIOCoreNetworkingRequestType)requestType
                       params:(NSDictionary*)paramDict
            additionalHeaders:(NSDictionary*)additionalHeaders
                  cachePolicy:(CachePolicy)cachePolicy
                   completion:(CSIONetworkCompletionHandler)completionBlock {
    
    NSString* urlString = urlPath;
    if (urlPath && !([urlPath hasPrefix:@"http"] || [urlPath hasPrefix:@"https"])) {
        urlString = [NSString stringWithFormat:@"%@://%@%@", [self protocolStringForSSL], stack.hostURL, urlPath];
    }
    // Cache handler
//    switch (cachePolicy) {
//        case NETWORK_ONLY:
//            [self.httpSessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//            break;
//        case CACHE_ONLY:
//            [self.httpSessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
//            resType = CACHE;
//            break;
//        case CACHE_ELSE_NETWORK:
//            [self.httpSessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
//            break;
//        case NETWORK_ELSE_CACHE:
////            [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
//            break;
//        case CACHE_THEN_NETWORK:
//            [self.httpSessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//            break;
//        default:
//            [self.httpSessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//            break;
//    }
   
//    [stack.stackHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        [self.httpSessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
//    }];
//    [additionalHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        [self.httpSessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
//    }];
//
    // Initiate request
    NSMutableURLRequest *mutableRequest = [self urlRequestForStack:stack withURLPath:urlString requestType:requestType params:paramDict additionalHeaders:additionalHeaders];
    mutableRequest.HTTPMethod = @"GET";
   
//    NSURLSessionDataTask *task = [self.httpSessionManager GET:urlString parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (cachePolicy != NETWORK_ONLY || cachePolicy != CACHE_THEN_NETWORK) {
//            [self saveToCacheDataTask:task responseObject:responseObject];
//        }
//        completionBlock(resType, responseObject, nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//       if (cachePolicy == NETWORK_ELSE_CACHE) {
//          [self fullfillRequestWithCache:task.originalRequest completion:completionBlock];
//       } else {
//          completionBlock(resType, task.response, error);
//       }
//    }];
//    if (cachePolicy == CACHE_THEN_NETWORK) {
//        [self fullfillRequestWithCache:task.originalRequest completion:completionBlock];
//    }else if (cachePolicy == CACHE_ELSE_NETWORK) {
//        NSError *error;
//        if ([self fullfillRequestWithCache:task.originalRequest error:&error]) {
//            [self fullfillRequestWithCache:task.originalRequest completion:completionBlock];
//            [task suspend];
//        }
//    }else if (cachePolicy == CACHE_ONLY) {
//        [self fullfillRequestWithCache:task.originalRequest completion:completionBlock];
//        [task suspend];
//    }
    return [self performRequest: mutableRequest cachePolicy:cachePolicy completion:completionBlock];
}

- (NSURLSessionDataTask*) performRequest:(NSMutableURLRequest*) mutableRequest
      cachePolicy:(CachePolicy)cachePolicy
       completion:(CSIONetworkCompletionHandler)completionBlock{
    ResponseType resType = NETWORK;
    NSString *retryCount = mutableRequest.allHTTPHeaderFields[@"x-cs-retry-count"];
    if (retryCount) {
        int retryInt = [retryCount intValue];// I assume you need it as an integer.
        [mutableRequest setValue:[NSString stringWithFormat:@"%d",(++retryInt)] forHTTPHeaderField:@"x-cs-retry-count"];
    }else {
        [mutableRequest setValue:@"0" forHTTPHeaderField:@"x-cs-retry-count"];
    }
    
    __weak typeof (self) weakSelf = self;

    NSURLSessionDataTask *task = [self.urlSessionManager dataTaskWithRequest:mutableRequest success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        if (cachePolicy != NETWORK_ONLY && responseObject != nil) {
           [self saveToCacheDataTask:task responseObject:responseObject];
        }
        
        completionBlock(resType, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (cachePolicy == NETWORK_ELSE_CACHE) {
           [self fullfillRequestWithCache:task.originalRequest completion:completionBlock];
        } else {
            NSString *retryCount = task.originalRequest.allHTTPHeaderFields[@"x-cs-retry-count"];
            int currentRetryCount = [retryCount intValue];
            
            if ((error.code == 408 || error.code == 429 )&& currentRetryCount < 5) {
                NSTimeInterval timeInterval = pow(2, ++currentRetryCount) * 100 / 1000;
                [NSThread sleepForTimeInterval:timeInterval];
                [weakSelf performRequest:task.originalRequest.mutableCopy cachePolicy:cachePolicy completion:completionBlock];
            }else {
                completionBlock(resType, task.response, error);
            }
        }
    }];
    return task;
}

//MARK: - cancel

- (void)cancelAllOperations {
    [self.urlSessionManager.operationQueue cancelAllOperations];
}

- (void)dealloc {
    if(networkChangeObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:networkChangeObserver];
    }
}

@end
