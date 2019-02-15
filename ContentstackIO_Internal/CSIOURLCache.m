//
//  CSIOURLCache.m
//  contentstack
//
//  Created by Reefaq on 28/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import "CSIOURLCache.h"
#import "CSIOConstants.h"

@implementation CSIOURLCache

+ (instancetype)standardURLCache {
    static CSIOURLCache *_standardURLCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardURLCache = [[CSIOURLCache alloc] initWithMemoryCapacity:0 diskCapacity:(20 * 1024 * 1024) diskPath:@"csio_cache"];
    });
    return _standardURLCache;
}
              
#pragma mark - NSURLCache
                  
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    NSURLRequest *changedRequest = request;
    if ([request.allHTTPHeaderFields[kCSIO_HTTPMethod] isEqualToString:kCSIO_HTTPGET]) {
        NSMutableURLRequest *modifiedRequest = [[NSMutableURLRequest alloc] initWithURL:request.URL cachePolicy:request.cachePolicy timeoutInterval:request.timeoutInterval];
        [modifiedRequest setAllHTTPHeaderFields:request.allHTTPHeaderFields];
        
        [modifiedRequest setHTTPMethod:kCSIO_HTTPGET];
        [modifiedRequest setHTTPBody:request.HTTPBody];
        
        changedRequest = modifiedRequest;
    }

  NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:changedRequest];
  
  return cachedResponse;
}
                  
- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse
forRequest:(NSURLRequest *)request
{
    NSURLRequest *changedRequest = request;
    if ([request.allHTTPHeaderFields[kCSIO_HTTPMethod] isEqualToString:kCSIO_HTTPGET]) {
        NSMutableURLRequest *modifiedRequest = [[NSMutableURLRequest alloc] initWithURL:request.URL cachePolicy:request.cachePolicy timeoutInterval:request.timeoutInterval];
        [modifiedRequest setAllHTTPHeaderFields:request.allHTTPHeaderFields];
        
        [modifiedRequest setHTTPMethod:kCSIO_HTTPGET];
        [modifiedRequest setHTTPBody:request.HTTPBody];

        changedRequest = modifiedRequest;
    }
    
    NSCachedURLResponse *modifiedCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:cachedResponse.userInfo storagePolicy:cachedResponse.storagePolicy];
    
    [super storeCachedResponse:modifiedCachedResponse forRequest:changedRequest];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    NSMutableDictionary *mutableUserInfo = [[cachedResponse userInfo] mutableCopy];
    NSMutableData *mutableData = [[cachedResponse data] mutableCopy];
    NSURLCacheStoragePolicy storagePolicy = NSURLCacheStorageAllowed;
    
    return [[NSCachedURLResponse alloc] initWithResponse:[cachedResponse response]
                                                    data:mutableData
                                                userInfo:mutableUserInfo
                                           storagePolicy:storagePolicy];
}
                  


@end
