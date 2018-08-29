//
//  Query.m
//  Contentstack
//
//  Created by Reefaq on 22/06/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import "Query.h"
#import "AFNetworking.h"
#import "ISO8601DateFormatter.h"
#import "CSIOConstants.h"
#import "CSIOAPIURLs.h"
#import "QueryResult.h"
#import "ContentType.h"
#import "CSIOInternalHeaders.h"
#import "NSObject+Extensions.h"

static NSString *kOR = @"$or";
static NSString *kAND = @"$and";
static NSString *kNOT = @"$not";
static NSString *kHAVING = @"$in_query";
static NSString *kNOT_HAVING = @"$nin_query";

@interface Query()
@property (nonatomic, strong) NSMutableDictionary* localHeaders;
@property (nonatomic, strong) NSMutableSet *requestOperationSet;
@end

@implementation Query

- (instancetype)initWithContentType:(ContentType*)contentType {
    if (self = [super init]) {
        _contentType = contentType;
        _localHeaders = [NSMutableDictionary dictionary];
        _queryDictionary = [NSMutableDictionary dictionary];
        _requestOperationSet = [NSMutableSet set];
        
    }
    return self;
}

//MARK: - Headers

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

//MARK: - Language -
- (void)language:(Language)language {
    [self.queryDictionary setObject:[self localeCode:(NSUInteger)language] forKey:kCSIO_Locale];
}

//MARK: - Search -
- (void)search:(NSString*)searchString {
    // [self prepareQuerywithOperation:nil subKey:kCSIO_Typeahead forKey:kCSIO_Queryable withObject:searchString];
    [self.queryDictionary setObject:searchString forKey:kCSIO_Typeahead];
}

//MARK: - Tags -
- (void)tags:(NSArray*)tagsArray {
    for (id tags in tagsArray) {
        if (![tags isKindOfClass:[NSString class]]) {
            [NSException raise:@"Error" format:@"Found type other than String in tags. Tags must be collection of Strings."];
            return;
        }
    }
    [self.queryDictionary setObject:[tagsArray componentsJoinedByString:@","] forKey:kCSIO_Tags];
}

////MARK: - Before/After UID -
//- (void)beforeUID:(NSString *)uid {
//    [self.queryDictionary setObject:uid forKey:kCSIO_BeforeUID];
//}
//
//- (void)afterUID:(NSString *)uid {
//    [self.queryDictionary setObject:uid forKey:kCSIO_AfterUID];
//}

//MARK: - AND OR -
- (void)orWithSubqueries:(NSArray *)queries {
    [self prepareComplexQueryWithQueries:queries andOperation:kOR];
}

- (void)andWithSubqueries:(NSArray *)queries {
    [self prepareComplexQueryWithQueries:queries andOperation:kAND];
}

//MARK: - Sorting -
- (void)orderByAscending:(NSString *)key {
    [self.queryDictionary setObject:key forKey:kCSIO_Ascending];
}

- (void)orderByDescending:(NSString *)key {
    [self.queryDictionary setObject:key forKey:kCSIO_Descending];
}

//MARK: - Include -
- (void)objectsCount {
    [self.queryDictionary setObject:@"true" forKey:kCSIO_Count];
}

- (void)includeSchema {
    if ([self.queryDictionary valueForKey:kCSIO_IncludeContentType] == nil){
        [self.queryDictionary setObject:@"true" forKey:kCSIO_IncludeSchema];
    }
}

- (void)includeContentType {
    if ([self.queryDictionary valueForKey:kCSIO_IncludeSchema] != nil){
        [self.queryDictionary  removeObjectForKey:kCSIO_IncludeSchema];
    }
    [self.queryDictionary setObject:@"true" forKey:kCSIO_IncludeContentType];
}


- (void)includeOwner {
    [self.queryDictionary setObject:@"true" forKey:kCSIO_IncludeUser];
}

- (void)includeCount {
    [self.queryDictionary setObject:@"true" forKey:kCSIO_IncludeCount];
}

//MARK: - Pagination -
- (void)limitObjects:(NSNumber *)number {
    [self.queryDictionary setObject:number forKey:kCSIO_Limit];
}

- (void)skipObjects:(NSNumber *)number {
    [self.queryDictionary setObject:number forKey:kCSIO_Skip];
}

