//
//  Group.h
//  contentstack
//
//  Created by Priyanka Mistry on 29/11/16.
//  Copyright © 2016 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentstackDefinitions.h"


@class Asset;
@class Entry;

BUILT_ASSUME_NONNULL_BEGIN

/*
 A Group is special type of field in Contentstack. The reason its named such is that its a set of fields grouped together. Each group field has its own schema and can contain sub-groups.
 */

@interface Group : NSObject

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Gets the data for given property.
 
      //Assuming 'detailGroup' is a Group instance
 
     //Obj-C
     id object = [detailGroup objectForKey:@"key"];
 
     //Swift
     var object = detailGroup.objectForKey("key")
 
 
 @param key The object's property
 @return The value for the key provided
 */
- (BUILT_NULLABLE id)objectForKey:(NSString *)key;

/**---------------------------------------------------------------------------------------
 * @name Asset Method
 *  ---------------------------------------------------------------------------------------
 */

//MARK: - Asset
/**
 Get the info of the specified key of Asset object and returns instance of Asset.
 
     // 'projectImage' is a key in group object for asset
 
     //Obj-C
     Asset *asset = [groupObject assetForKey:@"projectImage"];
 
     //Swift
     var asset:Asset =  groupObject.assetForKey("projectImage")
 
 
 @param key Key containing the reference value of Asset
 @return Instance of Asset.
 */
- (Asset *)assetForKey:(NSString *)key;

/**
 Get the array containing instance of Assets mentioned in key specified.
 
     // 'projectImages' is a key in group object for asset
 
     //Obj-C
     NSArray *assetArray = [groupObject assetsForKey:@"projectImages"];
 
     //Swift
     var assetArray = groupObject.assetsForKey("projectImages")
 
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
 Get the info of the specified key of sub group object and returns instance of Group.
 
     // 'details' is a key in employee group for its sub group
 
     //Obj-C
     Group *detailsGroup = [empGroup groupForKey:@"details"];
 
     //Swift
     var detailsGroup:Group =  empGroup.groupForKey("details")
 
 @param key Key containing the value of Group
 @return Instance of Group
 */
-(nullable Group*)groupForKey:(NSString*)key;

/**
 Get the info of the specified key of group with multiple sub group and returns array of Group.
 
     // 'addresses' is a key in employee group for multiple group
 
     //Obj-C
     NSArray *groups = [empGroup groupsForKey:@"addresses"];
 
     //Swift
     var groups:NSArray =  empGroup.groupsForKey("addresses")
 
 
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
 
     //Assuming 'groupObj' is a Group instance
 
     //Obj-C
     NSString *markdownString = [groupObj HTMLStringForMarkdownKey:@"markdownString"];
 
     //Swift
     var markdownString:NSString = groupObj.HTMLStringForMarkdownKey("markdownString")
 
 
 @param key is Markdown string parameter
 @return Markdown to HTML String
 */
- (BUILT_NULLABLE NSString *)HTMLStringForMarkdownKey:(NSString *)key;

/**
 Converts Markdown to Array of HTML String for specified key
 
     //Assuming 'groupObj' is a Group instance
 
     //Obj-C
     NSArray *markdownArray = [groupObj HTMLArrayForMarkdownKey:@"multiple_markdown"];
 
     //Swift
     var markdownArray = groupObj.HTMLArrayForMarkdownKey("multiple_markdown")
 
 @param key is Multiple Markdown Parameter
 @return HTML Array from Markdown
 */
- (BUILT_NULLABLE NSArray *)HTMLArrayForMarkdownKey:(NSString *)key;

//MARK: Entry

/**
 Returns an array of Entries for the specified reference key
 
 Use this method to retrieve entries when using includeRefFieldWithKey: method of Query. The reference field key may have an array of objects or a single object. This method will return the Entries for the included reference field.
 
     //Assuming 'groupObj' is a Group instance

     //Obj-C
     [grpObj entriesForKey:@"detail" withContentType:"description"];
 
     //Swift
     grpObj.entriesForKey("detail" withContentType:"description")
 
 @param referenceKey      the reference field key
 @param contentTypeName set the contentTypeName to which the object(s) belongs
 @return An array of Entries for the specified key
 */

- (NSArray *)entriesForKey:(NSString *)referenceKey withContentType:(NSString *)contentTypeName;

@end

BUILT_ASSUME_NONNULL_END
