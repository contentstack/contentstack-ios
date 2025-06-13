//
//  GlobalField.h
//  Contentstack
//
//  Created by Reeshika Hosmani on 02/06/25.
//  Copyright © 2025 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contentstack/ContentstackDefinitions.h>


BUILT_ASSUME_NONNULL_BEGIN

@interface GlobalField : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
//- (instancetype)initWithStack:(Stack*)stack;
//- (instancetype)initWithStack:(Stack*)stack withName:(NSString*)globalFieldName;

/**----------------------------------------------------------------------------------------
 * @name Properties
 *-----------------------------------------------------------------------------------------
 */

/**
 *  Readonly property to check title of GlobalField
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 *  Readonly property to check version
 */
@property (nonatomic, assign, readonly) unsigned int version;

/**
 *  Readonly property to check description
 */
@property (nonatomic, copy, readonly) NSString *Description;

/**
 *  Readonly property to check value of global field's uid
 */
@property (nonatomic, copy, readonly) NSString *uid;

/**
 *  Readonly property to check createdAt of global field
 */
@property (nonatomic, copy, readonly) NSDate *createdAt;

/**
 *  Readonly property to check updatedAt of global field
 */
@property (nonatomic, copy, readonly) NSDate *updatedAt;

/**
 *  Readonly property to check the branch
 */
@property (nonatomic, copy, readonly) NSString *branch;

/**
 *  Readonly property to get schema of global field
 */
@property (nonatomic, copy, readonly) NSArray<NSDictionary *> *schema;

/**
 *  Readonly property to check if global field is inbuilt class
 */
@property (nonatomic, assign, readonly) BOOL inbuiltClass;

/**
 *  Readonly property to check if global field maintains revisions
 */
@property (nonatomic, assign, readonly) BOOL maintainRevisions;

/**
 *  Readonly property to get last activity of global field
 */
@property (nonatomic, copy, readonly) NSDictionary *lastActivity;

/**
 *  Readonly property to get all properties of global field
 */
@property (nonatomic, copy, readonly) NSDictionary<NSString *, id> *properties;

/**
 *  property to assign cache policy like CACHE_THEN_NETWORK, NETWORK_ELSE_CACHE, NETWORK_ONLY, etc.
 */
@property (nonatomic, assign) CachePolicy cachePolicy;
//MARK: - Manually set headers
/**---------------------------------------------------------------------------------------
 * @name Manually set headers
 *  ---------------------------------------------------------------------------------------
 */

/**
Set a header for GlobalField.
 
     //Obj-C
     [contentTypeObj setHeader:@"MyValue" forKey:@"My-Custom-Header"];
     //Swift
     contentTypeObj.setHeader("MyValue", forKey: "My-Custom-Header")
@param headerValue  The header key
@param headerKey    The header value
*/
- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey;
/**
Set a header for GlobalField.
 
     //Obj-C
     [contentTypeObj addHeadersWithDictionary:@{@"My-Custom-Header": @"MyValue"}];
     
     //Swift
     contentTypeObj.addHeadersWithDictionary(["My-Custom-Header":"MyValue"])
 
 
 @param headers The headers as dictionary which needs to be added to the application
 */
- (void)addHeadersWithDictionary:(NSDictionary<NSString *, NSString *> *)headers;
/**
Removes a header from this GlobalField.
 
     //Obj-C
     [contentTypeObj removeHeaderForKey:@"My-Custom-Header"];
     
     //Swift
     contentTypeObj.removeHeaderForKey("My-Custom-Header")
 
 @param headerKey The header key that needs to be removed
 */
- (void)removeHeaderForKey:(NSString *)headerKey;

/**
 Retrieve the branch of the globalField.
 
      //Obj-C
      Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
      GlobalField *globalField = [stack GlobalField];
      [globalField includeBranch];

      //Swift
      var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
      var globalField:Asset = stack.GlobalField()
      globalField.includeBranch()

 */
-(void)includeBranch;

/**
 Retrieve the schema of globalField.
 
      //Obj-C
      Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"ENVIRONMENT"];
      GlobalField *globalField = [stack GlobalField];
      [globalField includeGlobalFieldSchema];

      //Swift
      var stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"ENVIRONMENT")
      var globalField:Asset = stack.GlobalField()
      globalField.includeGlobalFieldSchema()

 */
-(void)includeGlobalFieldSchema;


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

/**
This method provides all the GlobalFields present in the stack.

     //Obj-C
     [globalField fetchAll:^(ResponseType type,NSArray<GlobalField *> * BUILT_NULLABLE_P result,NSError * BUILT_NULLABLE_P error {
        //error for any error description
        //result for reponse data
     }];
     
     //Swift
     globalField.fetchAll { (type, result, error) -> Void in
         //error for any error description
         //result for reponse data
     }
 
@param completionBlock block to be called once operation is done. The result data contains all the globalFields.
 */
- (void)fetchAll:(void (^) (ResponseType type,NSArray<GlobalField *> * BUILT_NULLABLE_P result,NSError * BUILT_NULLABLE_P error))completionBlock;
@end

BUILT_ASSUME_NONNULL_END
