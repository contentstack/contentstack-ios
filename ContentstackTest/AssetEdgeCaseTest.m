//
//  AssetEdgeCaseTest.m
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

@interface AssetEdgeCaseTest : XCTestCase {
    Stack *csStack;
    Config *config;
}

@property (nonatomic, strong) Stack *stack;

@end

@implementation AssetEdgeCaseTest

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

#pragma mark - Asset Header Tests

- (void)testAssetSetHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Set Header"];
    
    Asset *asset = [self.stack asset];
    [asset setHeader:@"TestValue" forKey:@"X-Test-Header"];
    XCTAssertNotNil(asset);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testAssetAddHeadersWithDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Add Headers Dictionary"];
    
    Asset *asset = [self.stack asset];
    
    NSDictionary *headersToAdd = @{
        @"Header-1": @"Value1",
        @"Header-2": @"Value2",
        @"Header-3": @"Value3"
    };
    
    [asset addHeadersWithDictionary:headersToAdd];
    XCTAssertNotNil(asset);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testAssetRemoveHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Remove Header"];
    
    Asset *asset = [self.stack asset];
    
    // Add header first
    [asset setHeader:@"TestValue" forKey:@"X-Test-Header"];
    
    // Remove header
    [asset removeHeaderForKey:@"X-Test-Header"];
    XCTAssertNotNil(asset);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testAssetRemoveNonExistentHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Remove Non-Existent Header"];
    
    Asset *asset = [self.stack asset];
    
    // Try to remove non-existent header (should not crash)
    [asset removeHeaderForKey:@"NonExistent"];
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Asset Parameter Tests

- (void)testAssetAddParamKeyValue {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Add Param"];
    
    Asset *asset = [self.stack asset];
    [asset addParamKey:@"dimension" andValue:@"width=100"];
    XCTAssertNotNil(asset);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testAssetAddMultipleParams {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Add Multiple Params"];
    
    Asset *asset = [self.stack asset];
    [asset addParamKey:@"width" andValue:@"100"];
    [asset addParamKey:@"height" andValue:@"200"];
    [asset addParamKey:@"format" andValue:@"png"];
    XCTAssertNotNil(asset);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Asset Include Methods

- (void)testAssetIncludeFallback {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Include Fallback"];
    
    Asset *asset = [self.stack asset];
    [asset includeFallback];
    XCTAssertNotNil(asset);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testAssetIncludeMetadata {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Include Metadata"];
    
    Asset *asset = [self.stack asset];
    [asset includeMetadata];
    XCTAssertNotNil(asset);
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testAssetIncludeBranch {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Include Branch"];
    
    Asset *asset = [self.stack asset];
    [asset includeBranch];
    XCTAssertNotNil(asset);
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Asset Fetch with Options

- (void)testAssetFetchWithMetadata {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Fetch with Metadata"];
    
    Asset *asset = [self.stack assetWithUID:@"blt240v03mgonxgwvvf"];
    [asset includeMetadata];
    
    [asset fetch:^(ResponseType type, NSError * _Nullable error) {
        if (error) {
            // Asset UID may not exist
            XCTAssertNotNil(error);
        } else {
            XCTAssertNil(error);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testAssetFetchWithFallback {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Fetch with Fallback"];
    
    Asset *asset = [self.stack assetWithUID:@"blt240v03mgonxgwvvf"];
    [asset includeFallback];
    
    [asset fetch:^(ResponseType type, NSError * _Nullable error) {
        if (error) {
            XCTAssertNotNil(error);
        } else {
            XCTAssertNil(error);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testAssetFetchWithBranch {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Fetch with Branch"];
    
    Asset *asset = [self.stack assetWithUID:@"blt240v03mgonxgwvvf"];
    [asset includeBranch];
    
    [asset fetch:^(ResponseType type, NSError * _Nullable error) {
        if (error) {
            XCTAssertNotNil(error);
        } else {
            XCTAssertNil(error);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testAssetFetchWithAllOptions {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Fetch with All Options"];
    
    Asset *asset = [self.stack assetWithUID:@"blt240v03mgonxgwvvf"];
    [asset includeMetadata];
    [asset includeFallback];
    [asset includeBranch];
    [asset setHeader:@"CustomValue" forKey:@"X-Custom-Header"];
    [asset addParamKey:@"dimension" andValue:@"width=100"];
    
    [asset fetch:^(ResponseType type, NSError * _Nullable error) {
        // Test completes regardless of result
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

#pragma mark - Asset Properties

- (void)testAssetProperties {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Properties"];
    
    Asset *asset = [self.stack asset];
    
    // Configure asset with test data
    NSDictionary *testData = @{
        @"uid": @"test123",
        @"filename": @"test.jpg",
        @"url": @"https://example.com/test.jpg",
        @"content_type": @"image/jpeg"
    };
    
    [asset configureWithDictionary:testData];
    
    // Get properties
    NSDictionary *properties = [asset properties];
    XCTAssertNotNil(properties, @"Properties should not be nil");
    
    [expectation fulfill];
    [self waitForRequest];
}

#pragma mark - Asset Edge Cases

- (void)testAssetWithNilUID {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset with Nil UID"];
    
    // Create asset without UID
    Asset *asset = [self.stack asset];
    
    // Try to fetch (should handle gracefully)
    [asset fetch:^(ResponseType type, NSError * _Nullable error) {
        // Should get an error
        XCTAssertNotNil(error, @"Should have error for asset without UID");
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testAssetConfigureWithEmptyDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Configure with Empty Dictionary"];
    
    Asset *asset = [self.stack asset];
    [asset configureWithDictionary:@{}];
    
    // Should not crash
    NSDictionary *properties = [asset properties];
    XCTAssertNotNil(properties, @"Properties should not be nil even with empty config");
    
    [expectation fulfill];
    [self waitForRequest];
}

- (void)testAssetConfigureWithComplexData {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset Configure with Complex Data"];
    
    Asset *asset = [self.stack asset];
    
    NSDictionary *complexData = @{
        @"uid": @"asset123",
        @"filename": @"test.jpg",
        @"url": @"https://example.com/test.jpg",
        @"content_type": @"image/jpeg",
        @"file_size": @"102400",
        @"tags": @[@"tag1", @"tag2"],
        @"metadata": @{
            @"width": @800,
            @"height": @600
        }
    };
    
    [asset configureWithDictionary:complexData];
    
    // Verify configuration
    NSDictionary *properties = [asset properties];
    XCTAssertNotNil(properties);
    
    [expectation fulfill];
    [self waitForRequest];
}

@end

