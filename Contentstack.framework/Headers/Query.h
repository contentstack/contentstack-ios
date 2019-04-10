//
//  Query.h
//  Contentstack
//
//  Created by Reefaq on 22/06/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentstackDefinitions.h"

@class QueryResult;
@class Entry;

BUILT_ASSUME_NONNULL_BEGIN

@interface Query : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
/**----------------------------------------------------------------------------------------
 * @name Properties
 *-----------------------------------------------------------------------------------------
 */
/**
 *  property to assign cache policy like CACHE_THEN_NETWORK, NETWORK_ELSE_CACHE, NETWORK_ONLY, etc.
 */
@property (nonatomic, assign) CachePolicy cachePolicy;


//MARK: Manually set headers -
/**---------------------------------------------------------------------------------------
 * @name Manually set headers
 *  ---------------------------------------------------------------------------------------
 */

/**
 Set a header for an query
 
     //Obj-C
     Query *blogQuery = [contentTypeObj query];
     [blogQuery setHeader:@"MyHeaderValue" forKey:@"My-Custom-Header-Key"];
 
     //Swift
     var blogQuery:Query = contentTypeObj.query()
     blogQuery.setHeader("MyHeaderValue", forKey:"My-Custom-Header-Key")
 
 @param headerValue The header key
 @param headerKey   The header value
 */
- (void)setHeader:(NSString *)headerValue forKey:(NSString *)headerKey;

/**
 Set a header for an query
 
     //Obj-C
     Query *blogQuery = [contentTypeObj query];
     [blogQuery addHeadersWithDictionary:@{@"My-Custom-Header-Key":@"MyHeaderValue"}];
     
     //Swift
     var blogQuery:Query = contentTypeObj.query()
     blogQuery.addHeadersWithDictionary(["My-Custom-Header-Key":"MyHeaderValue"])
 
 @param headers The headers as dictionary which needs to be added to the application
 */
- (void)addHeadersWithDictionary:(NSDictionary *)headers;

/**
 Removes a header from this query.
 
     //Obj-C
     Query *blogQuery = [contentTypeObj query];
     [blogQuery removeHeaderForKey:@"My-Custom-Header-Key"];
     
     //Swift
     var blogQuery:Query = contentTypeObj.query()
     blogQuery.removeHeaderForKey("My-Custom-Header-Key")
 
 @param headerKey The header key that needs to be removed
 */
- (void)removeHeaderForKey:(NSString *)headerKey;

//MARK: - Language -
/**---------------------------------------------------------------------------------------
 * @name Language
 *  ---------------------------------------------------------------------------------------
 */

/**
This method provides all the entries for the specified language in the response.
 
     //Obj-C
     [blogQuery language:ENGLISH_UNITED_STATES];
     
     //Swift
     blogQuery.language(Language.ENGLISH_UNITED_STATES)

@param language Language enum for all language available.
 */
- (void)language:(Language)language;

//MARK: - Search -
/**---------------------------------------------------------------------------------------
 * @name Search
 *  ---------------------------------------------------------------------------------------
 */

/**
 This method provides only the entries matching the specified value.
 
     //Obj-C
     [blogQuery search:@"header"];
     
     //Swift
     blogQuery.search(@"header")
 
 @param searchString The value used to match or compare
 */
- (void)search:(NSString*)searchString;

//MARK: - Tags -
/**---------------------------------------------------------------------------------------
 * @name Tags
 *  ---------------------------------------------------------------------------------------
 */

/**
 This method provides only the entries that contain tags matching the ones mentioned in the function.
 
     //Obj-C
     [blogQuery tags:@[@"phone", @"laptop"]];
     
     //Swift
     blogQuery.tags(["phone", "laptop"])
 
 @param tagsArray An array of tags that are to be included for the key
 */
- (void)tags:(NSArray*)tagsArray;

//MARK: Subqueryies with AND / OR -
/**---------------------------------------------------------------------------------------
 * @name Subqueries with AND / OR
 *  ---------------------------------------------------------------------------------------
 */

