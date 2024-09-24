//
//  Asset.m
//  contentstack
//
//  Created by Priyanka Mistry on 19/05/16.
//  Copyright © 2016 Contentstack. All rights reserved.
//

#import "Asset.h"
#import <Contentstack/Stack.h>
#import "CSIOInternalHeaders.h"
#import "CSIOConstants.h"
#import "CSIOAPIURLs.h"
#import "NSObject+Extensions.h"
#import "MMMarkdown.h"

@interface Asset ()
@property (nonatomic, strong) NSMutableDictionary *objectProperties;
@property (nonatomic, strong) NSURLSessionDataTask *requestOperation;
@property (nonatomic, strong) NSMutableDictionary *localHeaders;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSDate *createdAt;
@property (nonatomic, copy) NSString *createdBy;
@property (nonatomic, copy) NSDate *updatedAt;
@property (nonatomic, copy) NSString *updatedBy;
@property (nonatomic, copy) NSDate *deletedAt;
@property (nonatomic, copy) NSString *deletedBy;
@property (nonatomic, copy) id responseJSON;
@property (nonatomic, assign) Language language;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) unsigned int fileSize;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, strong, getter=stack) Stack *csStack;

@end

@implementation Asset

- (instancetype)initWithStack:(Stack*)stack withAssetUID:(NSString*)assetUID{
    if (self = [super init]) {
        _objectProperties = [NSMutableDictionary dictionary];
        _postParamDictionary = [NSMutableDictionary dictionary];
        _csStack = stack;
        
        if (assetUID && assetUID.length) {
            _uid = assetUID;
        }
    }
    return self;
}

- (instancetype)initWithStack:(Stack*)stack  {
    return [self initWithStack:stack withAssetUID:nil];
}

//MARK: - Cuonfigure -

-(void)configureWithDictionary:(NSDictionary<NSString *, id> *)dictionary {
    
    [[dictionary allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.objectProperties setObject:dictionary[key] forKey:key];
    }];
    
    [[self.objectProperties allKeys] enumerateObjectsUsingBlock:^(NSString *objKey, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![[dictionary allKeys] containsObject:objKey]) {
            [self.objectProperties removeObjectForKey:objKey];
        }
    }];
    
    if (self.objectProperties[kCSIO_UID]) {
        self.uid = self.objectProperties[kCSIO_UID];
    }
    
    if (self.objectProperties[kCSIO_Locale]) {
        self.language = [self indexOfLocaleCodeString:self.objectProperties[kCSIO_Locale]];
    }
    
    if (self.objectProperties[kCSIO_Tags]) {
        self.tags = self.objectProperties[kCSIO_Tags];
    }
    
    if (self.objectProperties[kCSIO_FileName]) {
        self.fileName = self.objectProperties[kCSIO_FileName];
    }
    
    if (self.objectProperties[kCSIO_FileSize]) {
        self.fileSize = [self.objectProperties[kCSIO_FileSize] intValue];
    }
    
    if (self.objectProperties[kCSIO_URL]) {
        self.url = self.objectProperties[kCSIO_URL];
    }
    
    if (self.objectProperties[kCSIO_ContentType]) {
        self.fileType = self.objectProperties[kCSIO_ContentType];
    }
    
    if (self.objectProperties[kCSIO_CreatedAt]) {
        self.createdAt = [_csStack.commonDateFormatter dateFromString:self.objectProperties[kCSIO_CreatedAt]];
    }
    
    if (self.objectProperties[kCSIO_CreatedBy]) {
        self.createdBy = self.objectProperties[kCSIO_CreatedBy];
    }
    
    if (self.objectProperties[kCSIO_UpdatedAt]) {
        self.updatedAt = [_csStack.commonDateFormatter dateFromString:self.objectProperties[kCSIO_UpdatedAt]];
    }
    
    if (self.objectProperties[kCSIO_UpdatedBy]) {
        self.updatedBy = self.objectProperties[kCSIO_UpdatedBy];
    }
    
    if (self.objectProperties[kCSIO_DeletedBy]) {
        self.deletedAt = [_csStack.commonDateFormatter dateFromString:self.objectProperties[kCSIO_DeletedBy]];
    }
    
    if (self.objectProperties[kCSIO_DeletedBy]) {
        self.deletedBy = self.objectProperties[kCSIO_DeletedBy];
    }
}

-(void)setLocale:(NSString *)locale {
    [self.postParamDictionary setValue:locale forKey:kCSIO_Locale];
}

-(void)includeFallback {
    [self.postParamDictionary setObject:@"true" forKey:kCSIO_IncludeFallback];
}

-(void)includeMetadata {
    [self.postParamDictionary setObject:@"true" forKey:kCSIO_IncludeMetadata];
}

-(void)includeBranch {
    [self.postParamDictionary setObject:@"true" forKey:kCSIO_IncludeBranch];
}

//MARK: - Headers -

- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey {
    [self.localHeaders setObject:headerValue forKey:headerKey];
}

- (void)addHeadersWithDictionary:(NSDictionary<NSString *, NSString *> *)headers {
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.localHeaders setObject:obj forKey:key];
    }];
}

- (void)addParamKey:(NSString *)key andValue:(NSString *)value{
    if (key != nil){
        if ([self.postParamDictionary objectForKey:key] != nil) {
            [self.postParamDictionary removeObjectForKey:key];
            [self.postParamDictionary setObject:value forKey:key];
        } else {
            [self.postParamDictionary setObject:value forKey:key];
        }
    }
}


- (void)removeHeaderForKey:(NSString *)headerKey {
    if (self.localHeaders[headerKey]) {
        [self.localHeaders removeObjectForKey:headerKey];
    }
}

// MARK: - Fetch -

- (void)fetch:(void(^)(ResponseType type, NSError *BUILT_NULLABLE_P error))callback {
    
    [self cancelRequest];
    
    [self.postParamDictionary setObject:_csStack.environment forKey:kCSIO_Environment];
    
    NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionaryWithDictionary:self.postParamDictionary];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:_csStack.stackHeaders];
    [headers addEntriesFromDictionary:self.localHeaders];

    NSString *path = [CSIOAPIURLs fetchAssetWithUID:self.uid withVersion:_csStack.version];

    self.requestOperation = [_csStack.network requestForStack:_csStack withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:paramDictionary additionalHeaders:headers cachePolicy:self.cachePolicy completion:^(ResponseType responseType, id responseJSON, NSError *error) {
        if (error) {
            callback(responseType,error);
        }else {
            self.responseJSON = responseJSON;
            [self configureWithDictionary:[responseJSON objectForKey:kCSIO_Upload]];
            callback(responseType, nil);
        }
    }];
    
}

//MARK: - Properties
-(NSDictionary *)properties {
    return self.objectProperties;
}

//MARK: - Cancel -

- (void)cancelRequest {
    if (self.requestOperation.state == NSURLSessionTaskStateRunning) {
        [self.requestOperation cancel];
    }
}


@end
