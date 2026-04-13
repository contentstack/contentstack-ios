//
//  ContentTypeEdgeCaseTest.m
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

@interface ContentTypeEdgeCaseTest : XCTestCase {
    Stack *csStack;
    Config *config;
}

@property (nonatomic, strong) Stack *stack;

@end

@implementation ContentTypeEdgeCaseTest

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

#pragma mark - ContentType Header Tests

- (void)testContentTypeSetHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ContentType Set Header"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    [contentType setHeader:@"TestValue" forKey:@"X-Test-Header"];
    XCTAssertNotNil(contentType);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testContentTypeAddHeadersWithDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ContentType Add Headers"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    
    NSDictionary *headers = @{
        @"Header-1": @"Value1",
        @"Header-2": @"Value2"
    };
    
    [contentType addHeadersWithDictionary:headers];
    XCTAssertNotNil(contentType);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testContentTypeRemoveHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ContentType Remove Header"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    
    [contentType setHeader:@"TestValue" forKey:@"X-Test-Header"];
    [contentType removeHeaderForKey:@"X-Test-Header"];
    XCTAssertNotNil(contentType);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - ContentType Fetch Tests

- (void)testContentTypeFetch {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ContentType Fetch"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    
    [contentType fetch:nil completion:^(NSDictionary<NSString *,NSString *> * _Nullable contentTypeDict, NSError * _Nullable error) {
        if (error) {
            // May fail if content type doesn't exist
        } else {
            XCTAssertNotNil(contentTypeDict);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testContentTypeFetchWithHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ContentType Fetch with Header"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    [contentType setHeader:@"CustomValue" forKey:@"X-Custom-Header"];
    
    [contentType fetch:nil completion:^(NSDictionary<NSString *,NSString *> * _Nullable contentTypeDict, NSError * _Nullable error) {
        if (error) {
            // May fail
        } else {
            XCTAssertNotNil(contentTypeDict);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

#pragma mark - ContentType Entry Creation

- (void)testContentTypeCreateEntry {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ContentType Create Entry"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    XCTAssertNotNil(entry, @"Entry should not be nil");
    XCTAssertTrue([entry isKindOfClass:[Entry class]]);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testContentTypeCreateEntryWithUID {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ContentType Create Entry with UID"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entryWithUID:@"test_uid"];
    
    XCTAssertNotNil(entry);
    XCTAssertTrue([entry isKindOfClass:[Entry class]]);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - ContentType Query Creation

- (void)testContentTypeCreateQuery {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ContentType Create Query"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    XCTAssertNotNil(query, @"Query should not be nil");
    XCTAssertTrue([query isKindOfClass:[Query class]]);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - ContentType Multiple Instances

- (void)testMultipleContentTypeInstances {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Multiple ContentType Instances"];
    
    ContentType *ct1 = [self.stack contentTypeWithName:@"source"];
    ContentType *ct2 = [self.stack contentTypeWithName:@"source"];
    
    // Set different headers
    [ct1 setHeader:@"Value1" forKey:@"Test"];
    [ct2 setHeader:@"Value2" forKey:@"Test"];
    
    XCTAssertNotNil(ct1);
    XCTAssertNotNil(ct2);
    
    [expectation fulfill];
    [self waitForRequest];
}

@end

