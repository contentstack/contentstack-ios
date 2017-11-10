//
//  Stack.m
//  Contentstack
//
//  Created by Reefaq on 11/07/15.
//  Copyright (c) 2015 Built.io. All rights reserved.
//

#import "Stack.h"
#import "AFNetworking.h"
#import "CSIOInternalHeaders.h"
#import "CSIOConstants.h"
#import "CSIOCoreHTTPNetworking.h"
#import "ContentType.h"
#import "CSIOAPIURLs.h"
#import "NSObject+Extensions.h"

@interface Stack ()
@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) Config *config;

@property (nonatomic, copy) NSString *environment;
//@property (nonatomic, strong) NSMutableSet *requestOperationSet;


@end

@implementation Stack

- (instancetype)initWithAPIKey:(NSString*)apiKey andAccessToken:(NSString *)accessToken andEnvironment:(NSString*)environment andConfig:(Config *)sConfig {
    if (self = [super init]) {
        _config = sConfig;

        _hostURL = [sConfig.host copy];
        _ssl = sConfig.isSSL;
        _version = [sConfig.version copy];
        _environment = [environment copy];

        _apiKey = apiKey;
        _accessToken = accessToken;
        
        _network = [[CSIOCoreHTTPNetworking alloc] init];
        _stackHeaders = [NSMutableDictionary dictionary];
        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc]init];
        _commonDateFormatter = formatter;
        _commonDateFormatter.includeTime = YES;
        
//        _requestOperationSet = [NSMutableSet set];

        
        [self setHeader:_apiKey forKey:kCSIO_SiteApiKey];
        [self setHeader:_accessToken forKey:kCSIO_Authtoken];
     
    }
    return self;
}

//MARK: - ContentType

-(ContentType*)contentTypeWithName:(NSString*)contentTypeName; {
    ContentType *contentType = [[ContentType alloc] initWithStack:self withName:contentTypeName];
    return contentType;
}

//MARK: - Asset

-(Asset *)asset {
    Asset *asset = [[Asset alloc] initWithStack:self];
    return asset;
}

-(Asset*)assetWithUID:(NSString*)assetUid {
    Asset *asset = [[Asset alloc] initWithStack:self withAssetUID:assetUid];
    return asset;
}

-(AssetLibrary *)assetLibrary {
    AssetLibrary *assetLib = [[AssetLibrary alloc] initWithStack:self];
    return assetLib;
}

//MARK: - Headers

- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey {
    [self.stackHeaders setObject:headerValue forKey:headerKey];
}

- (void)addHeadersWithDictionary:(NSDictionary *)headers {
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.stackHeaders setObject:obj forKey:key];
    }];
}

- (void)removeHeaderForKey:(NSString *)headerKey {
    if (self.stackHeaders[headerKey]) {
        [self.stackHeaders removeObjectForKey:headerKey];
    }
}

- (NSString *)imageTransformWithUrl:(NSString *)url andParams:(NSDictionary *)params{
    if([url rangeOfString:@"?" options:NSCaseInsensitiveSearch].length==0) {
        url = [url stringByAppendingString:@"?"];
    }
    for (id key in params) {
        id value = [params objectForKey:key];
        url = [url stringByAppendingString:[NSString stringWithFormat: @"&%@=%@", key, value]];
    }
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"?&" withString:@"?"];
    return url;
}



//- (void)fetchLastActivity:(void (^)(ResponseType responseType, NSDictionary *lastActivity, NSError *error))completionBlock {
//    NSString *path = [CSIOAPIURLs fetchContentTypeSchemaQueryURLWithVersion:self.version];
//    
//    NSMutableDictionary *paramsDictionary = [NSMutableDictionary dictionary];
//    [paramsDictionary setObject:@"true" forKey:@"only_last_activity"];
//    [paramsDictionary setObject:self.environment forKey:kCSIO_Environment];
//
//   AFHTTPRequestOperation *op = [self.network requestForStack:self withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:paramsDictionary additionalHeaders:self.stackHeaders completion:^(ResponseType responseType, id responseJSON, NSError *error) {
//        NSMutableDictionary *lastActivityDict = [NSMutableDictionary dictionary];
//        if (completionBlock) {
//            if (!error) {
//                
//                NSArray *content_types = responseJSON[@"content_types"];
//                [content_types enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//                    NSArray *details = [obj valueForKeyPath:@"last_activity.environment.details"];
//                    if (details) {
//                        [lastActivityDict setObject:details forKey:obj[@"uid"]];
//                    }
//                }];
//                
//                completionBlock(responseType, lastActivityDict, nil);
//            }else {
//                completionBlock(responseType, nil, error);
//            }
//        }
//
//    }];
//    
//    if (op && ![op isKindOfClass:[NSNull class]]) {
//        [self.requestOperationSet addObject:op];
//    }
//}
//
//- (void)fetchSchema:(void (^)(ResponseType responseType, NSArray * BUILT_NULLABLE_P schema, NSError * BUILT_NULLABLE_P error))completionBlock {
//    NSString *path = [CSIOAPIURLs fetchSchemaWithVersion:self.version];
//
//    NSMutableDictionary *paramsDictionary = [NSMutableDictionary dictionary];
////    [paramsDictionary setObject:@(YES) forKey:@"content_types"];
//
//    AFHTTPRequestOperation *op = [self.network requestForStack:self withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:paramsDictionary additionalHeaders:self.stackHeaders completion:^(ResponseType responseType, id responseJSON, NSError *error) {
//        if (completionBlock) {
//            if (!error) {
//                NSArray *content_types = responseJSON[@"content_types"];
//                completionBlock(responseType, content_types, nil);
//            }else {
//                completionBlock(responseType, nil, error);
//            }
//        }
//    }];
//    
//    if (op && ![op isKindOfClass:[NSNull class]]) {
//        [self.requestOperationSet addObject:op];
//    }
//}
//
////MARK: - Cancel -
//
//- (void)cancelRequests {
//    [self.requestOperationSet enumerateObjectsUsingBlock:^(AFHTTPRequestOperation *op, BOOL *stop) {
//        if (op.isExecuting) {
//            [op cancel];
//        }
//    }];
//}

@end
