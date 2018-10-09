//
//  Stack.h
//  Contentstack
//
//  Created by Reefaq on 11/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentstackDefinitions.h"

@class Config;
@class ContentType;
@class AssetLibrary;
@class Asset;
@class SyncStack;

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
 *  Readonly property to check value of delivery token
 */
@property (nonatomic, copy, readonly) NSString *deliveryToken;

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

/**
Perform a synchronization operation.

     //Obj-C
         [stack sync:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {

         }];

     //Swift
         stack.sync({ ( SyncStack:syncStack, error: NSError) in
 
         })

@param completionBlock called synchronization is done.
*/
- (void)sync:(void (^)(SyncStack * BUILT_NULLABLE_P syncStack, NSError  * BUILT_NULLABLE_P error))completionBlock;
/**
 Perform a synchronization operation.
 
     //Obj-C
         NSString *token = @"blt129393939"; //Sync token
         [stack syncToken:token completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
 
         }];
 
     //Swift
         var token = @"blt129393939"; //Sync token
         stack.syncToken(token, completion: { ( SyncStack:syncStack, error: NSError) in
 
         })

 @param token Sync token from where to perform sync
 @param completionBlock called synchronization is done.
 */
- (void)syncToken:(NSString*)token completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncStack, NSError  * BUILT_NULLABLE_P error))completionBlock;

/**
 Perform a synchronization operation.
     //Obj-C
         NSString *token = @"blt129393939"; //Pagination token
         [stack syncPaginationToken:token completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
 
         }];
 
     //Swift
         var token = @"blt129393939"; //Pagination token
         syncPaginationToken(token, completion: { ( SyncStack:syncStack, error: NSError) in
 
         })


 @param token Pagination token from where to perform sync
 @param completionBlock called synchronization is done.
 */
-(void)syncPaginationToken:(NSString *)token completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncResult, NSError  * BUILT_NULLABLE_P error))completionBlock;

/**
Perform a synchronization operation from date.

     //Obj-C
         NSDate *date = [NSDate date]; //date from where synchronization is called
         [stack syncFrom:date completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {

         }];

     //Swift
         let date = Date.date() //date from where synchronization is called
         stack.syncFrom(date, completion: { ( SyncStack:syncStack, error: NSError) in
 
         })

@param date date from where sync data is needed.
@param completionBlock called synchronization is done.
*/
- (void)syncFrom:(NSDate*)date completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncStack, NSError  * BUILT_NULLABLE_P error))completionBlock;

/**
Perform a synchronization operation on specified classes.

     //Obj-C
         NSArray *contentTypeArray = @[@"product", @"multifield"]; //Content type uids that want to sync.
         [stack syncOnly:contentTypeArray completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {

         }];

     //Swift
         let contentTypeArray = ["product", "multifield"]; //Content type uids that want to sync.
         stack.syncOnly(contentTypeArray, completion: { ( SyncStack:syncStack, error: NSError) in
 
         })

@param contentType uid of classes to be expected.
@param completionBlock called synchronization is done.
*/
- (void)syncOnly:(NSString*)contentType completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncStack, NSError  * BUILT_NULLABLE_P error))completionBlock;

/**
Perform a synchronization operation on specified classes and from date.

     //Obj-C
         NSArray *contentTypeArray = @[@"product", @"multifield"]; //Content type uids that want to sync.
         NSDate *date = [NSDate date]; //date from where synchronization is called
         [[csStack syncOnly:contentTypeArray from:date completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {

         }];

     //Swift
         let date = Date.date() //date from where synchronization is called
         let contentTypeArray = ["product", "multifield"]; //Content type uids that want to sync.
         stack.syncOnly(contentTypeArray, from: date, completion: { ( SyncStack:syncStack, error: NSError) in
 
         })
@param contentType uid of classes to be expected.
@param date from where sync data is needed.
@param completionBlock called synchronization is done.
*/
- (void)syncOnly:(NSString*)contentType from:(NSDate*)date completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncStack, NSError  * BUILT_NULLABLE_P error))completionBlock;


