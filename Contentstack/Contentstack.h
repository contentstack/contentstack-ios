//
//  Contentstack.h
//  Contentstack
//
//  Created by Reefaq on 22/06/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

//  sdk-version: 3.10.1

#import <Foundation/Foundation.h>
#import <Contentstack/Config.h>
#import <Contentstack/Stack.h>
#import <Contentstack/ContentType.h>
#import <Contentstack/Taxonomy.h>
#import <Contentstack/Entry.h>
#import <Contentstack/Query.h>
#import <Contentstack/Asset.h>
#import <Contentstack/AssetLibrary.h>
#import <Contentstack/QueryResult.h>
#import <Contentstack/Group.h>
#import <Contentstack/SyncStack.h>
#import <Contentstack/CSURLSessionDelegate.h>

@class Stack;

BUILT_ASSUME_NONNULL_BEGIN

@interface Contentstack : NSObject

/**----------------------------------------------------------------------------------------
 * @name Intialize Stack
 *-----------------------------------------------------------------------------------------
 */

/**
Create a new Stack instance with stack's apikey, token, environment name and config.

     //Obj-C
     Config *config = [[Config alloc] init];
     config.host = @"customcontentstack.io";
     Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"prod" config:config];
 
     //Swift
     let config:Config = Config()
     config.host = "customcontentstack.io"
     let stack:Stack = Contentstack.stackWithAPIKey("API_KEY",accessToken:"DELIVERY_TOKEN", environmentName:@"prod", config:config)

@param apiKey          stack apiKey.
@param accessToken     stack accessToken.
@param environmentName environment name in which to perform action.
@param config          config of stack.

@return new instance of Stack.
 */
+ (Stack*)stackWithAPIKey:(NSString*)apiKey accessToken:(NSString *)accessToken environmentName:(NSString*)environmentName config:(Config *)config;


/**
 Create a new Stack instance with stack's apikey, token and environment name.
 
     //Obj-C
     Stack *stack = [Contentstack stackWithAPIKey:@"API_KEY" accessToken:@"DELIVERY_TOKEN" environmentName:@"prod"];
     
     //Swift
     let stack:Stack = Contentstack.stackWithAPIKey("API_KEY", accessToken:"DELIVERY_TOKEN", environmentName:@"prod")
 
 @param apiKey          stack apiKey.
 @param token           accessToken of stack.
 @param environmentName environment name in which to perform action.
 
 @return new instance of Stack.
 */
+ (Stack*)stackWithAPIKey:(NSString*)apiKey accessToken:(NSString*)token environmentName:(NSString*)environmentName;


/**
Cancel all network request for Stack instance.

     //Obj-C
     [Contentstack cancelAllRequestsOfStack:stack];
     
     //Swift
     Contentstack.cancelAllRequestsOfStack(stack)
 
@param stack instance of Stack.
 */
+ (void)cancelAllRequestsOfStack:(Stack*)stack;

@end

BUILT_ASSUME_NONNULL_END