/**
 This method performs the OR operation on the specified query objects and provides only the matching entries.

     //Obj-C
     Query *query1 = [contentTypeObj query];
     [query1 whereKey:@"title" equalTo:@"Welcome"];
     
     Query *query2 = [contentTypeObj query];
     [query2 whereKey:@"introduction" equalTo:@"This is Test"];
 
     [blogQuery orWithSubqueries:@[query1, query2]];
     
     //Swift
     var query1:Query = contentTypeObj.query()
     query1.whereKey("title", equalTo:"Welcome")
     
     var query2:Query = contentTypeObj.query()
     query2.whereKey("introduction", equalTo:"This is Test")
 
     blogQuery.orWithSubqueries([query1, query2])
 
 @param queries Array of queries to be taken into consideration
 */
- (void)orWithSubqueries:(NSArray *)queries;

/**
 This method performs the AND operation on the specified query objects and provides only the matching entries.
 
     //Obj-C
     Query *query1 = [contentTypeObj query];
     [query1 whereKey:@"total_hits" greaterThanOrEqualTo:@(800)];
     
     Query *query2 = [contentTypeObj query];
     [query2 whereKey:@"total_hits" lessThanOrEqualTo:@(1200)];
     
     [blogQuery andWithSubqueries:@[query1, query2]];
     
     //Swift
     var query1:Query = contentTypeObj.query()
     query1.whereKey("total_hits", greaterThanOrEqualTo:800)
     
     var query2:Query = contentTypeObj.query()
     query2.whereKey("total_hits", equalTo:1200)
     
     blogQuery.andWithSubqueries([query1, query2])
 
 @param queries Array of queries to be taken into consideration
 */
- (void)andWithSubqueries:(NSArray *)queries;

//MARK: - Sorting
/**---------------------------------------------------------------------------------------
 * @name Sorting
 *  ---------------------------------------------------------------------------------------
 */

/**
Sorts the provided entries in the ascending order on the basis of the specified field.
 
     //Obj-C
     [blogQuery orderByAscending:@"updated_at"];
     
     //Swift
     blogQuery.orderByAscending("updated_at")
 
@param key field uid based on which the ordering should be done.
 */
- (void)orderByAscending:(NSString *)key;

/**
 Sorts the provided entries in the descending order on the basis of the specified field.
 
     //Obj-C
     [blogQuery orderByDescending:@"updated_at"];
     
     //Swift
     blogQuery.orderByDescending("updated_at")
 
 @param key field uid based on which the ordering should be done.
 */
- (void)orderByDescending:(NSString *)key;

//MARK: Include -
/**---------------------------------------------------------------------------------------
 * @name Include
 *  ---------------------------------------------------------------------------------------
 */

/**
Provides only the number of entries with values matching the specified values for a field.
 
     //Obj-C
     [blogQuery objectsCount];
     
     //Swift
     blogQuery.objectsCount()
 
 */
- (void)objectsCount;

/**
This method also includes the schema of the contenttype for the entries returned in the response.
 
     //Obj-C
     [blogQuery includeSchema];
     
     //Swift
     blogQuery.includeSchema()
 
 */
- (void)includeSchema __attribute((deprecated("Use the includeContentType instead.")));;

/**
 This method also includes the contenttype for the entries returned in the response.
 
     //Obj-C
     [blogQuery includeContentType];
 
     //Swift
     blogQuery.includeContentType()
 
 */
- (void)includeContentType;

/**
This method also includes owner information for all the entries returned in the response.
 
     //Obj-C
     [blogQuery includeOwner];
     
     //Swift
     blogQuery.includeOwner()
 
 */
- (void)includeOwner;

/**
This method also includes the total number of entries returned in the response.
 
     //Obj-C
     [blogQuery includeCount];
     
     //Swift
     blogQuery.includeCount()
 
 */
- (void)includeCount;

//MARK: Pagination -
/**---------------------------------------------------------------------------------------
 * @name Pagination
 *  ---------------------------------------------------------------------------------------
 */

/**
This method limits the response by providing only the specified number of entries.

     //Obj-C
     [blogQuery limitObjects:@(5)];
     
     //Swift
     blogQuery.limitObjects(NSNumber(int:5))
 
@param number Number of entries to be returned
 */
