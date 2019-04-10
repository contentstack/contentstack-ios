//
//  Entry.h
//  Contentstack
//
//  Created by Reefaq on 22/06/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentstackDefinitions.h"

@class Asset;
@class Group;

BUILT_ASSUME_NONNULL_BEGIN

@interface Entry : NSObject
/**----------------------------------------------------------------------------------------
 * @name Properties
 *-----------------------------------------------------------------------------------------
 */
/**
 *  Readonly property to check value of entry's uid
 */
@property (nonatomic, copy, readonly) NSString *uid;

/**
 *  Readonly property to check if entry is deleted
 */
@property (nonatomic, assign, readonly, getter=isDeleted) BOOL deleted;

/**
 *  Readonly property to check tags of entry
 */
@property (nonatomic, copy, readonly) NSArray *tags;

/**
 *  Readonly property to check ContentType name of entry
 */
@property (nonatomic, copy, readonly) NSString *contentTypeName;

/**
 *  Readonly property to check title of entry
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 *  Readonly property to check url of entry
 */
@property (nonatomic, copy, readonly) NSString *url;

/**
 *  Readonly property to check Language of entry
 */
@property (nonatomic, assign, readonly) Language language;

/**
 *  Readonly property to check createAt of entry
 */
@property (nonatomic, copy, readonly) NSDate *createdAt;

/**
 *  Readonly property to check createdBy of entry
 */
@property (nonatomic, copy, readonly) NSString *createdBy;

/**
 *  Readonly property to check updatedAt of entry
 */
@property (nonatomic, copy, readonly) NSDate *updatedAt;

/**
 *  Readonly property to check updatedBy of entry
 */
@property (nonatomic, copy, readonly) NSString *updatedBy;

/**
 *  Readonly property to check deletedAt of entry
 */
@property (nonatomic, copy, readonly) NSDate *deletedAt;

/**
 *  Readonly property to check deletedBy of entry
 */
@property (nonatomic, copy, readonly) NSString *deletedBy;


/**
 *  property to assign cache policy like CACHE_THEN_NETWORK, NETWORK_ELSE_CACHE, NETWORK_ONLY, etc.
 */
@property (nonatomic, assign) CachePolicy cachePolicy;

/**
 *  Readonly property to get data of entry.
 */
@property (nonatomic, copy, readonly) NSDictionary *properties;


- (instancetype)init UNAVAILABLE_ATTRIBUTE;

//MARK: - Manually set headers
/**---------------------------------------------------------------------------------------
 * @name Manually set headers
 *  ---------------------------------------------------------------------------------------
 */

/**
 Set a header for Entry
 
     //'blt5d4sample2633b' is a dummy Stack API key
     
     //Obj-C
     [entryObj setHeader:@"MyValue" forKey:@"My-Custom-Header"];
     
     //Swift
     entryObj.setHeader("MyValue", forKey: "My-Custom-Header")
 
 @param headerValue  The header key
 @param headerKey    The header value
 */
- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey;

/**
 Set a header for Entry
 
     //'blt5d4sample2633b' is a dummy Stack API key
     
     //Obj-C
     [entryObj addHeadersWithDictionary:@{@"My-Custom-Header": @"MyValue"}];
     
     //Swift
     entryObj.addHeadersWithDictionary(["My-Custom-Header":"MyValue"])
 
 @param headers  The headers as dictionary which needs to be added to the application
 */
- (void)addHeadersWithDictionary:(NSDictionary *)headers;

/**
 Removes a header from this Entry.
 
     //'blt5d4sample2633b' is a dummy Stack API key
 
     //Obj-C
     [entryObj removeHeaderForKey:@"My-Custom-Header"];
     
     //Swift
     entryObj.removeHeaderForKey("My-Custom-Header")
 
 @param headerKey    The header key that needs to be removed
 */
- (void)removeHeaderForKey:(NSString *)headerKey;

//MARK: - Configuring manually
/**---------------------------------------------------------------------------------------
 * @name Configuring manually
 *  ---------------------------------------------------------------------------------------
 */

/**
 Configure user properties with built object info.
 
     //Obj-C
     [entryObj configureWithDictionary:@{@"key_name":@"MyValue"}];
     
     //Swift
     entryObj.configureWithDictionary(["key_name":"MyValue"])
 
 @param dictionary User Info
 */
- (void)configureWithDictionary:(NSDictionary*)dictionary;

//MARK: - Check for key existence
/**---------------------------------------------------------------------------------------
 * @name Check for key existence
 *  ---------------------------------------------------------------------------------------
 */

/**
 Checks whether an entry has a given property
 
     //Assuming 'entryObj' is a Entry instance
 
     //Obj-C
     BOOL hashKey = [entryObj hasKey:@"key"];
     if (hashKey) {
        //Hash Key
     } else {
        //No hash key
     }
     
     //Swift
     var hashKey:Bool = entryObj.hasKey("key")
     if (hashKey) {
        //Hash Key
     } else {
        //No Hash Key
     }
 
 @param key The property to be checked
 @return YES if key exists, NO if not
 */
