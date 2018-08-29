//
//  ContentstackCoreNetworkingProtocol.h
//  Contentstack
//
//  Created by Reefaq on 13/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//
#import "ContentstackDefinitions.h"

@class Stack;

typedef NS_ENUM(NSUInteger, CSIOCoreNetworkingRequestType) {
    CSIOCoreNetworkingRequestTypeGET,
    CSIOCoreNetworkingRequestTypePOST,
    CSIOCoreNetworkingRequestTypePUT,
    CSIOCoreNetworkingRequestTypeDELETE
};

typedef void (^CSIONetworkCompletionHandler)(ResponseType responseType, id responseJSON, NSError *error);

@protocol CSIOCoreNetworkingProtocol <NSObject>

//MARK: - async

- (id)requestForStack:(Stack*)stack
         withURLPath:(NSString*)urlPath
         requestType:(CSIOCoreNetworkingRequestType)requestType
              params:(NSDictionary*)paramDict
   additionalHeaders:(NSDictionary*)additionalHeaders
          completion:(CSIONetworkCompletionHandler)completionBlock;

- (id)requestForStack:(Stack*)stack
         withURLPath:(NSString*)urlPath
         requestType:(CSIOCoreNetworkingRequestType)requestType
              params:(NSDictionary*)paramDict
   additionalHeaders:(NSDictionary*)additionalHeaders
         cachePolicy:(CachePolicy)cachePolicy
          completion:(CSIONetworkCompletionHandler)completionBlock;

- (id)requestForStack:(Stack*)stack
         withURLPath:(NSString*)urlPath
         requestType:(CSIOCoreNetworkingRequestType)requestType
              params:(NSDictionary*)paramDict
         withFileKey:(NSString*)fileKey
        withFileData:(id)filedata
   additionalHeaders:(NSDictionary*)additionalHeaders
          completion:(CSIONetworkCompletionHandler)completionBlock;

- (id)requestDataForStack:(Stack*)stack
         withURLPath:(NSString*)urlPath
         requestType:(CSIOCoreNetworkingRequestType)requestType
              params:(NSDictionary*)paramDict
   additionalHeaders:(NSDictionary*)additionalHeaders
          completion:(CSIONetworkCompletionHandler)completionBlock;

//MARK: - cancel

- (void)cancelAllOperations;

@end
