//
//  QueryResultTest.m
//  ContentstackTest
//
//  Created by Test Suite on 05/11/25.
//  Copyright © 2025 Contentstack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Contentstack/Contentstack.h>
#import "CSIOInternalHeaders.h"
#import "ContentstackDefinitions.h"

static NSInteger kRequestTimeOutInSeconds = 30;

@interface QueryResultTest : XCTestCase {
    Stack *csStack;
    Config *config;
}

@property (nonatomic, strong) Stack *stack;

@end

@implementation QueryResultTest

- (void)setUp {
    [super setUp];
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"config" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *configdict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    config = [[Config alloc] init];
    config.host = configdict[@"host"];
    self.stack = [Contentstack stackWithAPIKey:configdict[@"api_key"]
                                  accessToken:configdict[@"delivery_token"]
                              environmentName:configdict[@"environment"]
                                       config:config];
}

- (void)waitForRequest {
    [self waitForExpectationsWithTimeout:kRequestTimeOutInSeconds handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Could not perform operation (Timed out) ~ ERR: %@", error.userInfo);
        }
    }];
}

- (void)tearDown {
    self.stack = nil;
    [super tearDown];
}

#pragma mark - QueryResult Tests

- (void)testQueryResultGetResult {
    XCTestExpectation *expectation = [self expectationWithDescription:@"QueryResult Get Result"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error: %@", error);
        } else {
            XCTAssertNotNil(result, @"Result should not be nil");
            
            // Test getResult method
            NSArray *entries = [result getResult];
            XCTAssertNotNil(entries, @"Entries should not be nil");
            XCTAssertTrue([entries isKindOfClass:[NSArray class]], @"Should be an array");
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testQueryResultTotalCount {
    XCTestExpectation *expectation = [self expectationWithDescription:@"QueryResult Total Count"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    [query includeCount];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error: %@", error);
        } else {
            XCTAssertNotNil(result);
            
            // Test totalCount method
            NSInteger count = [result totalCount];
            XCTAssertGreaterThanOrEqual(count, 0, @"Count should be non-negative");
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testQueryResultSchema {
    XCTestExpectation *expectation = [self expectationWithDescription:@"QueryResult Schema"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error: %@", error);
        } else {
            XCTAssertNotNil(result);
            
            // Test schema method (may be nil if not included)
            NSArray *schema = [result schema];
            if (schema) {
                XCTAssertTrue([schema isKindOfClass:[NSArray class]], @"Schema should be an array");
            }
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testQueryResultContentType {
    XCTestExpectation *expectation = [self expectationWithDescription:@"QueryResult Content Type"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    [query includeContentType];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error: %@", error);
        } else {
            XCTAssertNotNil(result);
            
            // Test content_type method
            NSDictionary *ct = [result content_type];
            if (ct) {
                XCTAssertTrue([ct isKindOfClass:[NSDictionary class]], @"Content type should be a dictionary");
            }
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testQueryResultWithAllIncludes {
    XCTestExpectation *expectation = [self expectationWithDescription:@"QueryResult with All Includes"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    [query includeContentType];
    [query includeCount];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error: %@", error);
        } else {
            XCTAssertNotNil(result);
            
            // Test all methods
            NSArray *entries = [result getResult];
            XCTAssertNotNil(entries);
            
            NSInteger count = [result totalCount];
            XCTAssertGreaterThanOrEqual(count, 0);
            
            NSArray *schema = [result schema];
            // Schema may be nil if not returned
            
            NSDictionary *ct = [result content_type];
            // Content type may be nil if not returned
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testQueryResultWithLimit {
    XCTestExpectation *expectation = [self expectationWithDescription:@"QueryResult with Limit"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    [query limitObjects:@3];
    [query includeCount];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error: %@", error);
        } else {
            XCTAssertNotNil(result);
            
            NSArray *entries = [result getResult];
            XCTAssertNotNil(entries);
            XCTAssertLessThanOrEqual(entries.count, 3, @"Should respect limit");
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

@end