//MARK: - Query Params -
- (void)addQueryWithKey:(NSString *)key andValue:(id)value {
    [self.queryDictionary setObject:value forKey:key];
}

- (void)addQueryParams:(NSDictionary *)queryDict {
    self.queryDictionary = [queryDict mutableCopy];
}

- (void)removeQueryWithKey:(NSString *)key {
    [self.queryDictionary removeObjectForKey:key];
}

//MARK: - Conditions -
- (void)onlyFields:(NSArray *)fieldUIDs {
    NSMutableArray *keybundle = [NSMutableArray array];
    for (id keyname in fieldUIDs) {
        [keybundle addObject:keyname];
    }
    if ([self.queryDictionary objectForKey:kCSIO_Only] != nil) {
        [[self.queryDictionary objectForKey:kCSIO_Only] setObject:fieldUIDs forKey:kCSIO_BASE];
    } else {
        NSMutableDictionary *keySubDict = [NSMutableDictionary dictionary];
        [keySubDict setObject:fieldUIDs forKey:kCSIO_BASE];
        [self.queryDictionary setObject:keySubDict forKey:kCSIO_Only];
    }
}

- (void)exceptFields:(NSArray *)fieldUIDs {
    NSMutableArray *keybundle = [NSMutableArray array];
    for (id keyname in fieldUIDs) {
        [keybundle addObject:keyname];
    }
    if ([self.queryDictionary objectForKey:kCSIO_Except] != nil) {
        [[self.queryDictionary objectForKey:kCSIO_Except] setObject:fieldUIDs forKey:kCSIO_BASE];
    } else {
        NSMutableDictionary *keySubDict = [NSMutableDictionary dictionary];
        [keySubDict setObject:fieldUIDs forKey:kCSIO_BASE];
        [self.queryDictionary setObject:keySubDict forKey:kCSIO_Except];
    }
}

- (void)whereKey:(NSString *)key equalTo:(id)object {
    [self prepareQuerywithOperation:nil subKey:key forKey:kCSIO_Queryable withObject:object];
}

- (void)whereKey:(NSString *)key notEqualTo:(id)object {
    [self prepareQuerywithOperation:kCSIO_NotEqualTo subKey:key forKey:kCSIO_Queryable withObject:object];
}

- (void)whereKey:(NSString *)key lessThan:(id)object {
    [self prepareQuerywithOperation:kCSIO_LessThan subKey:key forKey:kCSIO_Queryable withObject:object];
}

- (void)whereKey:(NSString *)key greaterThan:(id)object {
    [self prepareQuerywithOperation:kCSIO_GreaterThan subKey:key forKey:kCSIO_Queryable withObject:object];
}

- (void)whereKey:(NSString *)key lessThanOrEqualTo:(id)object {
    [self prepareQuerywithOperation:kCSIO_LessThanEqualTo subKey:key forKey:kCSIO_Queryable withObject:object];
}

- (void)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object {
    [self prepareQuerywithOperation:kCSIO_GreaterThanEqualTo subKey:key forKey:kCSIO_Queryable withObject:object];
}

- (void)whereKey:(NSString *)key containedIn:(NSArray *)array {
    [self prepareQuerywithOperation:kCSIO_ContainedIn subKey:key forKey:kCSIO_Queryable withObject:array];
}

- (void)whereKey:(NSString *)key notContainedIn:(NSArray *)array {
    [self prepareQuerywithOperation:kCSIO_NotContainedIn subKey:key forKey:kCSIO_Queryable withObject:array];
}

- (void)whereKeyExists:(NSString *)key {
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    [subDict setObject:@(YES) forKey:kCSIO_Exists];
    [self prepareQuerywithOperation:nil subKey:key forKey:kCSIO_Queryable withObject:subDict];
}

- (void)whereKeyDoesNotExist:(NSString *)key {
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    [subDict setObject:@(NO) forKey:kCSIO_Exists];
    [self prepareQuerywithOperation:nil subKey:key forKey:kCSIO_Queryable withObject:subDict];
}

- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex {
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    [subDict setObject:regex forKey:kCSIO_Regex];
    [self prepareQuerywithOperation:nil subKey:key forKey:kCSIO_Queryable withObject:subDict];
}

- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex modifiers:(NSString *)modifier {
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    [subDict setObject:regex forKey:kCSIO_Regex];
    [subDict setObject:modifier forKey:kCSIO_Options];
    [self prepareQuerywithOperation:nil subKey:key forKey:kCSIO_Queryable withObject:subDict];
}

