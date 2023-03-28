//
//  CSURLSessionDelegate.h
//  Contentstack
//
//  Created by Uttam Ukkoji on 24/03/23.
//  Copyright © 2023 Contentstack. All rights reserved.
//

#ifndef CSURLSessionDelegate_h
#define CSURLSessionDelegate_h
#import <Foundation/NSURLRequest.h>

@class NSURLSession;
@class NSURLAuthenticationChallenge;

API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0))
@protocol CSURLSessionDelegate <NSObject>
@optional

- (void)URLSession:(NSURLSession *_Nonnull)session didReceiveChallenge:(NSURLAuthenticationChallenge *_Nonnull)challenge
 completionHandler:(void (NS_SWIFT_SENDABLE ^_Nonnull)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;

- (void)URLSession:(NSURLSession *_Nonnull)session task:(NSURLSessionTask *_Nonnull)task
                            didReceiveChallenge:(NSURLAuthenticationChallenge *_Nonnull)challenge
                              completionHandler:(void (NS_SWIFT_SENDABLE ^_Nonnull)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;

@end
#endif /* CSURLSessionDelegate_h */
