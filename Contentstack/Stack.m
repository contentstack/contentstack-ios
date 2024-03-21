//
//  Stack.m
//  Contentstack
//
//  Created by Reefaq on 11/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import <Contentstack/Stack.h>
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

@end

@implementation Stack

- (instancetype)initWithAPIKey:(NSString*)apiKey andaccessToken:(NSString *)accessToken andEnvironment:(NSString*)environment andConfig:(Config *)sConfig {
    if (self = [super init]) {
        _config = sConfig;

        _hostURL = [sConfig.host copy];
        if (_config.region != US) {
            _hostURL = [NSString stringWithFormat:@"%@-%@", [self regionCode:_config.region], sConfig.host];
        }
        _version = [sConfig.version copy];
        _environment = [environment copy];

        _apiKey = apiKey;
        _accessToken = accessToken;
        
        _network = [[CSIOCoreHTTPNetworking alloc] initWithDelegate:_config.delegate];
        _stackHeaders = [NSMutableDictionary dictionary];
        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc]init];
        _commonDateFormatter = formatter;
        _commonDateFormatter.includeTime = YES;
        
        _requestOperationSet = [NSMutableSet set];

        
        [self setHeader:_apiKey forKey:kCSIO_SiteApiKey];
        [self setHeader:_accessToken forKey:kCSIO_Accesstoken];
     
    }
    return self;
}

//MARK: - Get ContentTypes
-(void)getContentTypes:(NSDictionary<NSString *,id> *)params completion:(void (^)(NSArray<NSString *> * _Nullable, NSError * _Nullable))completionBlock {
    NSString *path = [CSIOAPIURLs fetchSchemaWithVersion:self.version];
    NSURLSessionDataTask *op = [self.network requestForStack:self withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:params additionalHeaders:self.stackHeaders completion:^(ResponseType responseType, id responseJSON, NSError *error) {
        if (completionBlock) {
            if (error) {
                completionBlock(nil, error);
            }else {
                NSDictionary *responseData = responseJSON;
                if ([[responseData allKeys] containsObject:@"content_types"] && [responseData objectForKey:@"content_types"] != nil && [[responseData objectForKey:@"content_types"] isKindOfClass:[NSArray class]]) {
                    completionBlock([responseData objectForKey:@"content_types"], nil);
                }else {
                    NSError *error = [NSError errorWithDomain:@"Error" code:-4001 userInfo:@{@"error": @"Failed to retreive data."}];
                    completionBlock(nil, error);
                }
            }
        }
    }];
    
    if (op && ![op isKindOfClass:[NSNull class]]) {
        [self.requestOperationSet addObject:op];
    }
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

- (NSString *)imageTransformWithUrl:(NSString *)url andParams:(NSDictionary<NSString *, id> *)params{
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

- (void)syncCallWithParams:(NSDictionary*)params withCompletion:(void (^)(NSDictionary *responseDictionary, NSError *error))completionBlock {
    NSString *path = [CSIOAPIURLs syncWithVersion:self.version];
    NSMutableDictionary *paramsDictionary = [NSMutableDictionary dictionaryWithDictionary:params];
    NSURLSessionDataTask *op = [self.network requestForStack:self withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:paramsDictionary additionalHeaders:self.stackHeaders completion:^(ResponseType responseType, id responseJSON, NSError *error) {
        if (completionBlock) {
            if (error) {
                completionBlock(nil, error);
            }else {
                NSDictionary *responseData = responseJSON;
                completionBlock(responseData, nil);
            }
        }
    }];
    
    if (op && ![op isKindOfClass:[NSNull class]]) {
        [self.requestOperationSet addObject:op];
    }
}

-(void)sync:(void (^)(SyncStack * BUILT_NULLABLE_P syncResult, NSError * BUILT_NULLABLE_P error))completionBlock {
    SyncStack *syncStack = [self getCurrentSyncStack:nil];
    [self sync:syncStack completion:^(SyncStack * _Nullable syncResult, NSError * _Nullable error) {
        completionBlock(syncResult, error);
    }];
}

-(void)syncToken:(NSString *)token completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncResult, NSError * BUILT_NULLABLE_P error))completionBlock {
    SyncStack *syncStack = [self getCurrentSyncStack:@{@"sync_token": token}];
    [self sync:syncStack completion:^(SyncStack * _Nullable syncResult, NSError * _Nullable error) {
        completionBlock(syncResult, error);
    }];
}

-(void)syncPaginationToken:(NSString *)token completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncResult, NSError * BUILT_NULLABLE_P error))completionBlock {
    SyncStack *syncStack = [self getCurrentSyncStack:@{@"pagination_token": token}];
    [self sync:syncStack completion:^(SyncStack * _Nullable syncResult, NSError * _Nullable error) {
        completionBlock(syncResult, error);
    }];
}

