//
//  Config.h
//  contentstack
//
//  Created by Priyanka Mistry on 01/06/16.
//  Copyright © 2016 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

/**----------------------------------------------------------------------------------------
 * @name Properties
 *-----------------------------------------------------------------------------------------
 */

//MARK: - Contentstack host
/**
 Host name of Contentstack api server.
 
     //Obj-C
    Config *config = [[Config alloc] init];
     config.host = @"api.contentstack.io";
     
     //Swift
     var config:Config = Config()
     config.host = "api.contentstack.io"
 
 */
@property (nonatomic, copy) NSString *host;

/**
 SSL state of Contentstack api server.
 
     //Obj-C
    Config *config = [[Config alloc] init];
     config.isSSL = YES;
     
     //Swift
     var config:Config = Config()
     config.isSSL = true
 
 */
@property (nonatomic, assign) BOOL isSSL;

/**
 API version of Contentstack api server.
 
     //Obj-C
     Config *config = [[Config alloc] init];
     NSString version = config.version;
     
     //Swift
     var config:Config = Config()
     let version = config.version
 
 */
@property (nonatomic, copy, readonly) NSString *version;

@end
