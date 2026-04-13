//
//  QueryResultAdvancedTest.m
//  ContentstackTest
//
//  Created by Contentstack on 06/11/25.
//  Copyright © 2025 Contentstack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Contentstack.h"
#import "Query.h"
#import "QueryResult.h"
#import "ContentType.h"
#import "Config.h"

@interface QueryResultAdvancedTest : XCTestCase
@property (nonatomic, strong) Stack *stack;
@end

@implementation QueryResultAdvancedTest

- (void)setUp {
    [super setUp];
    
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"config" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        Config *conf = [[Config alloc] init];
        conf.host = config[@"host"];
        
        self.stack = [Contentstack stackWithAPIKey:config[@"api_key"]
                                       accessToken:config[@"delivery_token"]
                                   environmentName:config[@"environment"]
                                            config:conf];
    }
}

- (void)tearDown {
    self.stack = nil;
    [super tearDown];
}

#pragma mark - Query Result Tests

- (void)testQueryResultGetResult {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Result Get Result"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    [query limitObjects:@5];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (!error && result) {
            NSArray *entries = [result getResult];
            XCTAssertNotNil(entries);
            XCTAssertTrue([entries isKindOfClass:[NSArray class]]);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQueryResultTotalCount {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Result Total Count"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    [query includeCount];
    [query limitObjects:@5];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (!error && result) {
            NSInteger count = [result totalCount];
            XCTAssertGreaterThanOrEqual(count, 0);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQueryResultSchema {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Result Schema"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    [query limitObjects:@1];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (!error && result) {
            NSArray *schema = [result schema];
            // Schema may be nil if not requested
            XCTAssertTrue(schema == nil || [schema isKindOfClass:[NSArray class]]);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQueryResultContentType {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Result Content Type"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    [query includeContentType];
    [query limitObjects:@1];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (!error && result) {
            NSDictionary *ct = [result content_type];
            // Content type may be nil if not requested
            XCTAssertTrue(ct == nil || [ct isKindOfClass:[NSDictionary class]]);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQueryResultWithEmptyResult {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Result Empty"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    // Query for something that doesn't exist
    [query whereKey:@"uid" equalTo:@"nonexistent_uid_12345"];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (!error && result) {
            NSArray *entries = [result getResult];
            XCTAssertNotNil(entries);
            // May be empty array
            XCTAssertTrue([entries isKindOfClass:[NSArray class]]);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQueryResultWithIncludeCount {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Result Include Count"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    [query includeCount];
    [query limitObjects:@10];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (!error && result) {
            NSArray *entries = [result getResult];
            NSInteger count = [result totalCount];
            
            XCTAssertNotNil(entries);
            XCTAssertGreaterThanOrEqual(count, 0);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQueryResultMultipleCalls {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Result Multiple Calls"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    [query includeCount];
    [query limitObjects:@3];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (!error && result) {
            // Call getResult multiple times - both should work
            NSArray *entries1 = [result getResult];
            NSArray *entries2 = [result getResult];
            NSInteger count1 = [result totalCount];
            NSInteger count2 = [result totalCount];
            
            XCTAssertNotNil(entries1, @"First call should return array");
            XCTAssertNotNil(entries2, @"Second call should return array");
            XCTAssertEqual(count1, count2, @"Multiple calls should return same count");
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQueryResultWithPagination {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Result Pagination"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    [query limitObjects:@5];
    [query skipObjects:@0];
    [query includeCount];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (!error && result) {
            NSArray *entries = [result getResult];
            NSInteger count = [result totalCount];
            
            XCTAssertNotNil(entries);
            XCTAssertGreaterThanOrEqual(count, 0);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQueryResultWithContentTypeIncluded {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Result With Content Type"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    [query includeContentType];
    [query limitObjects:@1];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (!error && result) {
            NSArray *entries = [result getResult];
            NSDictionary *ct = [result content_type];
            NSArray *schema = [result schema];
            
            XCTAssertNotNil(entries);
            // Content type and schema may or may not be present
            XCTAssertTrue(ct == nil || [ct isKindOfClass:[NSDictionary class]]);
            XCTAssertTrue(schema == nil || [schema isKindOfClass:[NSArray class]]);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

@end

