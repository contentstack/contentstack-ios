//
//  Entry.m
//  Contentstack
//
//  Created by Reefaq on 22/06/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import "Entry.h"
#import "ContentType.h"
#import "Asset.h"
#import "CSIOInternalHeaders.h"
#import "CSIOConstants.h"
#import "CSIOAPIURLs.h"
#import "AFNetworking.h"
#import "NSObject+Extensions.h"
#import "MMMarkdown.h"

@interface Entry ()

@property (nonatomic, strong) NSMutableDictionary *localHeaders;
@property (nonatomic, strong) NSMutableDictionary *objectProperties;
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSString *contentTypeName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) Language language;
@property (nonatomic, copy) NSDate *createdAt;
@property (nonatomic, copy) NSString *createdBy;
@property (nonatomic, copy) NSDate *updatedAt;
@property (nonatomic, copy) NSString *updatedBy;
@property (nonatomic, copy) NSDate *deletedAt;
@property (nonatomic, copy) NSString *deletedBy;

@end

@implementation Entry

- (instancetype)initWithContentType:(ContentType*)contentType withEntryUID:(NSString*)uid{
    if (self = [super init]) {
        _contentType = contentType;
        _localHeaders = [NSMutableDictionary dictionary];
        _objectProperties = [NSMutableDictionary dictionary];
        _postParamDictionary = [NSMutableDictionary dictionary];
        _uid = uid;
        _contentTypeName = contentType.name;
    }
    return self;
}

- (instancetype)initWithContentType:(ContentType*)contentType {
    return [self initWithContentType:contentType withEntryUID:nil];
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

//MARK: - Configure -

-(void)configureWithDictionary:(NSDictionary*)dictionary {

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
    
    if (self.objectProperties[kCSIO_Title]) {
        self.title = self.objectProperties[kCSIO_Title];
    }
    
    if (self.objectProperties[kCSIO_URL]) {
        self.url = self.objectProperties[kCSIO_URL];
    }
    
    if (self.objectProperties[kCSIO_CreatedAt]) {
        self.createdAt = [self.contentType.stack.commonDateFormatter dateFromString:self.objectProperties[kCSIO_CreatedAt]];
    }
    
    if (self.objectProperties[kCSIO_CreatedBy]) {
        self.createdBy = self.objectProperties[kCSIO_CreatedBy];
    }

    if (self.objectProperties[kCSIO_UpdatedAt]) {
        self.updatedAt = [self.contentType.stack.commonDateFormatter dateFromString:self.objectProperties[kCSIO_UpdatedAt]];
    }
    
    if (self.objectProperties[kCSIO_UpdatedBy]) {
        self.updatedBy = self.objectProperties[kCSIO_UpdatedBy];
    }

    if (self.objectProperties[kCSIO_DeletedAt]) {
        self.deletedAt = [self.contentType.stack.commonDateFormatter dateFromString:self.objectProperties[kCSIO_DeletedAt]];
        _deleted = YES;
    }
    
    if (self.objectProperties[kCSIO_DeletedBy]) {
        self.deletedBy = self.objectProperties[kCSIO_DeletedBy];
    }

}


- (BOOL)hasKey:(NSString *)key {
    if ([self.objectProperties objectForKey:key]) {
        return YES;
    }else if ([self.postParamDictionary objectForKey:key]) {
        return YES;
    }
    return NO;
}

- (NSString *)HTMLStringForMarkdownKey:(NSString *)key {
    if ([self hasKey:key]) {
        id markdownString = [self objectForKey:key];
        
        if ([markdownString isKindOfClass:[NSString class]]) {
            NSError *error;
            
            if ([markdownString length]) {
                NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:markdownString extensions:MMMarkdownExtensionsGitHubFlavored error:&error];
                
                if (!error) {
                    return htmlString;
                }
            }
        }
    }
    
    return nil;
}

- (NSArray *)HTMLArrayForMarkdownKey:(NSString *)key
{
    if ([self hasKey:key]) {
        
        id markdownArray = [self objectForKey:key];
        
        if ([markdownArray isKindOfClass:[NSArray class]]) {
            __block NSError *error;
            __block NSMutableArray *markdownToHtmlArray = [[NSMutableArray alloc] init];
            
            [markdownArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *markdownString = [MMMarkdown HTMLStringWithMarkdown:obj extensions:MMMarkdownExtensionsGitHubFlavored error:&error];
                
                [markdownToHtmlArray addObject:markdownString];
            }];
            
            if (!error) {
                return markdownToHtmlArray;
            }
        }
    }
    
    return nil;
}

