//
//  GlobalField.m
//  Contentstack
//
//  Created by Reeshika Hosmani on 02/06/25.
//  Copyright © 2025 Contentstack. All rights reserved.
//

#import "GlobalField.h"
#import "CSIOInternalHeaders.h"
#import "CSIOConstants.h"
#import "CSIOCoreHTTPNetworking.h"
#import "CSIOAPIURLs.h"
#import "NSObject+Extensions.h"
#import "Stack.h"
#import "Query.h"

@interface GlobalField ()
@property (nonatomic, strong, getter=stack) Stack *csStack;
@property (nonatomic, strong) NSMutableDictionary *postParamDictionary;
@property (nonatomic, strong) NSMutableDictionary *headers;
@property (nonatomic, strong) NSURLSessionDataTask *requestOperation;
@property (nonatomic, strong) NSMutableDictionary *objectProperties;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSDate *createdAt;
@property (nonatomic, copy) NSDate *updatedAt;
@property (nonatomic, copy) id responseJSON;
@property (nonatomic, assign) unsigned int version;
@property (nonatomic, copy) NSString *branch;
@property (nonatomic, copy) NSArray<NSDictionary *> *schema;
@property (nonatomic, assign) BOOL inbuiltClass;
@property (nonatomic, assign) BOOL maintainRevisions;
@property (nonatomic, copy) NSDictionary *lastActivity;

@end

@implementation GlobalField

-(instancetype)initWithStack:(Stack*)stack {
    if (self = [super init]) {
        _csStack = stack;
        _postParamDictionary = [NSMutableDictionary dictionary];
        _headers = [NSMutableDictionary dictionary];
        _objectProperties = [NSMutableDictionary dictionary];
    }
    return self;
}

-(instancetype)initWithStack:(Stack*)stack withName:(NSString*)globalFieldName {
    if (self = [self initWithStack:stack]) {
        if(globalFieldName && globalFieldName.length) {
            _uid = [globalFieldName copy];
        }
    }
    return self;
}

//MARK: - Headers
- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey {
    [self.headers setObject:headerValue forKey:headerKey];
}

- (void)addHeadersWithDictionary:(NSDictionary<NSString *,NSString *> *)headers {
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.headers setObject:obj forKey:key];
    }];
}

- (void)removeHeaderForKey:(NSString *)headerKey {
    if (self.headers[headerKey]) {
        [self.headers removeObjectForKey:headerKey];
    }
}

//MARK: - Configure
-(void)configureWithDictionary:(NSDictionary<NSString *, id> *)dictionary {
    if (!dictionary) return;
    
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
    
    if (self.objectProperties[kCSIO_Title]) {
        self.title = self.objectProperties[kCSIO_Title];
    }
    
    if (self.objectProperties[kCSIO_description]) {
        self.Description = self.objectProperties[kCSIO_description];
    }
    
    if (self.objectProperties[kCSIO_version]) {
        self.version = [self.objectProperties[kCSIO_version] intValue];
    }
    
    if (self.objectProperties[kCSIO_branch]) {
        self.branch = self.objectProperties[kCSIO_branch];
    }
    
    if (self.objectProperties[kCSIO_CreatedAt]) {
        self.createdAt = [_csStack.commonDateFormatter dateFromString:self.objectProperties[kCSIO_CreatedAt]];
    }
    
    if (self.objectProperties[kCSIO_UpdatedAt]) {
        self.updatedAt = [_csStack.commonDateFormatter dateFromString:self.objectProperties[kCSIO_UpdatedAt]];
    }
    
    if (self.objectProperties[kCSIO_schema]) {
        self.schema = self.objectProperties[kCSIO_schema];
    }
    
    if (self.objectProperties[kCSIO_inbuilt_class]) {
        self.inbuiltClass = [self.objectProperties[kCSIO_inbuilt_class] boolValue];
    }
    
    if (self.objectProperties[kCSIO_maintain_revisions]) {
        self.maintainRevisions = [self.objectProperties[kCSIO_maintain_revisions] boolValue];
    }
    
    if (self.objectProperties[kCSIO_last_activity]) {
        self.lastActivity = self.objectProperties[kCSIO_last_activity];
    }
}

