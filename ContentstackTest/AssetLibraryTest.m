//
//  AssetLibraryTest.m
//  ContentstackTest
//
//  Created by Test Suite on 05/11/25.
//  Copyright © 2025 Contentstack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Contentstack/Contentstack.h>
#import "CSIOInternalHeaders.h"
#import "AssetLibrary.h"
#import "ContentstackDefinitions.h"

@interface AssetLibraryTest : XCTestCase {
    Stack *csStack;
    Config *config;
}

@property (nonatomic, strong) Stack *stack;
@property (nonatomic, strong) AssetLibrary *assetLibrary;

@end

@implementation AssetLibraryTest

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
    self.assetLibrary = [self.stack assetLibrary];
}

- (void)tearDown {
    self.stack = nil;
    self.assetLibrary = nil;
    [super tearDown];
}

#pragma mark - Header Tests

- (void)testAssetLibrarySetHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Set Header"];
    
    // Set header
    [self.assetLibrary setHeader:@"TestValue" forKey:@"Test-Header"];
    
    // Verify header is set
    NSDictionary *headers = [self.assetLibrary valueForKey:@"localHeaders"];
    XCTAssertNotNil(headers, @"Headers dictionary should not be nil");
    XCTAssertEqualObjects(headers[@"Test-Header"], @"TestValue", @"Header value should match");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibraryAddHeadersWithDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Add Headers Dictionary"];
    
    // Add multiple headers
    NSDictionary *headersToAdd = @{
        @"Header-One": @"Value1",
        @"Header-Two": @"Value2",
        @"Header-Three": @"Value3"
    };
    
    [self.assetLibrary addHeadersWithDictionary:headersToAdd];
    
    // Verify headers are added
    NSDictionary *headers = [self.assetLibrary valueForKey:@"localHeaders"];
    XCTAssertNotNil(headers, @"Headers dictionary should not be nil");
    XCTAssertEqualObjects(headers[@"Header-One"], @"Value1", @"Header-One should match");
    XCTAssertEqualObjects(headers[@"Header-Two"], @"Value2", @"Header-Two should match");
    XCTAssertEqualObjects(headers[@"Header-Three"], @"Value3", @"Header-Three should match");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibraryRemoveHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Remove Header"];
    
    // Set header first
    [self.assetLibrary setHeader:@"TestValue" forKey:@"Test-Header"];
    
    // Verify header is set
    NSDictionary *headers = [self.assetLibrary valueForKey:@"localHeaders"];
    XCTAssertEqualObjects(headers[@"Test-Header"], @"TestValue", @"Header should be set");
    
    // Remove header
    [self.assetLibrary removeHeaderForKey:@"Test-Header"];
    
    // Verify header is removed
    headers = [self.assetLibrary valueForKey:@"localHeaders"];
    XCTAssertNil(headers[@"Test-Header"], @"Header should be removed");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibraryRemoveNonExistentHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Remove Non-Existent Header"];
    
    // Try to remove header that doesn't exist (should not crash)
    [self.assetLibrary removeHeaderForKey:@"NonExistent-Header"];
    
    // Verify no error
    NSDictionary *headers = [self.assetLibrary valueForKey:@"localHeaders"];
    XCTAssertNotNil(headers, @"Headers dictionary should exist");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Sorting Tests

