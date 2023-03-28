//
//  CSIOCoreNetworking.h
//  Contentstack
//
//  Created by Reefaq on 22/06/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contentstack/CSURLSessionDelegate.h>
#import "CSIOCoreNetworkingProtocol.h"


@interface CSIOCoreHTTPNetworking : NSObject <CSIOCoreNetworkingProtocol>
-(instancetype)initWithDelegate: (id<CSURLSessionDelegate>) delegate;
@end