- (void)includeReferenceFieldWithKey:(NSArray *)key {
    if ([self.queryDictionary objectForKey:kCSIO_Include] != nil) {
        for (NSString *incKey in key)
            [[self.queryDictionary objectForKey:kCSIO_Include] addObject:incKey];
    } else {
        NSMutableArray *arrayInclude = [NSMutableArray array];
        [arrayInclude addObjectsFromArray:key];
        [self.queryDictionary setObject:arrayInclude forKey:kCSIO_Include];
    }
}

- (void)includeReferenceFieldWithKey:(NSString *)key onlyFields:(NSArray *)fieldUIDs {
    [self includeReferenceFieldWithKey:[NSArray arrayWithObject:key]];
    NSMutableArray *keyset = [NSMutableArray array];
    for (id keyname in fieldUIDs) {
        [keyset addObject:keyname];
    }
    if ([self.queryDictionary objectForKey:kCSIO_Only] != nil) {
        [[self.queryDictionary objectForKey:kCSIO_Only] setObject:keyset forKey:key];
    } else {
        NSMutableDictionary *keySubDict = [NSMutableDictionary dictionary];
        [keySubDict setObject:keyset forKey:key];
        
        [self.queryDictionary setObject:keySubDict forKey:kCSIO_Only];
    }
}

- (void)includeReferenceFieldWithKey:(NSString *)key excludingFields:(NSArray *)fieldUIDs {
    [self includeReferenceFieldWithKey:[NSArray arrayWithObject:key]];
    NSMutableArray *keyset = [NSMutableArray array];
    for (id keyname in fieldUIDs) {
        [keyset addObject:keyname];
    }
    if ([self.queryDictionary objectForKey:kCSIO_Except] != nil) {
        [[self.queryDictionary objectForKey:kCSIO_Except] setObject:keyset forKey:key];
    } else {
        NSMutableDictionary *keySubDict = [NSMutableDictionary dictionary];
        [keySubDict setObject:keyset forKey:key];
        [self.queryDictionary setObject:keySubDict forKey:kCSIO_Except];
    }
}

- (void)addParamKey:(NSString *)key andValue:(NSString *)value{
    if (key != nil){
        if ([self.queryDictionary objectForKey:key] != nil) {
            [self.queryDictionary removeObjectForKey:key];
            [self.queryDictionary setObject:value forKey:key];
        } else {
            [self.queryDictionary setObject:value forKey:key];
        }
    }
}


//MARK: - Helper -
- (void)prepareComplexQueryWithQueries:(NSArray *)queries andOperation:(NSString *)operation {
    NSMutableArray *queriesArray = [NSMutableArray array];
    [queries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Query *query = (Query *)obj;
        if ([query.queryDictionary objectForKey:kCSIO_Queryable] != nil) {
            NSMutableDictionary *queriesDictionary = [query.queryDictionary objectForKey:kCSIO_Queryable];
            [queriesDictionary removeObjectForKey:kCSIO_HTTPMethod];
            [queriesArray addObject:queriesDictionary];
        } else {
            NSMutableDictionary *queriesDictionary = query.queryDictionary;
            [queriesDictionary removeObjectForKey:kCSIO_HTTPMethod];
            [queriesArray addObject:queriesDictionary];
        }
    }];
    [self prepareQuerywithOperation:operation subKey:nil forKey:kCSIO_Queryable withObject:queriesArray];
}