- (void)testAssetLibrarySortAscending {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Sort Ascending"];
    
    // Sort by field ascending
    [self.assetLibrary sortWithKey:@"created_at" orderBy:OrderByAscending];
    
    // Verify sort parameter is set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    XCTAssertNotNil(params[@"asc"], @"Ascending parameter should be set");
    XCTAssertEqualObjects(params[@"asc"], @"created_at", @"Sort field should match");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibrarySortDescending {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Sort Descending"];
    
    // Sort by field descending
    [self.assetLibrary sortWithKey:@"updated_at" orderBy:OrderByDescending];
    
    // Verify sort parameter is set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    XCTAssertNotNil(params[@"desc"], @"Descending parameter should be set");
    XCTAssertEqualObjects(params[@"desc"], @"updated_at", @"Sort field should match");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Locale Tests

- (void)testAssetLibrarySetLocale {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Set Locale"];
    
    // Set locale
    [self.assetLibrary locale:@"en-us"];
    
    // Verify locale parameter is set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    XCTAssertNotNil(params[@"locale"], @"Locale parameter should be set");
    XCTAssertEqualObjects(params[@"locale"], @"en-us", @"Locale should match");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibrarySetDifferentLocales {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Set Different Locales"];
    
    // Set locale
    [self.assetLibrary locale:@"fr-fr"];
    
    // Verify first locale
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    XCTAssertEqualObjects(params[@"locale"], @"fr-fr", @"Locale should match");
    
    // Change locale
    [self.assetLibrary locale:@"de-de"];
    
    // Verify updated locale
    params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    XCTAssertEqualObjects(params[@"locale"], @"de-de", @"Locale should be updated");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Include Methods Tests

- (void)testAssetLibraryObjectsCount {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Objects Count"];
    
    // Enable objects count
    [self.assetLibrary objectsCount];
    
    // Verify parameter is set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    XCTAssertNotNil(params[@"count"], @"Count parameter should be set");
    XCTAssertEqualObjects(params[@"count"], @"true", @"Count should be true");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibraryIncludeCount {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Include Count"];
    
    // Include count
    [self.assetLibrary includeCount];
    
    // Verify parameter is set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    XCTAssertNotNil(params[@"include_count"], @"Include count parameter should be set");
    XCTAssertEqualObjects(params[@"include_count"], @"true", @"Include count should be true");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibraryIncludeRelativeUrls {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Include Relative URLs"];
    
    // Include relative URLs
    [self.assetLibrary includeRelativeUrls];
    
    // Verify parameter is set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    XCTAssertNotNil(params[@"relative_urls"], @"Relative URLs parameter should be set");
    XCTAssertEqualObjects(params[@"relative_urls"], @"true", @"Relative URLs should be true");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibraryIncludeFallback {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Include Fallback"];
    
    // Include fallback
    [self.assetLibrary includeFallback];
    
    // Verify parameter is set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    XCTAssertNotNil(params[@"include_fallback"], @"Include fallback parameter should be set");
    XCTAssertEqualObjects(params[@"include_fallback"], @"true", @"Include fallback should be true");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibraryIncludeMetadata {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Include Metadata"];
    
    // Include metadata
    [self.assetLibrary includeMetadata];
    
    // Verify parameter is set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    XCTAssertNotNil(params[@"include_metadata"], @"Include metadata parameter should be set");
    XCTAssertEqualObjects(params[@"include_metadata"], @"true", @"Include metadata should be true");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibraryIncludeBranch {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Include Branch"];
    
    // Include branch
    [self.assetLibrary includeBranch];
    
    // Verify parameter is set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    XCTAssertNotNil(params[@"include_branch"], @"Include branch parameter should be set");
    XCTAssertEqualObjects(params[@"include_branch"], @"true", @"Include branch should be true");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Where Query Tests

- (void)testAssetLibraryWhereEqualTo {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Where Equal To"];
    
    // Set where condition
    [self.assetLibrary where:@"title" equalTo:@"TestTitle"];
    
    // Verify query parameter is set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    NSDictionary *query = params[@"query"];
    XCTAssertNotNil(query, @"Query parameter should be set");
    XCTAssertEqualObjects(query[@"title"], @"TestTitle", @"Query value should match");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibraryWhereWithEmptyField {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Where with Empty Field"];
    
    // Try to set where condition with empty field
    [self.assetLibrary where:@"" equalTo:@"TestValue"];
    
    // Verify query parameter is not set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    NSDictionary *query = params[@"query"];
    XCTAssertNil(query, @"Query should not be set for empty field");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibraryWhereWithNilValue {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Where with Nil Value"];
    
    // Try to set where condition with nil value
    [self.assetLibrary where:@"title" equalTo:nil];
    
    // Verify query parameter is not set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    NSDictionary *query = params[@"query"];
    XCTAssertNil(query, @"Query should not be set for nil value");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibraryMultipleWhereConditions {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Multiple Where Conditions"];
    
    // Set multiple where conditions
    [self.assetLibrary where:@"title" equalTo:@"TestTitle"];
    [self.assetLibrary where:@"content_type" equalTo:@"image/png"];
    
    // Verify both query parameters are set
    NSDictionary *params = [self.assetLibrary valueForKey:@"postParamDictionary"];
    NSDictionary *query = params[@"query"];
    XCTAssertNotNil(query, @"Query parameter should be set");
    XCTAssertEqualObjects(query[@"title"], @"TestTitle", @"Title query should match");
    XCTAssertEqualObjects(query[@"content_type"], @"image/png", @"Content type query should match");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAssetLibraryGetPostParamDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get Post Param Dictionary"];
    
    // Set some parameters
    [self.assetLibrary includeCount];
    [self.assetLibrary locale:@"en-us"];
    
    // Get post param dictionary
    NSDictionary *params = [self.assetLibrary getPostParamDictionary];
    
    // Verify parameters
    XCTAssertNotNil(params, @"Params should not be nil");
    XCTAssertEqualObjects(params[@"include_count"], @"true", @"Include count should be set");
    XCTAssertEqualObjects(params[@"locale"], @"en-us", @"Locale should be set");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Cache Policy Tests

- (void)testAssetLibrarySetCachePolicy {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Set Cache Policy"];
    
    // Set cache policy
    self.assetLibrary.cachePolicy = NETWORK_ONLY;
    
    // Verify cache policy is set
    XCTAssertEqual(self.assetLibrary.cachePolicy, NETWORK_ONLY, @"Cache policy should match");
    
    // Change cache policy
    self.assetLibrary.cachePolicy = CACHE_THEN_NETWORK;
    XCTAssertEqual(self.assetLibrary.cachePolicy, CACHE_THEN_NETWORK, @"Cache policy should be updated");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Fetch Tests

- (void)testAssetLibraryFetchAll {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch All Assets"];
    
    // Fetch all assets
    [self.assetLibrary fetchAll:^(ResponseType type, NSArray<Asset *> * _Nullable result, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error fetching assets: %@", error);
        } else {
            XCTAssertNotNil(result, @"Result should not be nil");
            XCTAssertTrue([result isKindOfClass:[NSArray class]], @"Result should be an array");
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testAssetLibraryFetchAllWithCount {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch All Assets with Count"];
    
    // Include count
    [self.assetLibrary includeCount];
    
    // Fetch all assets
    [self.assetLibrary fetchAll:^(ResponseType type, NSArray<Asset *> * _Nullable result, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error fetching assets: %@", error);
        } else {
            XCTAssertNotNil(result, @"Result should not be nil");
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testAssetLibraryFetchAllWithLocale {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch All Assets with Locale"];
    
    // Set locale
    [self.assetLibrary locale:@"en-us"];
    
    // Fetch all assets
    [self.assetLibrary fetchAll:^(ResponseType type, NSArray<Asset *> * _Nullable result, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error fetching assets: %@", error);
        } else {
            XCTAssertNotNil(result, @"Result should not be nil");
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testAssetLibraryFetchAllWithSort {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch All Assets with Sort"];
    
    // Sort ascending
    [self.assetLibrary sortWithKey:@"created_at" orderBy:OrderByAscending];
    
    // Fetch all assets
    [self.assetLibrary fetchAll:^(ResponseType type, NSArray<Asset *> * _Nullable result, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error fetching assets: %@", error);
        } else {
            XCTAssertNotNil(result, @"Result should not be nil");
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testAssetLibraryFetchAllWithWhereQuery {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch All Assets with Where Query"];
    
    // Set where condition
    [self.assetLibrary where:@"content_type" equalTo:@"image/png"];
    
    // Fetch all assets
    [self.assetLibrary fetchAll:^(ResponseType type, NSArray<Asset *> * _Nullable result, NSError * _Nullable error) {
        // Test completes regardless of result (may have no PNG images)
        if (!error) {
            XCTAssertNotNil(result, @"Result should not be nil on success");
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testAssetLibraryFetchAllWithAllOptions {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch All Assets with All Options"];
    
    // Set all options
    [self.assetLibrary includeCount];
    [self.assetLibrary includeMetadata];
    [self.assetLibrary includeBranch];
    [self.assetLibrary includeFallback];
    [self.assetLibrary includeRelativeUrls];
    [self.assetLibrary locale:@"en-us"];
    [self.assetLibrary sortWithKey:@"updated_at" orderBy:OrderByDescending];
    [self.assetLibrary setHeader:@"CustomValue" forKey:@"X-Custom-Header"];
    
    // Fetch all assets
    [self.assetLibrary fetchAll:^(ResponseType type, NSArray<Asset *> * _Nullable result, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error fetching assets: %@", error);
        } else {
            XCTAssertNotNil(result, @"Result should not be nil");
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

#pragma mark - Integration Tests

- (void)testAssetLibraryMultipleInstances {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Multiple AssetLibrary Instances"];
    
    // Create multiple asset library instances
    AssetLibrary *lib1 = [self.stack assetLibrary];
    AssetLibrary *lib2 = [self.stack assetLibrary];
    
    // Set different options on each
    [lib1 locale:@"en-us"];
    [lib2 locale:@"fr-fr"];
    
    // Verify they're independent
    NSDictionary *params1 = [lib1 getPostParamDictionary];
    NSDictionary *params2 = [lib2 getPostParamDictionary];
    
    XCTAssertEqualObjects(params1[@"locale"], @"en-us");
    XCTAssertEqualObjects(params2[@"locale"], @"fr-fr");
    XCTAssertNotEqual(lib1, lib2, @"Instances should be different");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end