- (void)syncFrom:(NSDate*)date completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncResult, NSError * BUILT_NULLABLE_P error))completionBlock {
    SyncStack *syncStack = [self getCurrentSyncStack:@{kCSIO_Start_From : [_commonDateFormatter stringFromDate:date]}];
    [self sync:syncStack completion:^(SyncStack * _Nullable syncResult, NSError * _Nullable error) {
        completionBlock(syncResult, error);
    }];
}

- (void)syncOnly:(NSString *)contentType completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncResult, NSError * BUILT_NULLABLE_P error))completionBlock {
    SyncStack *syncStack = [self getCurrentSyncStack:@{kCSIO_Content_Type: contentType}];
    [self sync:syncStack completion:^(SyncStack * _Nullable syncResult, NSError * _Nullable error) {
        completionBlock(syncResult, error);
    }];
}

- (void)syncOnly:(NSString *)contentType from:(NSDate *)date completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncResult, NSError * BUILT_NULLABLE_P error))completionBlock {
    SyncStack *syncStack = [self getCurrentSyncStack:@{kCSIO_Start_From : [_commonDateFormatter stringFromDate:date], kCSIO_Content_Type: contentType}];
    [self sync:syncStack completion:^(SyncStack * _Nullable syncResult, NSError * _Nullable error) {
        completionBlock(syncResult, error);
    }];
}

-(void)syncLocale:(NSString*)locale completion:(void (^)(SyncStack * _Nullable, NSError * _Nullable))completionBlock {
    SyncStack *syncStack = [self getCurrentSyncStack:@{kCSIO_Locale : locale}];
    [self sync:syncStack completion:^(SyncStack * _Nullable syncResult, NSError * _Nullable error) {
        completionBlock(syncResult, error);
    }];
}

-(void)syncLocale:(NSString*)locale from:(NSDate *)date completion:(void (^)(SyncStack * _Nullable, NSError * _Nullable))completionBlock {
    SyncStack *syncStack = [self getCurrentSyncStack:@{kCSIO_Locale : locale, kCSIO_Start_From : [_commonDateFormatter stringFromDate:date]}];
    [self sync:syncStack completion:^(SyncStack * _Nullable syncResult, NSError * _Nullable error) {
        completionBlock(syncResult, error);
    }];
}

-(void)syncPublishType:(PublishType)publishType completion:(void (^)(SyncStack * _Nullable, NSError * _Nullable))completionBlock {
    SyncStack *syncStack = [self getCurrentSyncStack:@{kCSIO_Type : [self publishType:publishType]}];
    [self sync:syncStack completion:^(SyncStack * _Nullable syncResult, NSError * _Nullable error) {
        completionBlock(syncResult, error);
    }];
}

-(void)syncOnly:(NSString *)contentType locale:(NSString*)locale from:(NSDate *)date completion:(void (^)(SyncStack * _Nullable, NSError * _Nullable))completionBlock {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setValue:contentType forKey:kCSIO_Content_Type];
    [paramsDict setValue:locale forKey:kCSIO_Locale];
    if (date != nil) {
        [paramsDict setValue:[_commonDateFormatter stringFromDate:date] forKey:kCSIO_Start_From];
    }
    SyncStack *syncStack = [self getCurrentSyncStack:paramsDict];
    [self sync:syncStack completion:^(SyncStack * _Nullable syncResult, NSError * _Nullable error) {
        completionBlock(syncResult, error);
    }];
    
   
}

-(void)syncOnly:(NSString *)contentType locale:(NSString*)locale from:(NSDate *)date publishType:(PublishType)publishType completion:(void (^)(SyncStack * _Nullable, NSError * _Nullable))completionBlock {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setValue:contentType forKey:kCSIO_Content_Type];
    [paramsDict setValue:locale forKey:kCSIO_Locale];
    [paramsDict setValue:[self publishType:publishType] forKey:kCSIO_Type];
    if (date != nil) {
        [paramsDict setValue:[_commonDateFormatter stringFromDate:date] forKey:kCSIO_Start_From];
    }
    SyncStack *syncStack = [self getCurrentSyncStack:paramsDict];
    [self sync:syncStack completion:^(SyncStack * _Nullable syncResult, NSError * _Nullable error) {
        completionBlock(syncResult, error);
    }];
}

- (void)sync:(SyncStack *)syncResult completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncResult, NSError * BUILT_NULLABLE_P error))completionBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[syncResult getParameters]];
    if (syncResult.paginationToken == nil && syncResult.syncToken == nil) {
        [params setValue:self.environment forKey:@"environment"];
    }
    [self syncCallWithParams:params withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        if (error == nil) {
            [syncResult parseSyncResult:responseDictionary];
            if (syncResult.hasMorePages) {
                [self sync:syncResult completion:completionBlock];
            }
        }
        completionBlock(syncResult, error);
    }];
}

- (SyncStack*) getCurrentSyncStack:(NSDictionary*) params {
    SyncStack *syncResult = [[SyncStack alloc] initWithParmas:params];
    return syncResult;
}

@end
