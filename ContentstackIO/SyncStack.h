//
//  SyncStack.h
//  ThirdPartyExtension
//
//  Created by Uttam Ukkoji on 02/07/18.
//  Copyright © 2018 Contentstack.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SyncStack : NSObject
/**
 * Readonly property contains all the Contents
 */
@property (nonatomic, copy, readonly) NSArray * _Nullable items;

/**
 * Readonly property for paginating sync
 */
@property (nonatomic, copy, readonly) NSString * _Nullable paginationToken;

/**
 *Readonly property to delta sync.
 */
@property (nonatomic, copy, readonly) NSString * _Nullable syncToken;
/**
 *  Readonly property to check skip count
 */
@property (nonatomic, assign, readonly) unsigned int skip;
/**
 *  Readonly property to check limit
 */
@property (nonatomic, assign, readonly) unsigned int limit;

/**
 *  Readonly property to check totalCount
 */
@property (nonatomic, assign, readonly) unsigned int totalCount;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
@end

NS_ASSUME_NONNULL_END