//include and exclude

- (void)includeOnlyFields:(NSArray *)fieldUIDs {
    NSMutableArray *keybundle = [NSMutableArray array];
    for (id keyname in fieldUIDs) {
        [keybundle addObject:keyname];
    }
    if ([self.postParamDictionary objectForKey:kCSIO_Only] != nil) {
        [[self.postParamDictionary objectForKey:kCSIO_Only] setObject:fieldUIDs forKey:kCSIO_BASE];
    } else {
        NSMutableDictionary *keySubDict = [NSMutableDictionary dictionary];
        [keySubDict setObject:fieldUIDs forKey:kCSIO_BASE];
        [self.postParamDictionary setObject:keySubDict forKey:kCSIO_Only];
    }
}

- (void)includeAllFieldsExcept:(NSArray *)fieldUIDs {
    NSMutableArray *keybundle = [NSMutableArray array];
    for (id keyname in fieldUIDs) {
        [keybundle addObject:keyname];
    }
    if ([self.postParamDictionary objectForKey:kCSIO_Except] != nil) {
        [[self.postParamDictionary objectForKey:kCSIO_Except] setObject:fieldUIDs forKey:kCSIO_BASE];
    } else {
        NSMutableDictionary *keySubDict = [NSMutableDictionary dictionary];
        [keySubDict setObject:fieldUIDs forKey:kCSIO_BASE];
        [self.postParamDictionary setObject:keySubDict forKey:kCSIO_Except];
    }
}

//MARK: - Reference fields -

- (void)includeRefFieldWithKey:(NSArray *)key;{
    if ([self.postParamDictionary objectForKey:kCSIO_Include] != nil) {
        for (NSString *incKey in key)
            [[self.postParamDictionary objectForKey:kCSIO_Include] addObject:incKey];
    } else {
        NSMutableArray *arrayInclude = [NSMutableArray array];
        [arrayInclude addObjectsFromArray:key];
        [self.postParamDictionary setObject:arrayInclude forKey:kCSIO_Include];
    }
}

- (void)includeRefFieldWithKey:(NSString *)key andOnlyRefValuesWithKeys:(NSArray *)values {
    [self includeRefFieldWithKey:[NSArray arrayWithObject:key]];
    NSMutableArray *keyset = [NSMutableArray array];
    for (id keyname in values) {
        [keyset addObject:keyname];
    }
    if ([self.postParamDictionary objectForKey:kCSIO_Only] != nil) {
        [[self.postParamDictionary objectForKey:kCSIO_Only] setObject:keyset forKey:key];
    } else {
        NSMutableDictionary *keySubDict = [NSMutableDictionary dictionary];
        [keySubDict setObject:keyset forKey:key];
        
        [self.postParamDictionary setObject:keySubDict forKey:kCSIO_Only];
    }
}

- (void)includeRefFieldWithKey:(NSString *)key excludingRefValuesWithKeys:(NSArray *)values {
    [self includeRefFieldWithKey:[NSArray arrayWithObject:key]];
    NSMutableArray *keyset = [NSMutableArray array];
    for (id keyname in values) {
        [keyset addObject:keyname];
    }
    if ([self.postParamDictionary objectForKey:kCSIO_Except] != nil) {
        [[self.postParamDictionary objectForKey:kCSIO_Except] setObject:keyset forKey:key];
    } else {
        NSMutableDictionary *keySubDict = [NSMutableDictionary dictionary];
        [keySubDict setObject:keyset forKey:key];
        [self.postParamDictionary setObject:keySubDict forKey:kCSIO_Except];
    }
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
//MARK: - Asset -

- (Asset *)assetForKey:(NSString *)key {
    id obj = [self.objectProperties objectForKey:key];
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)obj;
        return [self assetFile:dict];
    }
    return nil;
}

- (NSArray *)assetsForKey:(NSString *)key {
    NSMutableArray *fileArray = [NSMutableArray array];
    id obj = [self.objectProperties objectForKey:key];
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)obj;
        for (NSDictionary *dict in arr) {
            Asset *file = [self assetFile:dict];
            if (file && ![file isKindOfClass:[NSNull class]]) {
                [fileArray addObject:file];
            }
        }
    }
    return fileArray;
}