// This method prepares nested query response body.
- (void)prepareQuerywithOperation:(NSString *)operation subKey:(NSString *)subKey forKey:(NSString *)key withObject:(id)object {
    if (key==nil) { return; }
    
    if ([key isEqualToString:kCSIO_Queryable]) {
        if ([self.queryDictionary objectForKey:kCSIO_Queryable] != nil) {
            if (subKey != nil) {
                if ([[self.queryDictionary objectForKey:kCSIO_Queryable] objectForKey:subKey] != nil) {
                    //subkey not in dictionary
                    //key already in dictionary
                    if ([operation isEqualToString:kCSIO_ContainedIn] || [operation isEqualToString:kCSIO_NotContainedIn]) {
                        if ([[[self.queryDictionary objectForKey:kCSIO_Queryable] objectForKey:subKey] objectForKey:operation] != nil) {
                            NSArray *objectArray = [object isKindOfClass:[NSArray class]] == true ? (NSArray *)object : nil;
                            if (![objectArray isKindOfClass:[NSNull class]]) {
                                [objectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                    [(NSMutableArray *)[[[self.queryDictionary objectForKey:kCSIO_Queryable] objectForKey:subKey] objectForKey:operation] addObject:obj];
                                }];
                            } else {
                                [(NSMutableArray *)[[[self.queryDictionary objectForKey:kCSIO_Queryable] objectForKey:subKey] objectForKey:operation] addObject:object];
                            }
                        } else {
                            NSMutableArray *incArray = [NSMutableArray arrayWithArray:object];
                            [incArray addObject:object];
                            
                            NSMutableDictionary *includeDict = [NSMutableDictionary dictionary];
                            [includeDict setObject:incArray forKey:operation];
                            
                            [[[self.queryDictionary objectForKey:kCSIO_Queryable] objectForKey:subKey] setObject:incArray forKey:operation];
                        }
                        
                    } else {
                        if (operation != nil) {
                            NSMutableDictionary *includeDict = [NSMutableDictionary dictionary];
                            [includeDict setObject:object forKey:operation];
                            [[self.queryDictionary objectForKey:kCSIO_Queryable] setObject:includeDict forKey:subKey];
                        }else {
                            [[self.queryDictionary objectForKey:kCSIO_Queryable] setObject:object forKey:subKey];
                        }
                    }
                } else {
                    //subkey not in dictionary
                    if ([operation isEqualToString:kCSIO_ContainedIn] || [operation isEqualToString:kCSIO_NotContainedIn]){
                        NSMutableArray *incArray = [NSMutableArray array];
                        NSArray *objectArray = [object isKindOfClass:[NSArray class]] == true ? (NSArray *)object : nil;
                        if (![objectArray isKindOfClass:[NSNull class]]) {
                            [objectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                [incArray addObject:obj];
                            }];
                        } else {
                            [incArray addObject:object];
                        }
                        
                        NSMutableDictionary *includeDict = [NSMutableDictionary dictionary];
                        [includeDict setObject:incArray forKey:operation];
                        
                        NSMutableDictionary *queryableDict = [NSMutableDictionary dictionary];
                        [queryableDict setObject:includeDict forKey:subKey];
                        
                        [[self.queryDictionary objectForKey:key] setObject:includeDict forKey:subKey];
                        
                    } else {
                        if (operation != nil) {
                            NSMutableDictionary *includeDict = [NSMutableDictionary dictionary];
                            [includeDict setObject:object forKey:operation];
                            [[self.queryDictionary objectForKey:kCSIO_Queryable] setObject:includeDict forKey:subKey];
                        } else {
                            [[self.queryDictionary objectForKey:kCSIO_Queryable] setObject:object forKey:subKey];
                        }
                    }
                }
            } else {
                [[self.queryDictionary objectForKey:kCSIO_Queryable]setObject:object forKey:operation];
            }
            
        } else {
            //if kCSIO_Queryable is not present
            
            if ([operation isEqualToString:kCSIO_ContainedIn] || [operation isEqualToString:kCSIO_NotContainedIn]) {
                NSMutableArray *incArray = [NSMutableArray array];
                NSArray *objectArray = [object isKindOfClass:[NSArray class]] == true ? (NSArray *)object : nil;
                if (![objectArray isKindOfClass:[NSNull class]]) {
                    [objectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [incArray addObject:obj];
                    }];
                } else {
                    [incArray addObject:object];
                }
                
                NSMutableDictionary *includeDict = [NSMutableDictionary dictionary];
                [includeDict setObject:incArray forKey:operation];
                NSMutableDictionary *queryableDict = [NSMutableDictionary dictionary];
                [queryableDict setObject:includeDict forKey:subKey];
                
                [self.queryDictionary setObject:queryableDict forKey:kCSIO_Queryable];
            } else {
                if (subKey == nil) {
                    NSMutableDictionary *secondLeveldict = [NSMutableDictionary dictionary];
                    [secondLeveldict setObject:object forKey:operation];// OR dictionary
                    [self.queryDictionary setObject:secondLeveldict forKey:kCSIO_Queryable];
                } else {
                    if (operation != nil) {
                        NSMutableDictionary *secondLeveldict = [NSMutableDictionary dictionary];
                        [secondLeveldict setObject:object forKey:operation];
                        NSMutableDictionary *firstLeveldict = [NSMutableDictionary dictionary];
                        [firstLeveldict setObject:secondLeveldict forKey:subKey];
                        [self.queryDictionary setObject:firstLeveldict forKey:kCSIO_Queryable];
                    } else {
                        NSMutableDictionary *firstLeveldict = [NSMutableDictionary dictionary];
                        [firstLeveldict setObject:object forKey:subKey];
                        [self.queryDictionary setObject:firstLeveldict forKey:kCSIO_Queryable];
                    }
                }
            }
        }
    } else if([key isEqualToString:@"where"]) {
        if ([self.queryDictionary objectForKey:@"where"] != nil) {
            [[self.queryDictionary objectForKey:@"where"] setObject:object forKey:subKey];
        } else {
            NSMutableDictionary *whereSubDict = [NSMutableDictionary dictionary];
            [whereSubDict setObject:object forKey:subKey];
            [self.queryDictionary setObject:whereSubDict forKey:@"where"];
        }
    }
}