- (BOOL)hasKey:(NSString *)key;

//MARK: - Asset and AssetLibrary
/**---------------------------------------------------------------------------------------
 * @name Get Asset or AssetLibrary
 *  ---------------------------------------------------------------------------------------
 */


//MARK: - Assets
/**
 Get the info of the specified key of Asset object and returns instance of Assets.
 
     // 'projectImage' is a key in project class for asset
 
     //Obj-C
         Asset *asset = [entryObj assetForKey:@"projectImage"];
 
     //Swift
     var asset:Asset =  entryObj.assetForKey("projectImage")
 
 @param key Key containing the reference value of Asset
 @return Instance of Asset.
 */
- (Asset *)assetForKey:(NSString *)key;

/**
 Get the array containing instance of Assets mentioned in key specified.
 
     //'projectImage' is a key in project class for asset
 
     //Obj-C
     NSArray *assetArray = [entryObj assetsForKey:@"projectImage"];
 
     //Swift
     var assetArray = entryObj.assetsForKey("projectImage")
 
 @param key Key containing the colection reference value of Assets.
 @return Array containing instance of Assets.
 */
- (NSArray *)assetsForKey:(NSString *)key;

//MARK: - Group
/**---------------------------------------------------------------------------------------
 * @name Get Single or Multiple Group/s
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get the info of the specified key of Group object and returns instance of Group.
 
     // 'details' is a key in people content type for group
 
     //Obj-C
     Group *detailsGroup = [entryObj groupForKey:@"details"];
 
     //Swift
     var detailsGroup:Group =  entryObj.groupForKey("details")
 
 @param key Key containing the value of Group
 @return Instance of Group
 */
-(nullable Group*)groupForKey:(NSString*)key;

/**
 Get the info of the specified key of content type  and returns array of Group.
 
     // 'addresses' is a key in people for multiple group
 
     //Obj-C
     NSArray *groups = [entryObj groupsForKey:@"addresses"];
 
     //Swift
     var groups:NSArray =  entryObj.groupsForKey("addresses")
 
 @param key Key containing the value of Group array
 @return NSArray of Groups
 */

- (NSArray*)groupsForKey:(NSString*)key;

//MARK: - HTML String from Markdown
/**---------------------------------------------------------------------------------------
 * @name HTML String from Markdown
 *  ---------------------------------------------------------------------------------------
 */
/**
 Converts Markdown to String of HTML String for specified key
 
     //Assuming 'entryObj' is a Entry instance
 
     //Obj-C
     NSString *markdownString = [entryObj HTMLStringForMarkdownKey:@"markdownString"];
 
     //Swift
     var markdownString:NSString = entryObj.HTMLStringForMarkdownKey("markdownString")
 
 @param key is Markdown string parameter
 @return Markdown to HTML String
 */
- (BUILT_NULLABLE NSString *)HTMLStringForMarkdownKey:(NSString *)key;

/**
 Converts Markdown to Array of HTML String for specified key
 
     //Assuming 'entryObj' is a Entry instance
 
     //Obj-C
     NSArray *markdownArray = [entryObj HTMLArrayForMarkdownKey:@"multiple_markdown"];
 
     //Swift
     var markdownArray = entryObj.HTMLArrayForMarkdownKey("multiple_markdown")
 
 @param key is Multiple Markdown Parameter
 @return HTML Array from Markdown
 */
- (BUILT_NULLABLE NSArray *)HTMLArrayForMarkdownKey:(NSString *)key;

//MARK: - Only and Except
/**---------------------------------------------------------------------------------------
 * @name Only and Except
 *  ---------------------------------------------------------------------------------------
 */

/**
Specifies an array of 'only' keys in BASE object that would be included in the response.
 
     //Obj-C
     [entryObj includeOnlyFields:@["name"]];
     
     //Swift
     entryObj.includeOnlyFields(["name"])
 
 @discussion Specifies an array of keys in BASE object that would be included in the response.
 @param fieldUIDs Array of the 'only' keys to be included in response.
 */
- (void)includeOnlyFields:(NSArray *)fieldUIDs;

/**
Specifies an array of keys in reference class object that would be 'excluded' from the response.
 
     //Obj-C
     [entryObj includeAllFieldsExcept:@["name"]];
     
     //Swift
     entryObj.includeAllFieldsExcept(["name"])

 @discussion Specifies an array of keys in BASE object that would be 'excluded' from the response.
 @param fieldUIDs Array of keys to be excluded from the response.
 */
- (void)includeAllFieldsExcept:(NSArray *)fieldUIDs;

//MARK: - Reference
/**---------------------------------------------------------------------------------------
 * @name Reference
 *  ---------------------------------------------------------------------------------------
 */

/**
Include reference objects with given key in response
 
     //Obj-C
     [entryObj includeRefFieldWithKey:@[@"detail"]];
     
     //Swift
     entryObj.includeRefFieldWithKey(["detail"])
 
 @discussion The include parameter accepts the name of a reference field. By default, no reference field is bought along with the object, only the uids are. To include any reference, this parameter must be used. Nested references can be bought by "." separating the references. This will work for references which are nested inside groups or references which are nested inside other references.
 @param key Array of reference keys to include in response.
 */
