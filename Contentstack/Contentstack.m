//
//  Contentstack.m
//  Contentstack
//
//  Created by Reefaq on 22/06/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import "Contentstack.h"
#import "CSIOInternalHeaders.h"
#import <Contentstack/Stack.h>

@interface Contentstack ()
@end

@implementation Contentstack

//MARK: - Initialization
+ (Contentstack *)sharedInstance {
    static Contentstack *stack = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stack = [[Contentstack alloc] init];
        
    });
    return stack;
}

+ (Stack*)stackWithAPIKey:(NSString*)apiKey accessToken:(NSString*)token environmentName:(NSString*)environmentName;{
    Config *config = [[Config alloc] init];
    return [Contentstack stackWithAPIKey:apiKey accessToken:token environmentName:environmentName config:config];
}

+ (Stack*)stackWithAPIKey:(NSString*)apiKey accessToken:(NSString *)accessToken environmentName:(NSString*)environmentName config:(Config *)config; {
    Stack *stack = [[Stack alloc] initWithAPIKey:apiKey andaccessToken:accessToken andEnvironment:environmentName andConfig:config];
    return stack;
}


+ (void)cancelAllRequestsOfStack:(Stack*)stack {
    if (stack && stack.network) {
        [stack.network cancelAllOperations];
    }
}

@end
