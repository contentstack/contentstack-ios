//
//  CSURLSessionManager.h
//  Contentstack
//
//  Created by Uttam Ukkoji on 23/10/19.
//  Copyright © 2019 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contentstack/CSURLSessionDelegate.h>
NS_ASSUME_NONNULL_BEGIN

@interface CSURLSessionManager : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

+ (instancetype)manager: (NSURLSessionConfiguration*) configuration delegate:(id<CSURLSessionDelegate>) delegate;
/**
 The managed session.
 */
@property (readonly, nonatomic, strong) NSURLSession *session;

@property (nullable, readonly, retain) id<CSURLSessionDelegate> delegate;

/**
 The operation queue on which delegate callbacks are run.
 */
@property (readonly, nonatomic, strong) NSOperationQueue *operationQueue;

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                                      success:(void (^)(NSURLSessionDataTask *, id))success
                                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end

NS_ASSUME_NONNULL_END