- (void)includeRefFieldWithKey:(NSArray *)key;

/**
Specifies an array of 'only' keys in reference class object that would be included in the response.
 
     //Obj-C
     [entryObj includeRefFieldWithKey:@[@"detail"] andOnlyRefValuesWithKeys:@[@"name",@"description"]];
     
     //Swift
     entryObj.includeRefFieldWithKey(["detail"], andOnlyRefValuesWithKeys:["name","description"])
 
 @discussion Specifies an array of keys in reference class object that would be included in the response.
 @param key Key who has reference to some other class object.
 @param values Array of the 'only' reference keys to be included in response.
 */
- (void)includeRefFieldWithKey:(NSString *)key andOnlyRefValuesWithKeys:(NSArray *)values;

/**
Specifies an array of keys in reference class object that would be 'excluded' from the response.
 
     //Obj-C
     [entryObj includeRefFieldWithKey:@[@"detail"] excludingRefValuesWithKeys:@[@"description"]];
     
     //Swift
     entryObj.includeRefFieldWithKey(["detail"], excludingRefValuesWithKeys:["description"])
 
 @discussion Specifies an array of keys in reference class object that would be 'excluded' from the response.
 @param key Key who has reference to some other class object.
 @param values Array of the 'only' reference keys to be 'excluded' from the response.
 */
- (void)includeRefFieldWithKey:(NSString *)key excludingRefValuesWithKeys:(NSArray *)values;

/**
 This method adds key and value to an Entry.
 
     //Obj-C
     [entryObj addParamKey:@"key" andValue:@"value"];
 
     //Swift
     entryObj.addParamKey("key", andValue:"value")
 
 @param key The key as string which needs to be added to an Entry
 @param value The value as string which needs to be added to an Entry
 */
- (void)addParamKey:(NSString *)key andValue:(NSString *)value;

//MARK: - Fetch
/**---------------------------------------------------------------------------------------
 * @name Fetch
 *  ---------------------------------------------------------------------------------------
 */

/**
 Fetches an entry asynchronously provided entry UID
 
     //Obj-C
     Stack *stack = [Contentstack stackWithAPIKey:@"blt5d4sample2633b" accessToken:@"blt3esampletokeneb02" environmentName:@"dummy"];
     ContentType *contentTypeObj = [stack contentTypeWithName:@"blog"];
     //'bltf4fsamplec851db' is uid of an entry of 'blog' contenttype
     Entry *entryObj  = [contentTypeObj entryWithUID:@"bltf4fsamplec851db"];
     [entryObj fetch:^(ResponseType type, NSError *error) {
        //error if exists then use 'error' object for details
     }];
     
     
     //Swift
     var stack:Stack = Contentstack.stackWithAPIKey("blt5d4sample2633b", accessToken:"blt3esampletokeneb02", environmentName:@"dummy")
     var contentTypeObj:ContentType = stack.contentTypeWithName("blog")
     //'bltf4fsamplec851db' is uid of an entry of 'blog' contenttype
     var entryObj:Entry = contentTypeObj.entryWithUID("bltf4fsamplec851db")
     entryObj.fetch { (error!) -> Void in
        //error if exists then use 'error' object for details
     }
 
 @param callback Completion block with params NSError
 */
- (void)fetch:(void(^)(ResponseType type, NSError * BUILT_NULLABLE_P error))callback;

/**
 Returns an array of Entries for the specified reference key
 
 Use this method to retrieve entries when using includeRefFieldWithKey: method of Query. The reference field key may have an array of objects or a single object. This method will return the Entries for the included reference field.
 
     //Obj-C
     [entryObj entriesForKey:@"detail" withContentType:"description"];
 
     //Swift
     entryObj.entriesForKey("detail" withContentType:"description")
 
 @param referenceKey      the reference field key
 @param contentTypeName set the contentTypeName to which the object(s) belongs
 @return An array of Entries for the specified key
 */
- (NSArray *)entriesForKey:(NSString *)referenceKey withContentType:(NSString *)contentTypeName;

//MARK: - Cancel Request
/**---------------------------------------------------------------------------------------
 * @name Cancel Request
 *  ---------------------------------------------------------------------------------------
 */

/**
Advises the operation object that it should stop executing its task.
 
     //Obj-C
     [entryObj cancelRequest];
     
     //Swift
     entryObj.cancelRequest()
 
 @discussion This method does not force your operation code to stop. Instead, it updates the object’s internal flags to reflect the change in state. If the operation has already finished executing, this method has no effect. Canceling an operation that is currently in an operation queue, but not yet executing, makes it possible to remove the operation from the queue sooner than usual.
 */
- (void)cancelRequest;

//MARK: - Subscripting
- (BUILT_NULLABLE id)objectForKey:(NSString *)key;
- (BUILT_NULLABLE id)objectForKeyedSubscript:(id <NSCopying>)key;

@end

BUILT_ASSUME_NONNULL_END