//MARK: Execute Query -

- (void)find:(void (^) (ResponseType type,QueryResult * BUILT_NULLABLE_P result,NSError * BUILT_NULLABLE_P error))completionBlock {
    
    [self.queryDictionary setObject:self.contentType.stack.environment forKey:kCSIO_Environment];
    
    NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionaryWithDictionary:self.queryDictionary];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:self.contentType.headers];

    [headers addEntriesFromDictionary:self.localHeaders];
    
    NSString *path = [CSIOAPIURLs fetchContentTypeEntriesQueryURLWithUID:[self.contentType name] withVersion:self.contentType.stack.version];
    
    AFHTTPRequestOperation *op = [self.contentType.stack.network requestForStack:self.contentType.stack withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:paramDictionary additionalHeaders:headers cachePolicy:self.cachePolicy completion:^(ResponseType responseType, id responseJSON, NSError *error) {

        if (error) {
            completionBlock(responseType, nil, error);
        }else {
            QueryResult *queryResult = [[QueryResult alloc] initWithContentType:self.contentType objectDictionary:responseJSON];

            completionBlock(responseType, queryResult, nil);
        }
    }];
    if (op && ![op isKindOfClass:[NSNull class]]) {
        [self.requestOperationSet addObject:op];
    }
}

- (void)findOne:(void (^) (ResponseType type,Entry * BUILT_NULLABLE_P entry,NSError * BUILT_NULLABLE_P error))completionBlock {
    [self.queryDictionary setObject:@(1) forKey:kCSIO_Limit];
    
    [self.queryDictionary setObject:self.contentType.stack.environment forKey:kCSIO_Environment];

    NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionaryWithDictionary:self.queryDictionary];

    [self.queryDictionary removeObjectForKey:kCSIO_Limit];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:self.contentType.headers];
    [headers addEntriesFromDictionary:self.localHeaders];
    
    NSString *path = [CSIOAPIURLs fetchContentTypeEntriesQueryURLWithUID:[self.contentType name] withVersion:self.contentType.stack.version];
    
    AFHTTPRequestOperation *op = [self.contentType.stack.network requestForStack:self.contentType.stack withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:paramDictionary additionalHeaders:headers cachePolicy:self.cachePolicy completion:^(ResponseType responseType, id responseJSON, NSError *error) {
        if (error) {
            completionBlock(responseType, nil, error);
        }else {
            QueryResult *queryResult = [[QueryResult alloc] initWithContentType:self.contentType objectDictionary:responseJSON];
            if ([queryResult getResult].count) {
                Entry *firstEntry = (Entry*)[[queryResult getResult] firstObject];
                completionBlock(responseType, firstEntry, nil);
            }else {
                completionBlock(responseType, nil, nil);
            }
        }
    }];
    if (op && ![op isKindOfClass:[NSNull class]]) {
        [self.requestOperationSet addObject:op];
    }
}

//MARK: - Cancel request -

- (void)cancelRequests {
    [self.requestOperationSet enumerateObjectsUsingBlock:^(AFHTTPRequestOperation *op, BOOL *stop) {
        [op cancel];
    }];
}

//MARK: - Description -

- (NSString *)description {
    NSString *descr = [NSString stringWithFormat:@"%@ \r %@", [super description], self.queryDictionary];
    return descr;
}


@end
