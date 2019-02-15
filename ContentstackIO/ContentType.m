//
//  ContentType.m
//  Contentstack
//
//  Created by Reefaq on 22/06/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import "ContentType.h"
#import "CSIOInternalHeaders.h"
#import "Stack.h"
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

- (void)addHeadersWithDictionary:(NSDictionary *)headers {
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.headers setObject:obj forKey:key];
    }];
}

- (void)removeHeaderForKey:(NSString *)headerKey {
    if (self.headers[headerKey]) {
        [self.headers removeObjectForKey:headerKey];
    }
}


@end