//MARK: - Include Methods
-(void)includeBranch {
    [self.postParamDictionary setObject:@"true" forKey:@"include_branch"];
}

-(void)includeGlobalFieldSchema {
    [self.postParamDictionary setObject:@"true" forKey:@"include_global_field_schema"];
}

//MARK: getResult -
- (NSArray *)getResult{
    if ([self.objectProperties objectForKey:kCSIO_globalfields] && [[self.objectProperties objectForKey:kCSIO_globalfields] isKindOfClass:[NSArray class]]) {
        NSArray *objectsArray = (NSArray*)[self.objectProperties objectForKey:kCSIO_globalfields];
        NSMutableArray *gfObjects = [NSMutableArray array];
        // if condition is fix for value of "entries" key ie.array inside array in response JSON
        if (objectsArray.firstObject && [objectsArray.firstObject isKindOfClass:[NSArray class]]) {
            [objectsArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj enumerateObjectsUsingBlock:^(NSDictionary *objDict, NSUInteger idx, BOOL * _Nonnull stop) {
                    GlobalField *globalField = [_csStack globalField];
                    [globalField configureWithDictionary:objDict];
                    [gfObjects addObject:globalField];
                }];
            }];
        } else {
            [objectsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *objDict = (NSDictionary *)obj;
                GlobalField *globalField = [_csStack globalField];
                [globalField configureWithDictionary:objDict];
                [gfObjects addObject:globalField];
            }];
        }
        return gfObjects;
    } else {
        return nil;
    }
}

//MARK: - Fetch Methods
- (void)fetch:(void(^)(ResponseType type, NSError *BUILT_NULLABLE_P error))callback {
    
    [self.postParamDictionary setObject:_csStack.environment forKey:kCSIO_Environment];
    
    NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionaryWithDictionary:self.postParamDictionary];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:_csStack.stackHeaders];
    [headers addEntriesFromDictionary:self.headers];

    NSString *path = [CSIOAPIURLs fetchGlobalFieldWithVersion:self.uid withVersion:_csStack.version];

    self.requestOperation = [_csStack.network requestForStack:_csStack withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:paramDictionary additionalHeaders:headers cachePolicy:self.cachePolicy completion:^(ResponseType responseType, id responseJSON, NSError *error) {
        if (error) {
            callback(responseType, error);
        } else {
            self.responseJSON = responseJSON;
            [self configureWithDictionary:[responseJSON objectForKey:kCSIO_globalfield]];
            callback(responseType, nil);
        }
    }];
}


//MARK: Fetch
- (void)fetchAll:(void (^) (ResponseType type,NSArray<GlobalField *> * BUILT_NULLABLE_P result,NSError * BUILT_NULLABLE_P error))completionBlock {

    
    [self.postParamDictionary setObject:_csStack.environment forKey:kCSIO_Environment];
    
    NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionaryWithDictionary:self.postParamDictionary];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:_csStack.stackHeaders];
    [headers addEntriesFromDictionary:self.headers];

    NSString *path = [CSIOAPIURLs findGlobalFieldsWithVersion:_csStack.version];
    
    self.requestOperation = [_csStack.network requestForStack:_csStack withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:paramDictionary additionalHeaders:headers cachePolicy:_cachePolicy completion:^(ResponseType responseType, id responseJSON, NSError *error) {
        if (error) {
            completionBlock(responseType, nil, error);
        }else {
            self.objectProperties = responseJSON;
            NSArray *allGlobalFields = [self getResult];
            completionBlock(responseType, allGlobalFields, nil);
        }
    }];
}

@end