- (void)limitObjects:(NSNumber *)number;

/**
 This method limits the response by providing only the specified number of entries.
 
     //Obj-C
     [blogQuery skipObjects:@(5)];
     
     //Swift
     blogQuery.skipObjects(NSNumber(int:5))
 
 @param number Number of entries to be returned
 */
- (void)skipObjects:(NSNumber *)number;

//MARK: Adding Basic Constraints -
/**---------------------------------------------------------------------------------------
 * @name Adding Basic Constraints
 *  ---------------------------------------------------------------------------------------
 */

/**
 Include custom query using a key and a value.
 
     //Obj-C
     [blogQuery addQueryWithKey:@"key_name" andValue:@"MyValue"];
     
     //Swift
     blogQuery.addQueryWithKey("key_name", andValue:"MyValue")
 
 @discussion Include custom query using a key and a value.
 @param key   name of the query.
 @param value value for the query.
 */
- (void)addQueryWithKey:(NSString *)key andValue:(id)value;

/**
 A custom dictionary can be provided to a query that can specify the conditions for retrieving objects.
 
     //Obj-C
     [blogQuery addQueryParams:@{@"Query_Key":@"Query Value"}];
     
     //Swift
     blogQuery.addQueryParams(["Query_Key":"Query Value"])
 
 @param queryDict A dictionary with all the necessary conditions for retrieving objects.
 @discussion If a complex query needs to be performed and if it is difficult to specify it using the query methods, a dictionary can be provided that specifies all the conditions. The dictionary should be as per the JSON format specified in the REST API docs.
 */
- (void)addQueryParams:(NSDictionary *)queryDict;

/**
 Removes custom query.
 
     //Obj-C
     [blogQuery removeQueryWithKey:@"Query_Key"];
     
     //Swift
     blogQuery.removeQueryWithKey("Query_Key")
 
 @param key name of the query.
 */
- (void)removeQueryWithKey:(NSString *)key;


/**
This method provides only the entries matching the specified value for a field.

     //Obj-C
     [blogQuery whereKey:@"title" equalTo:@"Welcome"];
     
     //Swift
     blogQuery.whereKey("title", equalTo:"Welcome")

 
 @param key    Uid of the field that is to be taken into consideration
 @param object The value used to match or compare
 */
- (void)whereKey:(NSString *)key equalTo:(id)object;

/**
This method provides only the entries with values not equal to the specified value for a field.
 
     //Obj-C
     [blogQuery whereKey:@"title" notEqualTo:@"Welcome"];
     
     //Swift
     blogQuery.whereKey("title", notEqualTo:"Welcome")
 
 @param key    Uid of the field that is to be taken into consideration
 @param object The value used to match or compare
 */
- (void)whereKey:(NSString *)key notEqualTo:(id)object;

/**
This method provides only the entries with a values less than the specified value for a field.
 
     //Obj-C
     [blogQuery whereKey:@"created_at" lessThan:@"2015-06-22"];
     
     //Swift
     blogQuery.whereKey("created_at", lessThan:"2015-06-22")
 
 @param key    Uid of the field that is to be taken into consideration
 @param object The value used to match or compare
 */
- (void)whereKey:(NSString *)key lessThan:(id)object;

/**
 This method provides only the entries with values greater than the specified value for a field.
 
     //Obj-C
     [blogQuery whereKey:@"created_at" greaterThan:@"2015-03-12"];
     
     //Swift
     blogQuery.whereKey("created_at", greaterThan:"2015-03-12")
 
 @param key    Uid of the field that is to be taken into consideration
 @param object The value used to match or compare
 */
- (void)whereKey:(NSString *)key greaterThan:(id)object;

/**
 This method provides only the entries with values less than or equal to the specified value for a field.
 
     //Obj-C
     [blogQuery whereKey:@"created_at" lessThanOrEqualTo:@"2015-03-12"];
     
     //Swift
     blogQuery.whereKey("created_at", lessThanOrEqualTo:"2015-03-12")
 
 @param key    Uid of the field that is to be taken into consideration
 @param object The value used to match or compare
 */
- (void)whereKey:(NSString *)key lessThanOrEqualTo:(id)object;

