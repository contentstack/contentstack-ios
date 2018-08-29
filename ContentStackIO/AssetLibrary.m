//
//  AssetLibrary.m
//  contentstack
//
//  Created by Priyanka Mistry on 05/10/16.
//  Copyright © 2016 Contentstack. All rights reserved.
//

#import "AssetLibrary.h"
#import "CSIOInternalHeaders.h"
#import "CSIOConstants.h"
#import "CSIOAPIURLs.h"
#import "AFNetworking.h"
#import "NSObject+Extensions.h"
#import "MMMarkdown.h"

@interface AssetLibrary ()
@property (nonatomic, strong) NSMutableDictionary *localHeaders;

@property (nonatomic, strong) NSMutableDictionary *resultDictionary;
@property (nonatomic, strong, getter=stack) Stack *csStack;
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;

@end


@implementation AssetLibrary

- (instancetype)initWithStack:(Stack*)stack{
    if (self = [super init]) {
    
        self.csStack = stack;
        _localHeaders = [NSMutableDictionary dictionary];
        self.postParamDictionary =[NSMutableDictionary dictionary];
        self.resultDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

//MARK: - Headers -

- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey {
    [self.localHeaders setObject:headerValue forKey:headerKey];
}

- (void)addHeadersWithDictionary:(NSDictionary *)headers {
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.localHeaders setObject:obj forKey:key];
    }];
}

- (void)removeHeaderForKey:(NSString *)headerKey {
    if (self.localHeaders[headerKey]) {
        [self.localHeaders removeObjectForKey:headerKey];
    }
}

//MARK: - Sorting -

-(void)sortWithKey:(NSString *)key orderBy:(OrderBy)order {
    if (order == OrderByAscending) {
        [self.postParamDictionary setObject:key forKey:kCSIO_Ascending];
 
    } else if (order == OrderByDescending) {
        [self.postParamDictionary setObject:key forKey:kCSIO_Descending];
    }
}

//MARK: - Include -
- (void)objectsCount {
    [self.postParamDictionary setObject:@"true" forKey:kCSIO_Count];
}

- (void)includeCount {
    [self.postParamDictionary setObject:@"true" forKey:kCSIO_IncludeCount];
}

-(void)includeRelativeUrls {
    [self.postParamDictionary setObject:@"true" forKey:kCSIO_RelativeUrls];
}

//MARK: Result of the Query -

- (NSArray *)getResult{
    if ([self.resultDictionary objectForKey:kCSIO_Uploads] && [[self.resultDictionary objectForKey:kCSIO_Uploads] isKindOfClass:[NSArray class]]) {
        NSArray *objectsArray = (NSArray*)[self.resultDictionary objectForKey:kCSIO_Uploads];
        NSMutableArray *assetObjects = [NSMutableArray array];
        // if condition is fix for value of "entries" key ie.array inside array in response JSON
        if (objectsArray.firstObject && [objectsArray.firstObject isKindOfClass:[NSArray class]]) {
            [objectsArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj enumerateObjectsUsingBlock:^(NSDictionary *objDict, NSUInteger idx, BOOL * _Nonnull stop) {
                    Asset *asset = [_csStack asset];
                    [asset configureWithDictionary:objDict];
                    [assetObjects addObject:asset];
                }];
            }];
        } else {
            [objectsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *objDict = (NSDictionary *)obj;
                Asset *asset = [_csStack asset];
                [asset configureWithDictionary:objDict];
                [assetObjects addObject:asset];
            }];
        }
        return assetObjects;
        
    } else {
        return nil;
    }
}
//MARK: Fetch
- (void)fetchAll:(void (^) (ResponseType type,NSArray * BUILT_NULLABLE_P result,NSError * BUILT_NULLABLE_P error))completionBlock {

    [self cancelRequest];
    
    [self.postParamDictionary setObject:_csStack.environment forKey:kCSIO_Environment];
    
    NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionaryWithDictionary:self.postParamDictionary];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:_csStack.stackHeaders];
    [headers addEntriesFromDictionary:self.localHeaders];

    NSString *path = [CSIOAPIURLs fetchAssetLibraryWithVersion:_csStack.version];
    
    self.requestOperation = [_csStack.network requestForStack:_csStack withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:paramDictionary additionalHeaders:headers cachePolicy:_cachePolicy completion:^(ResponseType responseType, id responseJSON, NSError *error) {
        if (error) {
            completionBlock(responseType, nil, error);
        }else {
            self.resultDictionary = responseJSON;
            NSArray *allAssets = [self getResult];
            completionBlock(responseType, allAssets, nil);
        }
    }];
}

//MARK: - Cancel -

- (void)cancelRequest {
    if (self.requestOperation.isExecuting) {
        [self.requestOperation cancel];
    }
}


@end
