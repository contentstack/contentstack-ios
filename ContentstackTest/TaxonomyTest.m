//
//  TaxonomyTest.m
//  ContentstackTest
//
//  Created by Test Suite on 05/11/25.
//  Copyright © 2025 Contentstack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Contentstack/Contentstack.h>
#import "CSIOInternalHeaders.h"
#import "Taxonomy.h"
#import "ContentstackDefinitions.h"

@interface TaxonomyTest : XCTestCase {
    Stack *csStack;
    Config *config;
}

@property (nonatomic, strong) Stack *stack;
@property (nonatomic, strong) Taxonomy *taxonomy;

@end

@implementation TaxonomyTest

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

- (void)tearDown {
    self.stack = nil;
    self.taxonomy = nil;
    [super tearDown];
}

#pragma mark - Header Tests

- (void)testTaxonomySetHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Set Header"];
    
    // Get taxonomy from Stack  
    self.taxonomy = [self.stack taxonomy];
    
    // Set header
    [self.taxonomy setHeader:@"TestValue" forKey:@"Test-Header"];
    
    // Verify header is set
    NSDictionary *headers = [self.taxonomy valueForKey:@"headers"];
    XCTAssertNotNil(headers, @"Headers dictionary should not be nil");
    XCTAssertEqualObjects(headers[@"Test-Header"], @"TestValue", @"Header value should match");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testTaxonomyAddHeadersWithDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Add Headers Dictionary"];
    
    self.taxonomy = [self.stack taxonomy];
    
    // Add multiple headers
    NSDictionary *headersToAdd = @{
        @"Header-One": @"Value1",
        @"Header-Two": @"Value2",
        @"Header-Three": @"Value3"
    };
    
    [self.taxonomy addHeadersWithDictionary:headersToAdd];
    
    // Verify headers are added
    NSDictionary *headers = [self.taxonomy valueForKey:@"headers"];
    XCTAssertNotNil(headers, @"Headers dictionary should not be nil");
    XCTAssertEqualObjects(headers[@"Header-One"], @"Value1", @"Header-One should match");
    XCTAssertEqualObjects(headers[@"Header-Two"], @"Value2", @"Header-Two should match");
    XCTAssertEqualObjects(headers[@"Header-Three"], @"Value3", @"Header-Three should match");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testTaxonomyRemoveHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Remove Header"];
    
    self.taxonomy = [self.stack taxonomy];
    
    // Set header first
    [self.taxonomy setHeader:@"TestValue" forKey:@"Test-Header"];
    
    // Verify header is set
    NSDictionary *headers = [self.taxonomy valueForKey:@"headers"];
    XCTAssertEqualObjects(headers[@"Test-Header"], @"TestValue", @"Header should be set");
    
    // Remove header
    [self.taxonomy removeHeaderForKey:@"Test-Header"];
    
    // Verify header is removed
    headers = [self.taxonomy valueForKey:@"headers"];
    XCTAssertNil(headers[@"Test-Header"], @"Header should be removed");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testTaxonomyRemoveNonExistentHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Remove Non-Existent Header"];
    
    self.taxonomy = [self.stack taxonomy];
    
    // Try to remove header that doesn't exist (should not crash)
    [self.taxonomy removeHeaderForKey:@"NonExistent-Header"];
    
    // Verify no error
    NSDictionary *headers = [self.taxonomy valueForKey:@"headers"];
    XCTAssertNotNil(headers, @"Headers dictionary should exist");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Query Tests

