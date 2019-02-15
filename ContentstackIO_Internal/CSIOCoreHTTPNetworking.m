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
#import "AFNetworking.h"
#import "Stack.h"
#import "CSIOURLCache.h"
#import "NSObject+Extensions.h"

NSString *const sdkVersion = @"3.4.0";

@interface CSIOCoreHTTPNetworking (){
    id networkChangeObserver;
}

@property (nonatomic, strong) AFHTTPRequestOperationManager *httpRequestOperationManager;

@end

@implementation CSIOCoreHTTPNetworking

-(instancetype)init {
    if (self=[super init]) {
        _httpRequestOperationManager = [AFHTTPRequestOperationManager manager];
        [NSURLCache setSharedURLCache:[CSIOURLCache standardURLCache]];
    }
    return self;
}

- (NSString *)protocolStringForSSL:(BOOL)isSSL {
    return isSSL ? @"https" : @"http";
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

- (void)saveToCacheWithOperation:(AFHTTPRequestOperation *)operation{
    NSCachedURLResponse *cacheResponse = [[NSCachedURLResponse alloc] initWithResponse:operation.response data:operation.responseData];
    [[NSURLCache sharedURLCache] storeCachedResponse:cacheResponse forRequest:operation.request];
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
        urlString = [NSString stringWithFormat:@"%@://%@%@", [self protocolStringForSSL:stack.ssl], stack.hostURL, urlPath];
    }
    NSString* requestMethod = [self reqestMethodStringForRequestType:requestType];
    
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionaryWithDictionary:[paramDict copy]];
    [requestParameters removeObjectForKey:@"query"];
    
    NSError *err;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:requestMethod URLString:urlString parameters:requestParameters error:&err];
    
    NSDictionary *queryJson = [paramDict objectForKey:@"query"];
    if (queryJson) {
        NSString *queryValue = [[self jsonStringFromDictonary:queryJson] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&query=%@",request.URL.absoluteString,queryValue]];
    }
    
    [stack.stackHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    [additionalHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    NSString *userAgent = request.allHTTPHeaderFields[@"User-Agent"];
    NSString *version = sdkVersion;
    [request setValue:[NSString stringWithFormat:@"%@/%@",userAgent,version] forHTTPHeaderField:@"User-Agent"];

    return request;
}

- (NSMutableURLRequest *)urlRequestForStack:(Stack*)stack
                                    withURLPath:(NSString*)urlPath
                                    requestType:(CSIOCoreNetworkingRequestType)requestType
                                         params:(NSDictionary*)paramDict
                              additionalHeaders:(NSDictionary*)additionalHeaders
                                    withFileKey:(NSString*)fileKey
                                   withFileData:(id)filedata {
    
    NSString* urlString = [NSString stringWithFormat:@"%@://%@%@", [self protocolStringForSSL:stack.ssl], stack.hostURL, urlPath];
    NSString* requestMethod = [self reqestMethodStringForRequestType:requestType];
    
    NSError *err;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:requestMethod URLString:urlString parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if ([filedata isKindOfClass:[NSString class]]) {
            [formData appendPartWithFileURL:[NSURL URLWithString:((NSString*)filedata)] name:@"upload[upload]" error:nil];
        }else if ([filedata isKindOfClass:[NSData class]]) {
            [formData appendPartWithFileData:filedata name:@"upload[upload]" fileName:fileKey mimeType:@"application/octet-stream"];
        }else if ([filedata isKindOfClass:[UIImage class]]) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(filedata, 0.8) name:@"upload[upload]" fileName:fileKey mimeType:@"image/jpeg"];
        }
    } error:&err];
    [stack.stackHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    [additionalHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    return request;
}


//MARK: - CSIOCoreNetworkingProtocol

//MARK: - async

- (AFHTTPRequestOperation*)requestForStack:(Stack*)stack
                  withURLPath:(NSString*)urlPath
                  requestType:(CSIOCoreNetworkingRequestType)requestType
                       params:(NSDictionary*)paramDict
            additionalHeaders:(NSDictionary*)additionalHeaders
                   completion:(CSIONetworkCompletionHandler)completionBlock {

    return [self requestForStack:stack withURLPath:urlPath requestType:requestType params:paramDict additionalHeaders:additionalHeaders cachePolicy:NETWORK_ONLY completion:completionBlock];
}

- (AFHTTPRequestOperation*)requestForStack:(Stack*)stack
                  withURLPath:(NSString*)urlPath
                  requestType:(CSIOCoreNetworkingRequestType)requestType
                       params:(NSDictionary*)paramDict
            additionalHeaders:(NSDictionary*)additionalHeaders
                  cachePolicy:(CachePolicy)cachePolicy
                   completion:(CSIONetworkCompletionHandler)completionBlock {
    
    NSMutableURLRequest *request = [self urlRequestForStack:stack withURLPath:urlPath requestType:requestType params:paramDict additionalHeaders:additionalHeaders];
    // Cache handler
    ResponseType resType = NETWORK;
    switch (cachePolicy) {
        case NETWORK_ONLY:
            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
            break;
            
        case CACHE_ONLY:
            [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
            resType = CACHE;
            break;
            
        case CACHE_ELSE_NETWORK:
            [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
            break;
            
        case NETWORK_ELSE_CACHE:
//            [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
            break;
            
        case CACHE_THEN_NETWORK:
            [self fullfillRequestWithCache:request completion:completionBlock];
            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
            break;
            
        default:
            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
            break;
    }

    // Initiate request
    AFHTTPRequestOperation *op = [self.httpRequestOperationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (cachePolicy != NETWORK_ONLY) {
            [self saveToCacheWithOperation:operation];
        }
        completionBlock(resType, responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (cachePolicy == NETWORK_ELSE_CACHE) {
            [self fullfillRequestWithCache:operation.request completion:completionBlock];
        } else {
            completionBlock(resType, operation.responseObject, error);
        }
    }];
    
    [self.httpRequestOperationManager.operationQueue addOperation:op];
    
    return op;
}

- (AFHTTPRequestOperation*)requestForStack:(Stack*)stack
                                        withURLPath:(NSString*)urlPath
                                        requestType:(CSIOCoreNetworkingRequestType)requestType
                                             params:(NSDictionary*)paramDict
                                        withFileKey:(NSString*)fileKey
                                       withFileData:(id)filedata
                                  additionalHeaders:(NSDictionary*)additionalHeaders
                                         completion:(CSIONetworkCompletionHandler)completionBlock {
    
    NSMutableURLRequest *request = [self urlRequestForStack:stack withURLPath:urlPath requestType:requestType params:paramDict additionalHeaders:additionalHeaders withFileKey:fileKey withFileData:filedata];

    // Initiate request
    AFHTTPRequestOperation *op = [self.httpRequestOperationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(NETWORK, responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NETWORK, operation.responseObject, error);
    }];
    
    [self.httpRequestOperationManager.operationQueue addOperation:op];
    return op;
}

- (AFHTTPRequestOperation*)requestDataForStack:(Stack*)stack
                                        withURLPath:(NSString*)urlPath
                                        requestType:(CSIOCoreNetworkingRequestType)requestType
                                             params:(NSDictionary*)paramDict
                                  additionalHeaders:(NSDictionary*)additionalHeaders
                                         completion:(CSIONetworkCompletionHandler)completionBlock {
    
    NSMutableURLRequest *request = [self urlRequestForStack:stack withURLPath:urlPath requestType:requestType params:paramDict additionalHeaders:additionalHeaders];

    // Initiate request
    AFHTTPRequestOperation *op = [self.httpRequestOperationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(NETWORK, responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NETWORK, operation.responseObject, error);
    }];
    op.responseSerializer = [AFCompoundResponseSerializer serializer];
    
    [self.httpRequestOperationManager.operationQueue addOperation:op];
    return op;
}


//MARK: - cancel

- (void)cancelAllOperations {
    [self.httpRequestOperationManager.operationQueue cancelAllOperations];
}

- (void)dealloc {
    if(networkChangeObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:networkChangeObserver];
    }
}

@end
