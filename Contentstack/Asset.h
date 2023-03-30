//
//  Asset.h
//  contentstack
//
//  Created by Priyanka Mistry on 19/05/16.
//  Copyright © 2016 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentstackDefinitions.h"

BUILT_ASSUME_NONNULL_BEGIN

@class ContentType;

@interface Asset : NSObject

/**----------------------------------------------------------------------------------------
 * @name Properties
 *-----------------------------------------------------------------------------------------
 */

/**
 *  Readonly property to check  fileName of asset
 */
@property (nonatomic, copy, readonly) NSString *fileName;

/**
 *  Readonly property to check fileSize  of asset
 */
@property (nonatomic, assign, readonly) unsigned int fileSize;

/**
 *  Readonly property to check type of asset
 */
@property (nonatomic, copy, readonly) NSString *fileType;

/**
 *  Readonly property to check value of asset's uid
 */
@property (nonatomic, copy, readonly) NSString *uid;

/**
 *  Readonly property to check value of asset's url
 */
@property (nonatomic, copy, readonly) NSString *url;

/**
 *  Readonly property to check tags of asset
 */
@property (nonatomic, copy, readonly) NSArray<NSString *> *tags;

/**
 *  Readonly property to check createAt of asset
 */
@property (nonatomic, copy, readonly) NSDate *createdAt;

/**
 *  Readonly property to check createdBy of asset
 */
@property (nonatomic, copy, readonly) NSString *createdBy;

/**
 *  Readonly property to check updatedAt of asset
 */
@property (nonatomic, copy, readonly) NSDate *updatedAt;

/**
 *  Readonly property to check updatedBy of asset
 */
@property (nonatomic, copy, readonly) NSString *updatedBy;

/**
 *  Readonly property to check deletedAt of asset
 */
@property (nonatomic, copy, readonly) NSDate *deletedAt;

/**
 *  Readonly property to check deletedBy of asset
 */
@property (nonatomic, copy, readonly) NSString *deletedBy;

/**
 *  Readonly property to get data of entry.
 */
@property (nonatomic, copy, readonly) NSDictionary<NSString *, id> *properties;


/**
 *  property to assign cache policy like CACHE_THEN_NETWORK, NETWORK_ELSE_CACHE, NETWORK_ONLY, etc.
 */
@property (nonatomic, assign) CachePolicy cachePolicy;


- (instancetype)init UNAVAILABLE_ATTRIBUTE;


//MARK: Configuring manually -
/**---------------------------------------------------------------------------------------
 * @name Configuring manually
 *  ---------------------------------------------------------------------------------------
 */

/**
 Configure user properties with built object info.
 
     //Obj-C
     [assetObj configureWithDictionary:@{@"key_name":@"MyValue"}];
     
     //Swift
     assetObj.configureWithDictionary(["key_name":"MyValue"])
 
 @param dictionary User Info
 */
- (void)configureWithDictionary:(NSDictionary<NSString *, id> *)dictionary;

//MARK: Manually set headers -
/**---------------------------------------------------------------------------------------
 * @name Manually set headers
 *  ---------------------------------------------------------------------------------------
 */

/**
 Set a header for Asset
 
     //'API_KEY' is a ENVIRONMENT Stack API key
 
     //Obj-C
     Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
     Asset *asset = [stack asset];
     [asset setHeader:@"MyValue" forKey:@"My-Custom-Header"];
 
     //Swift
      var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
      var asset:Asset = stack.asset()
      asset.setHeader("MyValue", forKey: "My-Custom-Header")
 
 @param headerValue  The header key
 @param headerKey    The header value
 */
- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey;

/**
 Set a header for Asset
 
      //'API_KEY' is a ENVIRONMENT Stack API key
 
      //Obj-C
      Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
      Asset *asset = [stack asset];
      [asset addHeadersWithDictionary:@{@"My-Custom-Header": @"MyValue"}];
 
      //Swift
      var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
      var asset:Asset = stack.asset()
      asset.addHeadersWithDictionary(["My-Custom-Header":"MyValue"])
 
 
 @param headers  The headers as dictionary which needs to be added to the application
 */
- (void)addHeadersWithDictionary:(NSDictionary<NSString *, NSString *> *)headers;


/**
 This method adds key and value to an Asset.
 
     //'API_KEY' is a ENVIRONMENT Stack API key

     //Obj-C
     Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
     Asset *asset = [stack asset];
     [blogQuery addParamKey:@"key" andValue:@"value"];
 
     //Swift
     var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
     var asset:Asset = stack.asset()
     blogQuery.addParamKey("key", andValue:"value")
 
 @param key The key as string which needs to be added to an Asset
 @param value The value as string which needs to be added to an Asset
 */
- (void)addParamKey:(NSString *)key andValue:(NSString *)value;

/**
 Removes a header from this Asset
 
     //'API_KEY' is a ENVIRONMENT Stack API key
 
     //Obj-C
     Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
     Asset *asset = [stack asset];
     [asset removeHeaderForKey:@"My-Custom-Header"];
 
     //Swift
     var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
     var asset:Asset = stack.asset()
     asset.removeHeaderForKey("My-Custom-Header")
 
 @param headerKey    The header key that needs to be removed
 */
- (void)removeHeaderForKey:(NSString *)headerKey;

/**
 Include the metadata for getting metadata content for the asset.
 
      //Obj-C
      Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
      Asset *asset = [stack asset];
      [asset includeMetadata];

      //Swift
      var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
      var asset:Asset = stack.asset()
      asset.includeMetadata()

 */
-(void)includeMetadata;

/**
 Retrieve the published content of the fallback locale entry if the entry is not localized in specified locale.
 
      //Obj-C
      Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
      Asset *asset = [stack asset];
      [asset includeFallback];

      //Swift
      var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
      var asset:Asset = stack.asset()
      asset.includeFallback()

 */
-(void)includeFallback;

/**
 Retrieve the branch for the  published content.
 
      //Obj-C
      Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
      Asset *asset = [stack asset];
      [asset includeBranch];

      //Swift
      var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
      var asset:Asset = stack.asset()
      asset.includeBranch()

 */
-(void)includeBranch;
//MARK: - Fetch -
/**---------------------------------------------------------------------------------------
 * @name Fetch
 *  ---------------------------------------------------------------------------------------
 */

/**
 Fetches an asset asynchronously provided asset UID
 
     //Obj-C
     Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
     //'ASSET_UID' is uid of an asset
     Asset* assetObj = [stack assetWithUID:@"ASSET_UID"];
     [assetObj fetch:^(ResponseType type, NSError *error) {
        //error if exists then use 'error' object for details
     }];
     
     //Swift
     var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
     //'ASSET_UID' is uid of an asset
     var assetObj:Asset = stack.assetWithUID("ASSET_UID")
     assetObj.fetch { (responseType, error!) -> Void in
        //error if exists then use 'error' object for details
     }
 
 @param callback Completion block with params NSError
 */

- (void)fetch:(void(^)(ResponseType type, NSError * BUILT_NULLABLE_P error))callback;

@end
BUILT_ASSUME_NONNULL_END
