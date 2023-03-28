//
//  AssetLibrary.h
//  contentstack
//
//  Created by Priyanka Mistry on 05/10/16.
//  Copyright © 2016 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentstackDefinitions.h"

BUILT_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, OrderBy) {
    OrderByAscending = 0,
    OrderByDescending
};

@class Asset;
@interface AssetLibrary : NSObject

/**----------------------------------------------------------------------------------------
 * @name Properties
 *-----------------------------------------------------------------------------------------
 */

/**
 *  property to assign cache policy like CACHE_THEN_NETWORK, NETWORK_ELSE_CACHE, NETWORK_ONLY, etc.
 */
@property (nonatomic, assign) CachePolicy cachePolicy;

//MARK: - Sorting
/**---------------------------------------------------------------------------------------
 * @name Sorting
 *  ---------------------------------------------------------------------------------------
 */

/**
 Sorts the assets in the given order on the basis of the specified field.
 
      //Obj-C
      [assetLib sortWithKey:@"updated_at" orderBy:Ascending];
 
      //Swift
      assetLib.sortWithKey("updated_at" orderBy:Ascending)
 
 @param key field uid based on which the ordering should be done.
 @param order ascending or descending order in which results should come.

 */
- (void)sortWithKey:(NSString *)key orderBy:(OrderBy)order;

//MARK: Include -
/**---------------------------------------------------------------------------------------
 * @name Include
 *  ---------------------------------------------------------------------------------------
 */

/**
 Provides only the number of assets.
 
      //Obj-C
      [assetLib objectsCount];
 
      //Swift
      assetLib.objectsCount()
 
 */
- (void)objectsCount;


/**
 This method also includes the total number of assets returned in the response.
 
      //Obj-C
      [assetLib includeCount];
 
      //Swift
      assetLib.includeCount()
 
 */
- (void)includeCount;

/**
 This method includes the relative url of assets.
 
      //Obj-C
      [assetLib includeRelativeUrls];
 
      //Swift
      assetLib.includeRelativeUrls()
 
 */
- (void)includeRelativeUrls;

/**
 Retrieve the published content of the fallback locale entry if the entry is not localized in specified locale.
 
      //Obj-C
      [assetLib includeFallback];
 
      //Swift
      assetLib.includeFallback()
 
 */
-(void)includeFallback;

/**
 Include the metadata for getting metadata content for the asset.
 
      //Obj-C
      [assetLib includeMetadata];
 
      //Swift
      assetLib.includeMetadata()
 
 */
-(void)includeMetadata;

/**
 Retrieve the branch for the  published content.

      //Obj-C
      [assetLib includeBranch];
 
      //Swift
      assetLib.includeBranch()
 
 */
-(void)includeBranch;
/**
 This method provides all the assets for the specified language in the response.
 
      //Obj-C
      [assetLib includeRelativeUrls];
 
      //Swift
      assetLib.includeRelativeUrls()

 @param locale Language enum for all language available.
 */
- (void)locale:(NSString *)locale;

//MARK: Manually set headers -
/**---------------------------------------------------------------------------------------
 * @name Manually set headers
 *  ---------------------------------------------------------------------------------------
 */

/**
 Set a header for AssetLibrary
 
     //'API_KEY' is a ENVIRONMENT Stack API key
 
     //Obj-C
     Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
     AssetLibrary *assetLib = [stack assetLibrary];
     [assetLib setHeader:@"MyValue" forKey:@"My-Custom-Header"];
 
     //Swift
     var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
     var assetLib:AssetLibrary = stack.assetLibrary()
     assetLib.setHeader("MyValue", forKey: "My-Custom-Header")
 
 @param headerValue  The header key
 @param headerKey    The header value
 */
- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey;

/**
 Set a header for AssetLibrary
 
     //'API_KEY' is a ENVIRONMENT Stack API key
 
     //Obj-C
     Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
     AssetLibrary *assetLib = [stack assetLibrary];
     [assetLib addHeadersWithDictionary:@{@"My-Custom-Header": @"MyValue"}];
 
     //Swift
     var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
     var assetLib:AssetLibrary = stack.assetLibrary()
     assetLib.addHeadersWithDictionary(["My-Custom-Header":"MyValue"])
 
 @param headers  The headers as dictionary which needs to be added to the application
 */
- (void)addHeadersWithDictionary:(NSDictionary<NSString *, NSString *> *)headers;

/**
 Removes a header from this AssetLibrary.
 
      //'API_KEY' is a ENVIRONMENT Stack API key
 
      //Obj-C
      Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
      AssetLibrary *assetLib = [stack assetLibrary];
      [assetLib removeHeaderForKey:@"My-Custom-Header"];
 
      //Swift
      var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
      var assetLib:AssetLibrary = stack.assetLibrary()
      assetLib.removeHeaderForKey("My-Custom-Header")
 
 @param headerKey    The header key that needs to be removed
 */
- (void)removeHeaderForKey:(NSString *)headerKey;

//MARK: Fetch Assets -
/**---------------------------------------------------------------------------------------
 * @name Fetch Assets
 *  ---------------------------------------------------------------------------------------
 */

/**
 This method provides all the assets.
 
      //Obj-C
      [assetLib fetchAll:^(ResponseType type, NSArray *result, NSError *error) {
      //error for any error description
      //result for reponse data
      }];
 
      //Swift
      assetLib.fetchAll { (responseType, result!, error!) -> Void in
      //error for any error description
      //result for reponse data
      }
 
 @param completionBlock block to be called once operation is done. The result data contains all the assets.
 */

- (void)fetchAll:(void (^) (ResponseType type,NSArray<Asset *> * BUILT_NULLABLE_P result,NSError * BUILT_NULLABLE_P error))completionBlock;
@end

BUILT_ASSUME_NONNULL_END
