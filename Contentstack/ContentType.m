//
//  ContentType.m
//  Contentstack
//
//  Created by Reefaq on 22/06/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import "ContentType.h"
#import "CSIOInternalHeaders.h"
#import "CSIOConstants.h"
#import "CSIOCoreHTTPNetworking.h"
#import "CSIOAPIURLs.h"
#import "NSObject+Extensions.h"
#import <Contentstack/Stack.h>
#import "Query.h"
#import "Entry.h"
#import "Asset.h"
#import "AssetLibrary.h"

@interface ContentType ()
@property (nonatomic, strong, getter=stack) Stack *csStack;
@end

@implementation ContentType

-(instancetype)initWithStack:(Stack*)stack withName:(NSString*)contentTypeName {
    if (self= [super init]) {
        _csStack = stack;
        _name = contentTypeName;
        _postParamDictionary = [NSMutableDictionary dictionary];
        _headers = [NSMutableDictionary dictionary];
    }
    return self;
}

-(Entry*)entry {
    Entry *entry = [[Entry alloc] initWithContentType:self];
    return entry;
}

-(Entry*)entryWithUID:(NSString*)uid; {
    Entry *entry = [[Entry alloc] initWithContentType:self withEntryUID:uid];
    return entry;
}

-(Query*)query {
    Query *query = [[Query alloc] initWithContentType:self];
    return query;
}

//MARK: - Headers

- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey {
    [self.headers setObject:headerValue forKey:headerKey];
}

- (void)addHeadersWithDictionary:(NSDictionary<NSString *, NSString *> *)headers {
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.headers setObject:obj forKey:key];
    }];
}

- (void)removeHeaderForKey:(NSString *)headerKey {
    if (self.headers[headerKey]) {
        [self.headers removeObjectForKey:headerKey];
    }
}

//MARK: - Get ContentTypes

- (void)fetch:(NSDictionary<NSString *,id> * _Nullable)params completion:(void (^)(NSDictionary<NSString *,NSString *> * _Nullable, NSError * _Nullable))completionBlock {
    NSString *path = [CSIOAPIURLs fetchContenTypeSchema:self.name withVersion:self.stack.version];
    [self.postParamDictionary setObject:_csStack.environment forKey:kCSIO_Environment];
    
    NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionaryWithDictionary:self.postParamDictionary];
    for (NSString* key in params) {
        [paramDictionary setValue:[params valueForKey:key] forKey:key];
    }
    NSURLSessionDataTask *op = [self.stack.network requestForStack:self.stack withURLPath:path requestType:CSIOCoreNetworkingRequestTypeGET params:paramDictionary additionalHeaders:self.stack.stackHeaders completion:^(ResponseType responseType, id responseJSON, NSError *error) {
        if (completionBlock) {
            if (error) {
                completionBlock(nil, error);
            }else {
                NSDictionary *responseData = responseJSON;
                if ([[responseData allKeys] containsObject:@"content_type"] && [responseData objectForKey:@"content_type"] != nil && [[responseData objectForKey:@"content_type"] isKindOfClass:[NSDictionary class]]) {
                    completionBlock([responseData objectForKey:@"content_type"], nil);
                }else {
                    NSError *error = [NSError errorWithDomain:@"Error" code:-4001 userInfo:@{@"error": @"Failed to retreive data."}];
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
