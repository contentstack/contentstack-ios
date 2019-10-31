//
//  CSError.h
//  Contentstack
//
//  Created by Uttam Ukkoji on 24/10/19.
//  Copyright © 2019 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSError : NSError

/// Contentstack error message
@property (readonly, nonatomic, strong) NSString *errorMessage;

/// Contentstack error information dictionary
@property (readonly, nonatomic, strong) NSDictionary *errorInfo;

/// Contentstack error code
@property (readonly, nonatomic) NSInteger errorCode;

/// Contentstack response status code
@property (readonly, nonatomic) NSInteger statusCode;


@end

NS_ASSUME_NONNULL_END
