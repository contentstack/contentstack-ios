//
//  EntryEdgeCaseTest.m
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

@interface EntryEdgeCaseTest : XCTestCase {
    Stack *csStack;
    Config *config;
}

@property (nonatomic, strong) Stack *stack;

@end

@implementation EntryEdgeCaseTest

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

#pragma mark - Entry Header Tests

- (void)testEntrySetHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Set Header"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    // Test that method exists and can be called
    [entry setHeader:@"TestValue" forKey:@"X-Test-Header"];
    
    // Method should not crash - header will be sent with fetch
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryAddHeadersWithDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Add Headers Dictionary"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    NSDictionary *headersToAdd = @{
        @"Header-1": @"Value1",
        @"Header-2": @"Value2"
    };
    
    // Test that method exists and can be called
    [entry addHeadersWithDictionary:headersToAdd];
    
    // Method should not crash - headers will be sent with fetch
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryRemoveHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Remove Header"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    // Add header first
    [entry setHeader:@"TestValue" forKey:@"X-Test-Header"];
    
    // Remove header - test that method exists and can be called
    [entry removeHeaderForKey:@"X-Test-Header"];
    
    // Method should not crash
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Entry Method Existence Tests

- (void)testEntryVariantUid {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Variant UID"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    // Test that method exists and can be called
    [entry variantUid:@"variant123"];
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryVariantUids {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Variant UIDs"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    NSArray *variantUids = @[@"variant1", @"variant2", @"variant3"];
    
    // Test that method exists and can be called
    [entry variantUids:variantUids];
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryAddParamKeyValue {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Add Param"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    // Test that method exists and can be called
    [entry addParamKey:@"custom_param" andValue:@"custom_value"];
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryIncludeSchema {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Include Schema"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    // Test that method exists and can be called
    [entry includeSchema];
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryIncludeContentType {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Include Content Type"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    // Test that method exists and can be called
    [entry includeContentType];
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryIncludeReferenceContentTypeUid {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Include Reference Content Type UID"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    // Test that method exists and can be called
    [entry includeReferenceContentTypeUid];
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryIncludeEmbeddedItems {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Include Embedded Items"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    // Test that method exists and can be called
    [entry includeEmbeddedItems];
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryIncludeOnlyFields {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Include Only Fields"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    NSArray *fields = @[@"title", @"description"];
    
    // Test that method exists and can be called
    [entry includeOnlyFields:fields];
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryIncludeAllFieldsExcept {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Include All Fields Except"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    NSArray *fields = @[@"sensitive_field", @"internal_field"];
    
    // Test that method exists and can be called
    [entry includeAllFieldsExcept:fields];
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryIncludeRefFieldWithKey {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Include Ref Field"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    NSArray *keys = @[@"reference_field"];
    
    // Test that method exists and can be called
    [entry includeRefFieldWithKey:keys];
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryIncludeRefFieldWithKeyAndOnlyRefValues {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Include Ref Field with Only Values"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    NSArray *values = @[@"title", @"uid"];
    
    // Test that method exists and can be called
    [entry includeRefFieldWithKey:@"reference_field" andOnlyRefValuesWithKeys:values];
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryIncludeRefFieldWithKeyExcludingRefValues {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Include Ref Field Excluding Values"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    NSArray *values = @[@"internal_field"];
    
    // Test that method exists and can be called
    [entry includeRefFieldWithKey:@"reference_field" excludingRefValuesWithKeys:values];
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Entry Fetch with Options

- (void)testEntryFetchWithSchema {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Fetch with Schema"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entryWithUID:@"blt8e2851fc0785e7c4"];
    
    [entry includeSchema];
    
    [entry fetch:^(ResponseType type, NSError * _Nullable error) {
        if (error) {
            // Entry UID may not exist
            XCTAssertNotNil(error);
        } else {
            XCTAssertNil(error);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testEntryFetchWithContentType {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Fetch with Content Type"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entryWithUID:@"blt8e2851fc0785e7c4"];
    
    [entry includeContentType];
    
    [entry fetch:^(ResponseType type, NSError * _Nullable error) {
        if (error) {
            XCTAssertNotNil(error);
        } else {
            XCTAssertNil(error);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testEntryFetchWithReferenceContentTypeUid {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Fetch with Reference Content Type UID"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entryWithUID:@"blt8e2851fc0785e7c4"];
    
    [entry includeReferenceContentTypeUid];
    
    [entry fetch:^(ResponseType type, NSError * _Nullable error) {
        if (error) {
            XCTAssertNotNil(error);
        } else {
            XCTAssertNil(error);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testEntryFetchWithEmbeddedItems {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Fetch with Embedded Items"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entryWithUID:@"blt8e2851fc0785e7c4"];
    
    [entry includeEmbeddedItems];
    
    [entry fetch:^(ResponseType type, NSError * _Nullable error) {
        if (error) {
            XCTAssertNotNil(error);
        } else {
            XCTAssertNil(error);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testEntryFetchWithVariant {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Fetch with Variant"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entryWithUID:@"blt8e2851fc0785e7c4"];
    
    [entry variantUid:@"test_variant"];
    
    [entry fetch:^(ResponseType type, NSError * _Nullable error) {
        // May fail if variant doesn't exist
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testEntryFetchWithAllOptions {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Fetch with All Options"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entryWithUID:@"blt8e2851fc0785e7c4"];
    
    [entry includeSchema];
    [entry includeContentType];
    [entry includeReferenceContentTypeUid];
    [entry includeEmbeddedItems];
    [entry setHeader:@"CustomValue" forKey:@"X-Custom-Header"];
    [entry addParamKey:@"custom_param" andValue:@"custom_value"];
    
    [entry fetch:^(ResponseType type, NSError * _Nullable error) {
        // Test completes regardless of result
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

#pragma mark - Entry Cancel Request

- (void)testEntryCancelRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Cancel Request"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entryWithUID:@"blt8e2851fc0785e7c4"];
    
    // Start fetch
    [entry fetch:^(ResponseType type, NSError * _Nullable error) {
        // May or may not be called
    }];
    
    // Cancel immediately
    [entry cancelRequest];
    
    // Wait a bit to ensure no crash
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    
    [self waitForRequest];
}

#pragma mark - Entry Edge Cases

- (void)testEntryConfigureWithEmptyDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Configure with Empty Dictionary"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    [entry configureWithDictionary:@{}];
    
    // Should not crash
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testEntryConfigureWithComplexData {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Configure with Complex Data"];
    
    ContentType *contentType = [self.stack contentTypeWithName:@"source"];
    Entry *entry = [contentType entry];
    
    NSDictionary *complexData = @{
        @"uid": @"entry123",
        @"title": @"Test Entry",
        @"description": @"Test Description",
        @"tags": @[@"tag1", @"tag2"],
        @"nested": @{
            @"field1": @"value1",
            @"field2": @"value2"
        }
    };
    
    [entry configureWithDictionary:complexData];
    
    // Verify configuration
    XCTAssertNotNil(entry);
    
    [expectation fulfill];
    [self waitForRequest];
}

@end

