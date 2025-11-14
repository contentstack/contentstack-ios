//
//  ContentstackMainTest.m
//  ContentstackTest
//
//  Created by Contentstack on 06/11/25.
//  Copyright © 2025 Contentstack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Contentstack.h"
#import "Stack.h"
#import "Config.h"

@interface ContentstackMainTest : XCTestCase
@property (nonatomic, strong) NSDictionary *config;
@end

@implementation ContentstackMainTest

- (void)setUp {
    [super setUp];
    
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"config" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        self.config = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
}

- (void)tearDown {
    self.config = nil;
    [super tearDown];
}

#pragma mark - Stack Creation Tests

- (void)testStackWithAPIKeyAccessToken {
    Stack *stack = [Contentstack stackWithAPIKey:self.config[@"api_key"]
                                     accessToken:self.config[@"delivery_token"]
                                 environmentName:self.config[@"environment"]];
    
    XCTAssertNotNil(stack);
    XCTAssertTrue([stack isKindOfClass:[Stack class]]);
}

- (void)testStackWithAPIKeyAccessTokenConfig {
    Config *config = [[Config alloc] init];
    config.host = self.config[@"host"];
    
    Stack *stack = [Contentstack stackWithAPIKey:self.config[@"api_key"]
                                     accessToken:self.config[@"delivery_token"]
                                 environmentName:self.config[@"environment"]
                                          config:config];
    
    XCTAssertNotNil(stack);
    XCTAssertTrue([stack isKindOfClass:[Stack class]]);
}

- (void)testStackCreationWithDifferentRegions {
    Config *configUS = [[Config alloc] init];
    configUS.region = US;
    
    Stack *stackUS = [Contentstack stackWithAPIKey:self.config[@"api_key"]
                                       accessToken:self.config[@"delivery_token"]
                                   environmentName:self.config[@"environment"]
                                            config:configUS];
    
    XCTAssertNotNil(stackUS);
    
    Config *configEU = [[Config alloc] init];
    configEU.region = EU;
    
    Stack *stackEU = [Contentstack stackWithAPIKey:self.config[@"api_key"]
                                       accessToken:self.config[@"delivery_token"]
                                   environmentName:self.config[@"environment"]
                                            config:configEU];
    
    XCTAssertNotNil(stackEU);
}

- (void)testMultipleStackInstances {
    Stack *stack1 = [Contentstack stackWithAPIKey:self.config[@"api_key"]
                                      accessToken:self.config[@"delivery_token"]
                                  environmentName:self.config[@"environment"]];
    
    Stack *stack2 = [Contentstack stackWithAPIKey:self.config[@"api_key"]
                                      accessToken:self.config[@"delivery_token"]
                                  environmentName:self.config[@"environment"]];
    
    XCTAssertNotNil(stack1);
    XCTAssertNotNil(stack2);
    // Each call creates a new instance
    XCTAssertNotEqual(stack1, stack2);
}

- (void)testStackWithCustomHost {
    Config *config = [[Config alloc] init];
    config.host = @"custom-cdn.contentstack.io";
    
    Stack *stack = [Contentstack stackWithAPIKey:self.config[@"api_key"]
                                     accessToken:self.config[@"delivery_token"]
                                 environmentName:self.config[@"environment"]
                                          config:config];
    
    XCTAssertNotNil(stack);
}

- (void)testStackWithEmptyEnvironment {
    Stack *stack = [Contentstack stackWithAPIKey:self.config[@"api_key"]
                                     accessToken:self.config[@"delivery_token"]
                                 environmentName:@""];
    
    XCTAssertNotNil(stack);
}

#pragma mark - Config Tests

- (void)testConfigRegions {
    Config *config = [[Config alloc] init];
    
    config.region = US;
    XCTAssertEqual(config.region, US);
    
    config.region = EU;
    XCTAssertEqual(config.region, EU);
    
    config.region = AZURE_NA;
    XCTAssertEqual(config.region, AZURE_NA);
}

- (void)testConfigHost {
    Config *config = [[Config alloc] init];
    
    config.host = @"test-host.contentstack.io";
    XCTAssertEqualObjects(config.host, @"test-host.contentstack.io");
}

- (void)testConfigVersionReadonly {
    Config *config = [[Config alloc] init];
    
    // Version is readonly, just verify it exists
    XCTAssertNotNil(config.version);
}

- (void)testConfigBranchWritable {
    Config *config = [[Config alloc] init];
    
    config.branch = @"development";
    XCTAssertEqualObjects(config.branch, @"development");
}

#pragma mark - Request Cancellation Tests

- (void)testCancelAllRequestsOfStack {
    Stack *stack = [Contentstack stackWithAPIKey:self.config[@"api_key"]
                                     accessToken:self.config[@"delivery_token"]
                                 environmentName:self.config[@"environment"]];
    
    // Should not crash when cancelling requests
    XCTAssertNoThrow([Contentstack cancelAllRequestsOfStack:stack]);
}

@end

