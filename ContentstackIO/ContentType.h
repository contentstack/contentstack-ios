//
//  ContentType.h
//  Contentstack
//
//  Created by Reefaq on 22/06/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentstackDefinitions.h"

@class Entry;
@class Query;
@class Asset;

BUILT_ASSUME_NONNULL_BEGIN

@interface ContentType : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

//MARK: Manually set headers -
/**---------------------------------------------------------------------------------------
 * @name Manually set headers
 *  ---------------------------------------------------------------------------------------
 */

/**
Set a header for ContentType
 
     //Obj-C
     [contentTypeObj setHeader:@"MyValue" forKey:@"My-Custom-Header"];

     //Swift
     contentTypeObj.setHeader("MyValue", forKey: "My-Custom-Header")

@param headerValue  The header key
@param headerKey    The header value
*/
- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey;

/**
Set a header for ContentType
 
     //Obj-C
     [contentTypeObj addHeadersWithDictionary:@{@"My-Custom-Header": @"MyValue"}];
     
     //Swift
     contentTypeObj.addHeadersWithDictionary(["My-Custom-Header":"MyValue"])
 
 
 @param headers The headers as dictionary which needs to be added to the application
 */
- (void)addHeadersWithDictionary:(NSDictionary *)headers;

/**
Removes a header from this ContentType.
 
     //Obj-C
     [contentTypeObj removeHeaderForKey:@"My-Custom-Header"];
     
     //Swift
     contentTypeObj.removeHeaderForKey("My-Custom-Header")
 
 @param headerKey The header key that needs to be removed
 */
- (void)removeHeaderForKey:(NSString *)headerKey;

//MARK: - Entry with UID -
/**---------------------------------------------------------------------------------------
 * @name Entry
 *  ---------------------------------------------------------------------------------------
 */

/**
Gets the new instance of Entry object with specified UID.

     //Obj-C
     Entry *entryObj = [contentTypeObj entryWithUID:@"bltf4fsamplec851db"];
     
     //Swift
     var entryObj:Entry = contentTypeObj.entryWithUID("bltf4fsamplec851db")

 
 @param uid uid of the Entry object to fetch.
 @return new instance of Entry with uid.
 */
- (Entry*)entryWithUID:(NSString*)uid;

//MARK: - Query -
/**---------------------------------------------------------------------------------------
 * @name Query
 *  ---------------------------------------------------------------------------------------
 */

/**
Represents a Query on 'ContentType' which can be executed to retrieve entries that pass the query condition

     //Obj-C
     Query *queryObj = [contentTypeObj query];
     
     //Swift
     var queryObj:Query = contentTypeObj.query()
 
 @return Returns new Query instance
 */
- (Query*)query;

@end

BUILT_ASSUME_NONNULL_END
