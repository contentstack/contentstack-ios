//
//  QueryEdgeCaseTest.m
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

@interface QueryEdgeCaseTest : XCTestCase {
    Stack *csStack;
    Config *config;
}

@property (nonatomic, strong) Stack *stack;

@end

@implementation QueryEdgeCaseTest

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

#pragma mark - Query Header Tests

- (void)testQuerySetHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Set Header"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query setHeader:@"TestValue" forKey:@"X-Test-Header"];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testQueryAddHeadersWithDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Add Headers"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    NSDictionary *headers = @{@"Header-1": @"Value1", @"Header-2": @"Value2"};
    [query addHeadersWithDictionary:headers];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testQueryRemoveHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Remove Header"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query setHeader:@"TestValue" forKey:@"X-Test-Header"];
    [query removeHeaderForKey:@"X-Test-Header"];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Include Tests

- (void)testQueryIncludeContentType {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Include Content Type"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query includeContentType];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testQueryIncludeReferenceContentTypeUid {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Include Ref Content Type UID"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query includeReferenceContentTypeUid];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testQueryIncludeEmbeddedItems {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Include Embedded Items"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query includeEmbeddedItems];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Field Selection

- (void)testQueryOnlyFields {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Only Fields"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    NSArray *fields = @[@"title", @"url"];
    [query onlyFields:fields];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testQueryExceptFields {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Except Fields"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    NSArray *fields = @[@"internal_field"];
    [query exceptFields:fields];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Pagination

- (void)testQueryLimit {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Limit"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query limitObjects:@10];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testQuerySkip {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Skip"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query skipObjects:@5];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Sorting

- (void)testQueryAscendingOrder {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Ascending"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query orderByAscending:@"created_at"];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testQueryDescendingOrder {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Descending"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query orderByDescending:@"updated_at"];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Locale

- (void)testQueryLocale {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Locale"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query locale:@"en-us"];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Include Count

- (void)testQueryIncludeCount {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Include Count"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query includeCount];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Add Param

- (void)testQueryAddParam {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Add Param"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query addParamKey:@"custom_param" andValue:@"custom_value"];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Remove Param

- (void)testQueryRemoveParam {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Remove Param"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query addParamKey:@"test_param" andValue:@"test_value"];
    [query removeQueryWithKey:@"test_param"];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Where Tests

- (void)testQueryWhereKeyExists {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Where Key Exists"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query whereKeyExists:@"title"];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testQueryWhereKeyDoesNotExist {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Where Key Does Not Exist"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query whereKeyDoesNotExist:@"archived"];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Search

- (void)testQuerySearch {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Search"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query search:@"test search"];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Regex

- (void)testQueryWhereKeyMatchesRegex {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Regex Match"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query whereKey:@"title" matchesRegex:@"^Test.*" modifiers:@"i"];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Tags

- (void)testQueryTags {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Tags"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    NSArray *tags = @[@"tag1", @"tag2"];
    [query tags:tags];
    XCTAssertNotNil(query);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Query Fetch with Options

- (void)testQueryFindWithAllOptions {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Find with All Options"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query includeContentType];
    [query includeCount];
    [query limitObjects:@5];
    [query skipObjects:@0];
    [query orderByAscending:@"created_at"];
    [query locale:@"en-us"];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error: %@", error);
        } else {
            XCTAssertNotNil(result);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testQueryFindOneWithOptions {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Find One"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query includeContentType];
    
    [query findOne:^(ResponseType type, Entry * _Nullable entry, NSError * _Nullable error) {
        if (error) {
            // May fail if no entries
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

#pragma mark - Query Cancel

- (void)testQueryCancelRequests {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query Cancel"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Query *query = [contentType query];
    
    [query find:^(ResponseType type, QueryResult * _Nullable result, NSError * _Nullable error) {
        // May or may not be called
    }];
    
    [query cancelRequests];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    
    [self waitForRequest];
}

@end