/**
 Perform a synchronization operation on specified classes and from date.
 
 //Obj-C
 [[csStack syncLocale:ENGLISH_UNITED_STATES completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
 
 }];
 
 //Swift
 stack.syncLocale(ENGLISH_UNITED_STATES, completion: { ( SyncStack:syncStack, error: NSError) in
 
 })

 @param language for which sync is needed.
 @param completionBlock called synchronization is done.
 */
- (void)syncLocale:(Language)language completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncStack, NSError  * BUILT_NULLABLE_P error))completionBlock;


/**
 
 //Obj-C
 NSDate *date = [NSDate date]; //date from where synchronization is called
 [[csStack syncLocale:ENGLISH_UNITED_STATES from:date completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
 
 }];
 
 //Swift
 let date = Date.date() //date from where synchronization is called
 stack.syncLocale(ENGLISH_UNITED_STATES, from: date, completion: { ( SyncStack:syncStack, error: NSError) in
 
 })

 @param language for which sync is needed.
 @param date from where sync data is needed.
 @param completionBlock called synchronization is done.
 */
- (void)syncLocale:(Language)language from:(NSDate*)date completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncStack, NSError  * BUILT_NULLABLE_P error))completionBlock;


/**
 
 //Obj-C
 NSDate *date = [NSDate date]; //date from where synchronization is called
 [[csStack syncPublishType:ENTRY_PUBLISHED completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
 
 }];
 
 //Swift
 let date = Date.date() //date from where synchronization is called
 stack.syncPublishType:ENTRY_PUBLISHED, completion: { ( SyncStack:syncStack, error: NSError) in
 
 })

 @param publishType for which sync is needed.
 @param completionBlock called synchronization is done.
 */
-(void)syncPublishType:(PublishType)publishType completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncStack, NSError  * BUILT_NULLABLE_P error))completionBlock;
/**
 //Obj-C
 NSArray *contentTypeArray = @[@"product", @"multifield"]; //Content type uids that want to sync.
 NSDate *date = [NSDate date]; //date from where synchronization is called
 [[csStack syncOnly: contentTypeArray locale:ENGLISH_UNITED_STATES from:date completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
 
 }];
 
 //Swift
 let contentTypeArray = ["product", "multifield"]; //Content type uids that want to sync.
 let date = Date.date() //date from where synchronization is called
 stack.syncOnly(contentTypeArray, locale:ENGLISH_UNITED_STATES, from: date, completion: { ( SyncStack:syncStack, error: NSError) in
 
 })


 @param contentType uid of classes to be expected.
 @param language for which sync is needed.
 @param date from where sync data is needed.
 @param completionBlock called synchronization is done.
 */
- (void)syncOnly:(NSString*)contentType locale:(Language)language from:(NSDate* BUILT_NULLABLE_P)date completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncStack, NSError  * BUILT_NULLABLE_P error))completionBlock;


/**
 //Obj-C
 NSArray *contentTypeArray = @[@"product", @"multifield"]; //Content type uids that want to sync.
 NSDate *date = [NSDate date]; //date from where synchronization is called
 [[csStack syncOnly: contentTypeArray locale:ENGLISH_UNITED_STATES from:date completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
 
 }];
 
 //Swift
 let contentTypeArray = ["product", "multifield"]; //Content type uids that want to sync.
 let date = Date.date() //date from where synchronization is called
 stack.syncOnly(contentTypeArray, locale:ENGLISH_UNITED_STATES, from: date, completion: { ( SyncStack:syncStack, error: NSError) in
 
 })
 
 
 @param contentType uid of classes to be expected.
 @param language for which sync is needed.
 @param date from where sync data is needed.
 @param publishType for which sync is needed.
 @param completionBlock called synchronization is done.
 */
- (void)syncOnly:(NSString*)contentType locale:(Language)language from:(NSDate* BUILT_NULLABLE_P)date publishType:(PublishType)publishType completion:(void (^)(SyncStack * BUILT_NULLABLE_P syncStack, NSError  * BUILT_NULLABLE_P error))completionBlock;

@end

BUILT_ASSUME_NONNULL_END
