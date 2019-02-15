//
//  QueryResult.m
//  Contentstack
//
//  Created by Reefaq on 11/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import "QueryResult.h"
#import "CSIOInternalHeaders.h"
#import "CSIOConstants.h"
#import "ContentType.h"
#import "Entry.h"

@interface QueryResult ()
@property (nonatomic, strong) NSMutableDictionary *resultsDictionary;

@end

@implementation QueryResult

- (instancetype)initWithContentType:(ContentType*)contentType objectDictionary:(NSDictionary*)dictionary{
    if (self = [super init]) {
        self.contentType = contentType;
        self.resultsDictionary = [NSMutableDictionary dictionary];
        if (dictionary) {
            [self.resultsDictionary addEntriesFromDictionary:dictionary];
        }
    }
    return self;
}

- (NSInteger)totalCount {
    
    if ([self.resultsDictionary objectForKey:kCSIO_Count]) {
        if ([[self.resultsDictionary objectForKey:kCSIO_Count] isKindOfClass:[NSNumber class]]) {
            NSInteger count = [[self.resultsDictionary objectForKey:kCSIO_Count] integerValue];
            return count;
        }
    }
    
    if ([self.resultsDictionary objectForKey:kCSIO_Entries]) {
        if ([[self.resultsDictionary objectForKey:kCSIO_Entries] isKindOfClass:[NSArray class]]) {
            NSInteger count = [[self.resultsDictionary objectForKey:kCSIO_Entries] count];
            return count;
        }
    }
    return 0;
}

//MARK: Result of the Query -

- (NSArray *)getResult{
    if ([self.resultsDictionary objectForKey:kCSIO_Entries] && [[self.resultsDictionary objectForKey:kCSIO_Entries] isKindOfClass:[NSArray class]]) {
        NSArray *objectsArray = (NSArray*)[self.resultsDictionary objectForKey:kCSIO_Entries];
        NSMutableArray *entryObjects = [NSMutableArray array];
        // if condition is fix for value of "entries" key ie.array inside array in response JSON
        if (objectsArray.firstObject && [objectsArray.firstObject isKindOfClass:[NSArray class]]) {
            [objectsArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj enumerateObjectsUsingBlock:^(NSDictionary *objDict, NSUInteger idx, BOOL * _Nonnull stop) {
                    Entry *formEntry = [self.contentType entry];
                    [formEntry configureWithDictionary:objDict];
                    [entryObjects addObject:formEntry];
                }];
            }];
        } else {
            [objectsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *objDict = (NSDictionary *)obj;
                Entry *formEntry = [self.contentType entry];
                [formEntry configureWithDictionary:objDict];
                [entryObjects addObject:formEntry];
            }];
        }
        return entryObjects;
        
    } else {
        return nil;
    }
}

//MARK: Get Schema -

- (NSArray *)schema{
    if ([self.resultsDictionary objectForKey:kCSIO_Schema] && [[self.resultsDictionary objectForKey:kCSIO_Schema] isKindOfClass:[NSArray class]]) {
        NSArray *objectsArray = (NSArray *)[self.resultsDictionary objectForKey:kCSIO_Schema];
        return objectsArray;
    }
    return nil;
}

//MARK: Get content_type -

- (NSDictionary *)content_type{
    if ([self.resultsDictionary objectForKey:kCSIO_ContentType] && [[self.resultsDictionary objectForKey:kCSIO_ContentType] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objectsArray = (NSDictionary *)[self.resultsDictionary objectForKey:kCSIO_ContentType];
        return objectsArray;
    }
    return nil;
}

@end
