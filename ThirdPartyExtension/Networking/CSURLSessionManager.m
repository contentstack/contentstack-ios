//
//  CSURLSessionManager.m
//  Contentstack
//
//  Created by Uttam Ukkoji on 23/10/19.
//  Copyright © 2019 Contentstack. All rights reserved.
//

#import "CSURLSessionManager.h"
#import "CSError.h"
#import "CSIOInternalHeaders.h"

#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_With_Fixed_bug 1140.11
#else
#define NSFoundationVersionNumber_With_Fixed_bug NSFoundationVersionNumber_iOS_8_0
#endif

NSString * const CSURLSessionDidInvalidateNotification = @"com.contentstack.networking.session.invalidate";


static NSError * CSErrorWithUnderlyingError(NSError *error, NSError *underlyingError) {
    if (!error) {
        return underlyingError;
    }

    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }

    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;

    return [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
}

static dispatch_queue_t url_session_manager_creation_queue() {
    static dispatch_queue_t cs_url_session_manager_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cs_url_session_manager_creation_queue = dispatch_queue_create("com.contentstack.networking.session.manager.creation", DISPATCH_QUEUE_SERIAL);
    });

    return cs_url_session_manager_creation_queue;
}

static void cs_url_session_manager_create_task_safely(dispatch_block_t block) {
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_With_Fixed_bug) {
        // Fix of bug
        // Open Radar:http://openradar.appspot.com/radar?id=5871104061079552 (status: Fixed in iOS8)
        // Issue about:https://github.com/AFNetworking/AFNetworking/issues/2093
        dispatch_sync(url_session_manager_creation_queue(), block);
    } else {
        block();
    }
}


@interface CSURLSessionManager ()

@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (readwrite, nonatomic, strong) NSOperationQueue *operationQueue;
@property (readwrite, nonatomic, strong) NSURLSession *session;
@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableTaskDelegatesKeyedByTaskIdentifier;

@end

@implementation CSURLSessionManager

+ (instancetype)manager: (NSURLSessionConfiguration*) configuration {
    return [[[self class] alloc] initWithConfiguration: configuration];
}

- (instancetype)initWithConfiguration: (NSURLSessionConfiguration *) configuration
{
    self = [super init];
    if (self) {
        if (!configuration) {
            configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        self.sessionConfiguration = configuration;
        
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;

        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue];

    }
    return self;
}


- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    BOOL isSpace = [data isEqualToData:[NSData dataWithBytes:" " length:1]];
    
    if (data.length == 0 || isSpace) {
        return nil;
    }
    
    NSError *serializationError = nil;
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];

    if (!responseObject)
    {
        if (error) {
            *error = CSErrorWithUnderlyingError(serializationError, *error);
        }
        return nil;
    }

    return responseObject;
}
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                                      success:(void (^)(NSURLSessionDataTask *, id))success
                                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    __block NSURLSessionDataTask *dataTask = nil;
    cs_url_session_manager_create_task_safely(^{
        dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                if (failure) {
                    failure(dataTask, error);
                }
            }else {
                NSError * err = nil;
                id responseObject = [self responseObjectForResponse:response data:data error:&err];
                if (error) {
                    if (failure) {
                        failure(dataTask, err);
                    }
                }else if (((NSHTTPURLResponse*)response).statusCode != 200 ) {
                    CSError* error = [CSError error:responseObject statusCode:((NSHTTPURLResponse*)response).statusCode];
                    if (failure) {
                        failure(dataTask, error);
                    }
                }else if (success) {
                     success(dataTask, responseObject);
                }
            }
        }];
    });

//    [self addDelegateForDataTask:dataTask uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];
    [dataTask resume];
    return dataTask;
}



#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
didBecomeInvalidWithError:(NSError *)error
{

    [[NSNotificationCenter defaultCenter] postNotificationName:CSURLSessionDidInvalidateNotification object:session];
}

- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }

    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSURLRequest *redirectRequest = request;
    if (completionHandler) {
        completionHandler(redirectRequest);
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }

    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
    NSInputStream *inputStream = nil;

   if (task.originalRequest.HTTPBodyStream && [task.originalRequest.HTTPBodyStream conformsToProtocol:@protocol(NSCopying)]) {
        inputStream = [task.originalRequest.HTTPBodyStream copy];
    }

    if (completionHandler) {
        completionHandler(inputStream);
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{

    int64_t totalUnitCount = totalBytesExpectedToSend;
    if(totalUnitCount == NSURLSessionTransferSizeUnknown) {
        NSString *contentLength = [task.originalRequest valueForHTTPHeaderField:@"Content-Length"];
        if(contentLength) {
            totalUnitCount = (int64_t) [contentLength longLongValue];
        }
    }
    
//    AFURLSessionManagerTaskDelegate *delegate = [self delegateForTask:task];
//
//    if (delegate) {
//        [delegate URLSession:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
//    }

}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
//    AFURLSessionManagerTaskDelegate *delegate = [self delegateForTask:task];
//
//    // delegate may be nil when completing a task in the background
//    if (delegate) {
//        [delegate URLSession:session task:task didCompleteWithError:error];
//
//        [self removeDelegateForTask:task];
//    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;

    if (completionHandler) {
        completionHandler(disposition);
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
//    AFURLSessionManagerTaskDelegate *delegate = [self delegateForTask:dataTask];
//    if (delegate) {
//        [self removeDelegateForTask:dataTask];
//        [self setDelegate:delegate forTask:downloadTask];
//    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{

//    AFURLSessionManagerTaskDelegate *delegate = [self delegateForTask:dataTask];
//    [delegate URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    NSCachedURLResponse *cachedResponse = proposedResponse;

    if (completionHandler) {
        completionHandler(cachedResponse);
    }
}

@end
