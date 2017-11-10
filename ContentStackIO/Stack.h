//
//  Stack.h
//  Contentstack
//
//  Created by Reefaq on 11/07/15.
//  Copyright (c) 2015 Built.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentstackDefinitions.h"

@class Config;
@class ContentType;
@class AssetLibrary;
@class Asset;

BUILT_ASSUME_NONNULL_BEGIN

@interface Stack : NSObject
/**----------------------------------------------------------------------------------------
 * @name Properties
 *-----------------------------------------------------------------------------------------
 */

/**
 *  Readonly property to check value of apikey
 */
@property (nonatomic, copy, readonly) NSString *apiKey;

/**
 *  Readonly property to check value of access token
 */
@property (nonatomic, copy, readonly) NSString *accessToken;

/**
 *  Readonly property to check value of environment provided
 */
@property (nonatomic, copy, readonly) NSString *environment;

/**
 *  Readonly property to check value of config provided
 */
@property (nonatomic, copy, readonly) Config *config;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

//MARK: ContentType -
/**---------------------------------------------------------------------------------------
 * @name ContentType
 *  ---------------------------------------------------------------------------------------
 */

/**
 Gets the new instance of ContentType object with specified name.

    //Obj-C
    ContentType *contentTypeObj = [stack contentTypeWithName:@"blog"];

    //Swift
    var contentTypeObj:ContentType = stack.contentTypeWithName("blog")

 @param contentTypeName name of the contentType to perform action.
 @return instance of ContentType.
 */
- (ContentType*)contentTypeWithName:(NSString*)contentTypeName;

//MARK: Manually set headers -
/**---------------------------------------------------------------------------------------
 * @name Manually set headers
 *  ---------------------------------------------------------------------------------------
 */

/**
 Set a header for Stack
 
    //Obj-C
    [stack setHeader:@"MyValue" forKey:@"My-Custom-Header"];

    //Swift
    stack.setHeader("MyValue", forKey: "My-Custom-Header")
 
 @param headerValue  The header key
 @param headerKey    The header value
 */
- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey;

/**
 Set a header for Stack
 
    //Obj-C
    [stack addHeadersWithDictionary:@{@"My-Custom-Header": @"MyValue"}];

    //Swift
    stack.addHeadersWithDictionary(["My-Custom-Header":"MyValue"])
 
 @param headers The headers as dictionary which needs to be added to the application
 */
- (void)addHeadersWithDictionary:(NSDictionary *)headers;

/**
 Removes a header from this Stack.
 
    //Obj-C
    [stack removeHeaderForKey:@"My-Custom-Header"];

    //Swift
    stack.removeHeaderForKey("My-Custom-Header")
 
 @param headerKey The header key that needs to be removed
 */
- (void)removeHeaderForKey:(NSString *)headerKey;


//MARK: Asset and AssetLibrary -
/**---------------------------------------------------------------------------------------
 * @name Asset and AssetLibrary
 *  ---------------------------------------------------------------------------------------
 */

/**
 Represents a Asset on 'Stack' which can be executed to get AssetLibrary object
 
     //Obj-C
     AssetLibrary *assetLib = [stack assetLibrary];
     
     //Swift
     var assetLib: AssetLibrary = stack.assetLibrary()
 
 @return Returns new AssetLibrary instance
 */

-(AssetLibrary*)assetLibrary;

/**
 Represents a Asset on 'Stack' which can be executed to get Asset object
 
     //Obj-C
     Asset *assetObj = [stack asset];
     
     //Swift
     var assetObj:Asset = stack.asset()
 
 @return Returns new Asset instance
 */

-(Asset*)asset;

/**
 Gets the new instance of Asset object with specified UID.
 
     //Obj-C
     Asset *assetObj = [contentTypeObj assetWithUID:@"bltf4fsamplec851db"];
     
     //Swift
     var assetObj:Asset = contentTypeObj.assetWithUID("bltf4fsamplec851db")
 
 @param uid uid of the Asset object to fetch.
 @return new instance of Asset with uid.
 */
- (Asset *)assetWithUID:(NSString *)uid;

/**
 Transforms provided image url based on transformation parameters.
 
     //Obj-C
     NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:100], @"width", [NSNumber numberWithInt:100], @"height", nil];
     NSString *transformedUrl = [stack imageTransformWithUrl:imageURL andParams:params];
 
     //Swift
     let params:[String : AnyObject?] = [
     "width":100 as AnyObject,
     "height":100 as AnyObject,
     ];
     let transformedUrl:String = stack.imageTransformation(withUrl: imageURL, andParams: params);

 @param url Url on which transformations to be applied.
 @param params Transformation parameters.
 @return new instance of transform url.
 */
- (NSString *)imageTransformWithUrl:(NSString *)url andParams:(NSDictionary *)params;

@end

BUILT_ASSUME_NONNULL_END
