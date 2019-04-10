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

//MARK: Manually set headers -
/**---------------------------------------------------------------------------------------
 * @name Manually set headers
 *  ---------------------------------------------------------------------------------------
 */

/**
 Set a header for AssetLibrary
 
     //'blt5d4sample2633b' is a dummy Stack API key
 
     //Obj-C
     Stack *stack = [Contentstack stackWithAPIKey:@"blt5d4sample2633b" accessToken:@"blt3esampletokeneb02" environmentName:@"dummy"];
     AssetLibrary *assetLib = [stack assetLibrary];
     [assetLib setHeader:@"MyValue" forKey:@"My-Custom-Header"];
 
     //Swift
     var stack:Stack = Contentstack.stackWithAPIKey("blt5d4sample2633b", accessToken:"blt3esampletokeneb02", environmentName:@"dummy")
     var assetLib:AssetLibrary = stack.assetLibrary()
     assetLib.setHeader("MyValue", forKey: "My-Custom-Header")
 
 @param headerValue  The header key
 @param headerKey    The header value
 */
- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey;

/**
 Set a header for AssetLibrary
 
     //'blt5d4sample2633b' is a dummy Stack API key
 
     //Obj-C
     Stack *stack = [Contentstack stackWithAPIKey:@"blt5d4sample2633b" accessToken:@"blt3esampletokeneb02" environmentName:@"dummy"];
     AssetLibrary *assetLib = [stack assetLibrary];
     [assetLib addHeadersWithDictionary:@{@"My-Custom-Header": @"MyValue"}];
 
     //Swift
     var stack:Stack = Contentstack.stackWithAPIKey("blt5d4sample2633b", accessToken:"blt3esampletokeneb02", environmentName:@"dummy")
     var assetLib:AssetLibrary = stack.assetLibrary()
     assetLib.addHeadersWithDictionary(["My-Custom-Header":"MyValue"])
 
 @param headers  The headers as dictionary which needs to be added to the application
 */
- (void)addHeadersWithDictionary:(NSDictionary *)headers;

/**
 Removes a header from this AssetLibrary.
 
      //'blt5d4sample2633b' is a dummy Stack API key
 
      //Obj-C
      Stack *stack = [Contentstack stackWithAPIKey:@"blt5d4sample2633b" accessToken:@"blt3esampletokeneb02" environmentName:@"dummy"];
      AssetLibrary *assetLib = [stack assetLibrary];
      [assetLib removeHeaderForKey:@"My-Custom-Header"];
 
      //Swift
      var stack:Stack = Contentstack.stackWithAPIKey("blt5d4sample2633b", accessToken:"blt3esampletokeneb02", environmentName:@"dummy")
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

- (void)fetchAll:(void (^) (ResponseType type,NSArray * BUILT_NULLABLE_P result,NSError * BUILT_NULLABLE_P error))completionBlock;
@end

BUILT_ASSUME_NONNULL_END