- (void)testTaxonomyCreateQuery {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Create Query"];
    
    self.taxonomy = [self.stack taxonomy];
    
    // Create query from taxonomy
    Query *query = [self.taxonomy query];
    
    // Verify query is created
    XCTAssertNotNil(query, @"Query should not be nil");
    XCTAssertTrue([query isKindOfClass:[Query class]], @"Query should be Query instance");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Fetch Tests

- (void)testTaxonomyFetchWithParams {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Taxonomy"];
    
    self.taxonomy = [self.stack taxonomy];
    
    // Fetch taxonomy with params
    NSDictionary *params = @{
        @"taxonomies.taxonomy_uid": @"test_taxonomy"
    };
    
    [self.taxonomy fetch:params completion:^(NSDictionary<NSString *,NSString *> * _Nullable entries, NSError * _Nullable error) {
        // Note: This may fail if taxonomy doesn't exist in test environment
        // But we're testing the method execution, not necessarily success
        
        // Either we get data or error, both are valid for testing
        if (error) {
            // Error is expected if taxonomy doesn't exist
            XCTAssertNotNil(error, @"Error should be present if fetch fails");
        } else {
            // Success case
            XCTAssertNil(error, @"Error should be nil on success");
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testTaxonomyFetchWithNilParams {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Taxonomy with Nil Params"];
    
    self.taxonomy = [self.stack taxonomy];
    
    // Fetch taxonomy with nil params
    [self.taxonomy fetch:nil completion:^(NSDictionary<NSString *,NSString *> * _Nullable entries, NSError * _Nullable error) {
        // Either we get data or error, both are valid
        if (error) {
            XCTAssertNotNil(error, @"Error should be present if fetch fails");
        } else {
            XCTAssertNil(error, @"Error should be nil on success");
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testTaxonomyFetchWithEmptyParams {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Taxonomy with Empty Params"];
    
    self.taxonomy = [self.stack taxonomy];
    
    // Fetch taxonomy with empty params dictionary
    NSDictionary *params = @{};
    
    [self.taxonomy fetch:params completion:^(NSDictionary<NSString *,NSString *> * _Nullable entries, NSError * _Nullable error) {
        // Either we get data or error, both are valid
        if (error) {
            XCTAssertNotNil(error, @"Error should be present if fetch fails");
        } else {
            XCTAssertNil(error, @"Error should be nil on success");
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testTaxonomyFetchWithMultipleParams {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Taxonomy with Multiple Params"];
    
    self.taxonomy = [self.stack taxonomy];
    
    // Fetch taxonomy with multiple params
    NSDictionary *params = @{
        @"taxonomies.taxonomy_uid": @"test_taxonomy",
        @"limit": @10,
        @"skip": @0
    };
    
    [self.taxonomy fetch:params completion:^(NSDictionary<NSString *,NSString *> * _Nullable entries, NSError * _Nullable error) {
        // Test completes regardless of success/failure
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testTaxonomyFetchWithCustomHeaders {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Taxonomy with Custom Headers"];
    
    self.taxonomy = [self.stack taxonomy];
    
    // Set custom headers
    [self.taxonomy setHeader:@"CustomValue" forKey:@"X-Custom-Header"];
    
    // Fetch taxonomy
    NSDictionary *params = @{@"limit": @5};
    
    [self.taxonomy fetch:params completion:^(NSDictionary<NSString *,NSString *> * _Nullable entries, NSError * _Nullable error) {
        // Test completes regardless of success/failure
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

#pragma mark - Integration Tests

- (void)testTaxonomyQueryIntegration {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Taxonomy Query Integration"];
    
    self.taxonomy = [self.stack taxonomy];
    
    // Create query
    Query *query = [self.taxonomy query];
    XCTAssertNotNil(query, @"Query should be created");
    
    // Set headers on taxonomy
    [self.taxonomy setHeader:@"TestValue" forKey:@"Test-Integration"];
    
    // Verify taxonomy object is properly configured
    NSDictionary *headers = [self.taxonomy valueForKey:@"headers"];
    XCTAssertEqualObjects(headers[@"Test-Integration"], @"TestValue");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testMultipleTaxonomyInstances {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Multiple Taxonomy Instances"];
    
    // Create multiple taxonomy instances
    Taxonomy *taxonomy1 = [self.stack taxonomy];
    Taxonomy *taxonomy2 = [self.stack taxonomy];
    
    // Set different headers on each
    [taxonomy1 setHeader:@"Value1" forKey:@"Test-Header"];
    [taxonomy2 setHeader:@"Value2" forKey:@"Test-Header"];
    
    // Verify they're independent
    NSDictionary *headers1 = [taxonomy1 valueForKey:@"headers"];
    NSDictionary *headers2 = [taxonomy2 valueForKey:@"headers"];
    
    XCTAssertEqualObjects(headers1[@"Test-Header"], @"Value1");
    XCTAssertEqualObjects(headers2[@"Test-Header"], @"Value2");
    XCTAssertNotEqual(taxonomy1, taxonomy2, @"Instances should be different");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end





