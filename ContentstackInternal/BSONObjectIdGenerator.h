//
//  BSONObjectIdGenerator.h
//  Contentstack
//
//  Created by Vikram Kalta on 09/02/2024.
//  Copyright © 2024 Contentstack. All rights reserved.
//
#ifndef BSONObjectIdGenerator_h
#define BSONObjectIdGenerator_h

#import <Foundation/Foundation.h>

typedef union {
    char bytes[12];
    int ints[3];
} bson_oid_t;

@interface BSONObjectIdGenerator : NSObject

+ (NSString *)generate:(NSInteger)timestamp;

@end

#endif /* BSONObjectIdGenerator_h */
