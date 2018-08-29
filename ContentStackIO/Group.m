//
//  Group.m
//  contentstack
//
//  Created by Priyanka Mistry on 29/11/16.
//  Copyright © 2016 Contentstack. All rights reserved.
//

#import "Group.h"
#import "CSIOInternalHeaders.h"
#import "CSIOConstants.h"
#import "CSIOAPIURLs.h"
#import "AFNetworking.h"
#import "NSObject+Extensions.h"
#import "MMMarkdown.h"

@interface Group ()
@property (nonatomic, copy) NSString *fieldName;
@property (nonatomic, copy) Stack *stack;

@property (nonatomic, strong) NSMutableDictionary *objectProperties;
@end

@implementation Group

-(instancetype)initWithStack:(Stack *)stack {
    return [self initWithStack:stack andField:nil];
}

- (instancetype)initWithStack:(Stack *)stack andField:(NSString*)field {
    if (self = [super init]) {
        _fieldName = field;
        _stack = stack;
        _objectProperties = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)hasKey:(NSString *)key {
    if ([self.objectProperties objectForKey:key]) {
        return YES;
    }
    return NO;
}

- (Group*)groupForKey:(NSString*)key {
    id obj = [self.objectProperties objectForKey:key];
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)obj;
        Group *group = [[Group alloc] initWithStack:_stack andField:key];
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
           Group *grp = [[Group alloc] initWithStack:_stack];
           [grp configureWithDictionary:grpDict];
           [groupArray addObject:grp];
       }];
       return groupArray;
    }
    return nil;
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
    
    Asset *file = [_stack asset];
    [file configureWithDictionary:dict];
    return file;
}

//MARK: HTML Markdown
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

//MARK: Entry

- (NSArray *)entriesForKey:(NSString *)referenceKey withContentType:(NSString *)contentTypeName {
    if ([self.objectProperties objectForKey:referenceKey]) {
        NSMutableArray *objectsArray = (NSMutableArray *)[self.objectProperties objectForKey:referenceKey];
        if (![objectsArray isKindOfClass:[NSArray class]]) {
            return nil;
        }
        NSMutableArray *entries = [NSMutableArray array];
        [objectsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ContentType *contentType = [_stack contentTypeWithName:contentTypeName];
            Entry *entryObj = [[Entry alloc] initWithContentType:contentType];
            [entryObj configureWithDictionary:obj];
            [entries addObject:entryObj];
        }];
        return entries;
    }
    return nil;
}

- (id)objectForKey:(NSString *)key {
    if (self.objectProperties) {
        return [self.objectProperties objectForKey:key];
    }
    return nil;
}

- (BOOL)containsFieldName{
    if (self.fieldName && self.fieldName.length) {
        return YES;
    }
    return NO;
}

- (NSDictionary*)generatePostParams {
    if ([self containsFieldName]) {
        return @{self.fieldName:self.objectProperties};
    }
    return [self.objectProperties copy];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@",[self generatePostParams]];
}

- (void)configureWithDictionary:(NSDictionary*)dictionary {
    [self.objectProperties removeAllObjects];
    [self.objectProperties addEntriesFromDictionary:dictionary];
}

@end
