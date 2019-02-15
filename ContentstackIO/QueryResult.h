//
//  QueryResult.h
//  Contentstack
//
//  Created by Reefaq on 11/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentstackDefinitions.h"

BUILT_ASSUME_NONNULL_BEGIN

@class ContentType;
@interface QueryResult : NSObject


- (instancetype)init UNAVAILABLE_ATTRIBUTE;

//MARK: Result -
/**---------------------------------------------------------------------------------------
 * @name Result
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Get array of entries returned by Query.
 
     //Obj-C
     [blogQuery execInBackground:^(ResponseType type, QueryResult *result, NSError *error) {
        NSArray *result = [result getResult];// get all result in array
     }];
     
     //Swift
     blogQuery.execInBackground { (responseType, result!, error!) -> Void in
        var results:Array  =  result.getResult()
     }
 
 @return Returns an array of entries returned by Query.
 */
- (BUILT_NULLABLE NSArray *)getResult;
/**
 @abstract Gets the schema of objects returned by Query alongwith objects themselves.
 
     //Obj-C
     [projectQuery execInBackground:^(ResponseType type, QueryResult *result, NSError *error) {
        NSArray *result = [result schema];
     }];
     
     //Swift
     projectQuery.execInBackground { (ResponseType, QueryResult!, NSError!) -> Void in
        var schema:Array  =  QueryResult.schema()
     }
 
 @return Returns schemas.
 */
- (BUILT_NULLABLE NSArray *)schema;
/**
 @abstract Gets the content type of objects returned by Query alongwith objects themselves.
 
     //Obj-C
     [projectQuery execInBackground:^(ResponseType type, QueryResult *result, NSError *error) {
         NSDictionary *result = [result content_type];
     }];
 
     //Swift
     projectQuery.execInBackground { (ResponseType, QueryResult!, NSError!) -> Void in
         var schema:NSDictionary  =  QueryResult.content_type()
     }
 
 @return Returns content type.
 */
- (BUILT_NULLABLE NSDictionary *)content_type;

//MARK: Count -
/**---------------------------------------------------------------------------------------
 * @name Count
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Count of number of entries returned by Query alongwith entries themselves.
 
     //Obj-C
     [blogQuery execInBackground:^(ResponseType type, QueryResult *result, NSError *error) {
        NSInteger totalCount = [result totalCount];// totalcount
     }];
     
     //Swift
     blogQuery.execInBackground { (responseType, result!, error!) -> Void in
        var total:Int  =  result.totalCount()
     }
 
 @return Returns the count of number of object returned by Query.
 */
- (NSInteger)totalCount;

@end

BUILT_ASSUME_NONNULL_END
