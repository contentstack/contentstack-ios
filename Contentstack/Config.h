//
//  Config.h
//  contentstack
//
//  Created by Priyanka Mistry on 01/06/16.
//  Copyright © 2016 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contentstack/ContentstackDefinitions.h>
#import <Contentstack/CSURLSessionDelegate.h>
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
 Region name of Contentstack Database server.
 
     //Obj-C
     Config *config = [[Config alloc] init];
     region = ContentstackRegion.EU;
 
     //Swift
     var config:Config = Config()
     region = ContentstackRegion.eu
 
 */

@property (nonatomic) ContentstackRegion region;
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


/**
 Branch id for the
 
     //Obj-C
     Config *config = [[Config alloc] init];
     NSString branch = config.branch;
     
     //Swift
     var config:Config = Config()
     let branch = config.branch
 
 */
@property (nonatomic, copy) NSString *branch;


/**
 Branch id for the
 
     //Obj-C
     Config *config = [[Config alloc] init];
     config.delegate = [[CSDelegate alloc] init];
     
     //Swift
     var config:Config = Config()
     config.delegate = CSDelegate()
 
 */
@property (nullable, retain) id<CSURLSessionDelegate> delegate;



/**
 Early access features
 
     //Obj-C
     Config *config = [[Config alloc] init];
     [config setEarlyAccess:@[@"Taxonomy", @"Teams", @"Terms", @"LivePreview"]];
     
     //Swift
     let config = Config()
     config.setEarlyAccess(["Taxonomy", "Teams", "Terms", "LivePreview"])
 
 */
@property (nonatomic, strong, nullable) NSArray<NSString *> *setEarlyAccess;


/**
 Set early access features
 
 @param setearlyAccess An array of early access feature names
 */
- (NSDictionary<NSString *, NSString *> *)earlyAccessHeaders;
@end