- (Asset *)assetFile:(NSDictionary *)dict {
    Asset *file = [self.contentType.stack asset];
    [file configureWithDictionary:dict];
    return file;
}

//MARK: Group

-(Group*)groupForKey:(NSString*)key {
    id obj = [self.objectProperties objectForKey:key];
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)obj;
        Group *group = [[Group alloc] initWithStack:self.contentType.stack andField:key];
        [group configureWithDictionary:dict];
        return group;
    }
    return nil;
}

- (NSArray*)groupsForKey:(NSString*)key{
    id obj = [self.objectProperties objectForKey:key];
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *groupArray = [NSMutableArray array];
        [obj enumerateObjectsUsingBlock:^(NSDictionary *grpDict, NSUInteger idx, BOOL * _Nonnull stop) {
            Group *grp = [[Group alloc] initWithStack:self.contentType.stack];
            [grp configureWithDictionary:grpDict];
            [groupArray addObject:grp];
        }];
        return groupArray;
    }
    return nil;
}

//MARK: Entries

- (NSArray *)entriesForKey:(NSString *)referenceKey withContentType:(NSString *)contentTypeName {
    if ([self.objectProperties objectForKey:referenceKey]) {
        NSMutableArray *objectsArray = (NSMutableArray *)[self.objectProperties objectForKey:referenceKey];
        if (![objectsArray isKindOfClass:[NSArray class]]) {
            return nil;
        }
        NSMutableArray *entries = [NSMutableArray array];
        [objectsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ContentType *contentType = [self.contentType.stack contentTypeWithName:contentTypeName];
            Entry *entryObj = [[Entry alloc] initWithContentType:contentType];
            [entryObj configureWithDictionary:obj];
            [entries addObject:entryObj];
        }];
        return entries;
    }
    return nil;
}

//MARK: - Description -

- (NSString *)description{
    if (self.objectProperties.count) {
        return [NSString stringWithFormat:@"%@ \r %@", [super description], self.objectProperties];
    }
    
    return [super description];
}

//MARK: - KVC -
-(id)valueForKey:(NSString *)key {
    return [self.objectProperties valueForKey:key];
}

-(id)valueForKeyPath:(NSString *)keyPath {
    return [self.objectProperties valueForKeyPath:keyPath];
}

-(NSDictionary<NSString *,id> *)dictionaryWithValuesForKeys:(NSArray<NSString *> *)keys {
    NSMutableDictionary *valDict = [NSMutableDictionary dictionary];
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id val = [self.objectProperties valueForKey:obj];
        [valDict setObject:val forKey:obj];
    }];
    
    return valDict;
}

- (id)valueForUndefinedKey:(NSString *)key {
    return @{key: @"No such key exist"};
}

//MARK: - Subcripting -

- (id)objectForKey:(NSString *)key {
    if (self.objectProperties) {
        return [self.objectProperties objectForKey:key];
    }
    return nil;
}

- (id)objectForKeyedSubscript:(id <NSCopying>)key;{
    id idKey = (id) key;
    if (![idKey respondsToSelector: @selector(componentsSeparatedByString:)]) {
        return nil;
    }
    return [self objectForKey:idKey];
}

//MARK: - Fetch -

- (void)fetch:(void(^)(ResponseType type, NSError * BUILT_NULLABLE_P error))callback {
    
    [self cancelRequest];
    
    [self.postParamDictionary setObject:self.contentType.stack.environment forKey:kCSIO_Environment];
   
    NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionaryWithDictionary:self.postParamDictionary];

    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:self.contentType.headers];
    [headers addEntriesFromDictionary:self.localHeaders];
    
    NSString *path = [CSIOAPIURLs fetchEntryURLWithContentTypeUID:[self.contentType name] entryUID:self.uid withVersion:self.contentType.stack.version];
    
    self.requestOperation = [self.contentType.stack.network requestForStack:self.contentType.stack withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:paramDictionary additionalHeaders:headers cachePolicy:self.cachePolicy completion:^(ResponseType responseType, id responseJSON, NSError *error) {
        if (error) {
            callback(responseType,error);
        }else {
            [self configureWithDictionary:[responseJSON objectForKey:kCSIO_Entry]];
            callback(responseType, nil);
        }
    }];
    
}

//MARK: - Cancel -

- (void)cancelRequest {
    if (self.requestOperation.isExecuting) {
        [self.requestOperation cancel];
    }
}

//MARK: - Properties
-(NSDictionary *)properties {
    return self.objectProperties;
}

@end
