//
//  NSObject+Extensions.h
//  Contentstack
//
//  Created by Reefaq on 13/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>

//MARK: - NSObject Extension

@interface NSObject (Extensions)
- (NSArray *)networkErrorCodes;
- (void)assertPropertyTypes:(NSDictionary *)properties;

- (NSDictionary *)dictionaryFromJSONData:(NSData *)data;
- (NSData *)jsonDataFromDictonary:(NSDictionary *)dic;
- (NSString *)jsonStringFromDictonary:(NSDictionary *)dic;
- (NSArray *)arrayFromJSONData:(NSData *)data;
- (NSString *)jsonStringFromArray:(NSArray*)array;

- (NSString*)localeCode:(NSUInteger)locale;
- (NSUInteger)indexOfLocaleCodeString:(NSString*)locale;

-(NSString*)publishType:(NSUInteger)publishType;

+ (void)performAndWait:(void (^)(dispatch_semaphore_t semaphore))perform;

@end
