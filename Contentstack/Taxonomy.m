//
//  Taxonomy.m
//  Contentstack
//
//  Created by Vikram Kalta on 27/07/2024.
//  Copyright © 2024 Contentstack. All rights reserved.
//

#import "Taxonomy.h"
#import "CSIOInternalHeaders.h"
#import "CSIOConstants.h"
#import "CSIOCoreHTTPNetworking.h"
#import "CSIOAPIURLs.h"
#import "NSObject+Extensions.h"
#import "Stack.h"
#import "Query.h"

@interface Taxonomy ()
@property (nonatomic, strong, getter=stack) Stack *csStack;
@end

@implementation Taxonomy

-(instancetype)initWithStack:(Stack*)stack {
    if (self = [super init]) {
        _csStack = stack;
        _postParamDictionary = [NSMutableDictionary dictionary];
        _headers = [NSMutableDictionary dictionary];
    }
    return self;
}

-(Entry*)entry {
    Entry *entry = [[Entry alloc] initWithTaxonomy:self];
    return entry;
}

-(Query*)query {
    Query *query = [[Query alloc] initWithTaxonomy:self];
    return query;
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
//MARK: - Get entries
- (void)fetch:(NSDictionary<NSString *, id> * _Nullable)params completion:(void (^)(NSDictionary<NSString *,NSString *> * _Nullable,
                                                                                    NSError * _Nullable))completionBlock {
    NSString *path = [CSIOAPIURLs fetchTaxonomyWithVersion:self.stack.version];
    [self.postParamDictionary setObject:_csStack.environment forKey:kCSIO_Environment];
    NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionaryWithDictionary:self.postParamDictionary];
    for (NSString* key in params) {
        [paramDictionary setValue:[params valueForKey:key] forKey:key];
    }
    NSURLSessionDataTask *op = [self.stack.network requestForStack:self.stack withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:paramDictionary additionalHeaders:self.stack.stackHeaders  completion:^(ResponseType responseType, id responseJSON, NSError *error) {
        if (completionBlock) {
            if (error) {
                completionBlock(nil, error);
            } else {
                NSDictionary *responseData = responseJSON;
                if ([[responseData allKeys] containsObject:@"entries"] && [responseData objectForKey:@"entries"] != nil && [[responseData objectForKey:@"entries"] isKindOfClass:[NSDictionary class]]) {
                    completionBlock([responseData objectForKey:@"entries"], nil);
                } else {
                    NSError *error = [NSError errorWithDomain:@"Error" code:-4001 userInfo:@{@"error": @"Failed to retrieve data"}];
                    completionBlock(nil, error);
                }
            }
        }
    }];

    if (op && ![op isKindOfClass:[NSNull class]]) {
        [self.stack.requestOperationSet addObject:op];
    }
}
@end