/**
 This method provides only the entries with values greater than or equal to the specified value for a field.
 
     //Obj-C
     [blogQuery whereKey:@"created_at" greaterThanOrEqualTo:@"2015-03-12"];
     
     //Swift
     blogQuery.whereKey("created_at", greaterThanOrEqualTo:"2015-03-12")
 
 @param key    Uid of the field that is to be taken into consideration
 @param object The value used to match or compare
 */
- (void)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object;

/**
This method provides only the entries with values matching the specified values for a field.
 
     //Obj-C
     [blogQuery whereKey:@"title" containedIn:@["Demo", @"Welcome"]];
     
     //Swift
     blogQuery.whereKey("title", containedIn:["Demo", "Welcome"])
 
 @param key    Uid of the field that is to be taken into consideration
 @param array An array of values that are to be used to match or compare
 */
- (void)whereKey:(NSString *)key containedIn:(NSArray *)array;

/**
 This method provides only the entries that do not contain values matching the specified values for a field.
 
     //Obj-C
     [blogQuery whereKey:@"title" notContainedIn:@["Demo", @"Welcome"]];
     
     //Swift
     blogQuery.whereKey("title", notContainedIn:["Demo", "Welcome"])
 
 @param key    Uid of the field that is to be taken into consideration
 @param array An array of values that are to be used to match or compare
 */
- (void)whereKey:(NSString *)key notContainedIn:(NSArray *)array;

/**
This method provides only the entries that contains the field matching the specified field uid.
 
     //Obj-C
     [blogQuery whereKeyExists:@"introduction"];
     
     //Swift
     blogQuery.whereKeyExists("introduction")
 
@param key Uid of the field that is to be taken into consideration
 */
- (void)whereKeyExists:(NSString *)key;

/**
 This method provides only the entries that do not contain the field matching the specified field uid.
 
     //Obj-C
     [blogQuery whereKeyDoesNotExist:@"introduction"];
     
     //Swift
     blogQuery.whereKeyDoesNotExist("introduction")
 
 @param key Uid of the field that is to be taken into consideration
 */
- (void)whereKeyDoesNotExist:(NSString *)key;

/**
This method provides only the entries matching the regular expression for the specified field.
 
     //Obj-C
     [blogQuery whereKey:@"title" matchesRegex:@"^wel"];
     
     //Swift
     blogQuery.whereKey("title", matchesRegex:"^wel")
 
@param key   Uid of the field that is to be taken into consideration
@param regex The value used to match or compare
 */
- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex;

/**
 This method provides only the entries matching the regular expression for the specified field.
 
     //Obj-C
     [blogQuery whereKey:@"title" matchesRegex:@"^wel" modifiers:@"i"];
     
     //Swift
     blogQuery.whereKey("title", matchesRegex:"^wel", modifiers:"i")
 
 @param key   Uid of the field that is to be taken into consideration
 @param regex The value used to match or compare
 @param modifier Modifiers for regex options. Specify 'i' as the option to ignore the case.
 */
- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex modifiers:(NSString *)modifier;

//MARK: Selective fields using only/except -
/**---------------------------------------------------------------------------------------
 * @name Selective fields using only/except
 *  ---------------------------------------------------------------------------------------
 */

/**
This method provides only the entries that match the specified field uids and corresponding values.
 
     //Obj-C
     [blogQuery onlyFields:@[@"attachments"]];
     
     //Swift
     blogQuery.onlyFields(["attachments"])

@param fieldUIDs An array of values that are to be included for the key
 */
- (void)onlyFields:(NSArray *)fieldUIDs;

/**
 This method provides all entries except those that match the specified field uids and corresponding values.
 
     //Obj-C
     [blogQuery exceptFields:@[@"attachments"]];
     
     //Swift
     blogQuery.exceptFields(["attachments"])
 
 @param fieldUIDs An array of values that are to be included for the key
 */
- (void)exceptFields:(NSArray *)fieldUIDs;

//MARK: Reference Query (Query Conditions on Reference fields) -
/**---------------------------------------------------------------------------------------
 * @name Reference Query (Query Conditions on Reference fields)
 *  ---------------------------------------------------------------------------------------
 */

/**
This method provides all entries that also contain data from the referred entry in the specified field.

     //Obj-C
     [blogQuery includeReferenceFieldWithKey:@"entry_a"];
     
     //Swift
     blogQuery.includeReferenceFieldWithKey(@"entry_a")
 
@param key Uid of the reference field that is to be taken into consideration
 */
- (void)includeReferenceFieldWithKey:(NSArray *)key;

/**
 This method provides all entries incuding referred entry containing only specified fields.
 
     //Obj-C
     [blogQuery includeReferenceFieldWithKey:@"reference_field_uid" onlyFields:@[@"attachments"]];
     
     //Swift
     blogQuery.includeReferenceFieldWithKey(@"reference_field_uid", onlyFields:["attachments"])
 
 @param key Uid of the reference field that is to be taken into consideration
 @param fieldUIDs Uid of the reference field that is to be taken into consideration
 */
- (void)includeReferenceFieldWithKey:(NSString *)key onlyFields:(NSArray *)fieldUIDs;

/**
 This method provides all entries incuding referred entry containing all fields except specified fields.
 
     //Obj-C
     [blogQuery includeReferenceFieldWithKey:@"entry_a" excludingFields:@[@"attachments"]];
     
     //Swift
     blogQuery.includeReferenceFieldWithKey(@"entry_a", excludingFields:["attachments"])
 
 @param key Uid of the reference field that is to be taken into consideration
 @param fieldUIDs Uid of the reference field that is to be taken into consideration
 */
- (void)includeReferenceFieldWithKey:(NSString *)key excludingFields:(NSArray *)fieldUIDs;

/**
 This method adds key and value to a query.
 
     //Obj-C
     Query *blogQuery = [contentTypeObj query];
     [blogQuery addParamKey:@"key" andValue:@"value"];
 
     //Swift
     var blogQuery:Query = contentTypeObj.query()
     blogQuery.addParamKey("key", andValue:"value")
 
 @param key The key as string which needs to be added to the Query
 @param value The value as string which needs to be added to the Query
 */
- (void)addParamKey:(NSString *)key andValue:(NSString *)value;


//MARK: Execute Query -
/**---------------------------------------------------------------------------------------
 * @name Execute Query
 *  ---------------------------------------------------------------------------------------
 */

/**
This method provides all the entries from a specified contenttype.

     //Obj-C
     [blogQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        //error for any error description
        //result for reponse data
     }];
     
     //Swift
     blogQuery.find { (responseType, result!, error!) -> Void in
         //error for any error description
         //result for reponse data
     }
 
@param completionBlock block to be called once operation is done. The result data contains all entries of the specified contenttype.
 */
- (void)find:(void (^) (ResponseType type,QueryResult * BUILT_NULLABLE_P result,NSError * BUILT_NULLABLE_P error))completionBlock;

/**
This method provides the first entry from a specified contenttype.
 
     //Obj-C
     [blogQuery findOne:^(ResponseType type, Entry *entry, NSError *error) {
         //error for any error description
         //result for reponse data
     }];
     
     //Swift
     blogQuery.findOne { (responseType, entry!, error!) -> Void in
         //error for any error description
         //result for reponse data
     }
 
@param completionBlock block to be called once operation is done.
 */
- (void)findOne:(void (^) (ResponseType type,Entry  * BUILT_NULLABLE_P entry,NSError  * BUILT_NULLABLE_P error))completionBlock;

//MARK: Cancel execution -
/**---------------------------------------------------------------------------------------
 * @name Cancel execution
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Advises the operation object that it should stop executing its task.
 
     //Obj-C
     [blogQuery cancelRequests];
     
     //Swift
     blogQuery.cancelRequests()
 
 @discussion This method does not force your operation code to stop. Instead, it updates the object’s internal flags to reflect the change in state. If the operation has already finished executing, this method has no effect. Canceling an operation that is currently in an operation queue, but not yet executing, makes it possible to remove the operation from the queue sooner than usual.
 */
- (void)cancelRequests;

@end

BUILT_ASSUME_NONNULL_END
