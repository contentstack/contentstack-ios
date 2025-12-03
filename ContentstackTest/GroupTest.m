//
//  GroupTest.m
//  ContentstackTest
//
//  Created by Test Suite on 05/11/25.
//  Copyright © 2025 Contentstack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Contentstack/Contentstack.h>
#import "CSIOInternalHeaders.h"
#import "Group.h"
#import "ContentstackDefinitions.h"

@interface GroupTest : XCTestCase {
    Stack *csStack;
    Config *config;
}

@property (nonatomic, strong) Stack *stack;
@property (nonatomic, strong) Group *group;

@end

@implementation GroupTest

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
    self.group = nil;
    [super tearDown];
}

#pragma mark - Initialization Tests

- (void)testGroupInitWithStack {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Init with Stack"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    
    XCTAssertNotNil(self.group, @"Group should not be nil");
    XCTAssertEqual([self.group valueForKey:@"stack"], self.stack, @"Stack should be set");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupInitWithStackAndField {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Init with Stack and Field"];
    
    self.group = [[Group alloc] initWithStack:self.stack andField:@"testField"];
    
    XCTAssertNotNil(self.group, @"Group should not be nil");
    XCTAssertEqualObjects([self.group valueForKey:@"fieldName"], @"testField", @"Field name should be set");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Configure Tests

- (void)testGroupConfigureWithDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Configure with Dictionary"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    
    NSDictionary *testData = @{
        @"title": @"Test Title",
        @"description": @"Test Description",
        @"count": @42
    };
    
    [self.group configureWithDictionary:testData];
    
    // Verify data is configured
    XCTAssertEqualObjects([self.group objectForKey:@"title"], @"Test Title", @"Title should match");
    XCTAssertEqualObjects([self.group objectForKey:@"description"], @"Test Description", @"Description should match");
    XCTAssertEqualObjects([self.group objectForKey:@"count"], @42, @"Count should match");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupReconfigureWithDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Reconfigure with Dictionary"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    
    // Configure first time
    NSDictionary *firstData = @{@"key1": @"value1"};
    [self.group configureWithDictionary:firstData];
    XCTAssertEqualObjects([self.group objectForKey:@"key1"], @"value1");
    
    // Configure second time (should replace)
    NSDictionary *secondData = @{@"key2": @"value2"};
    [self.group configureWithDictionary:secondData];
    
    // Old key should be gone
    XCTAssertNil([self.group objectForKey:@"key1"], @"Old key should be removed");
    XCTAssertEqualObjects([self.group objectForKey:@"key2"], @"value2", @"New key should be set");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Object Access Tests

- (void)testGroupObjectForKey {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Object for Key"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    
    NSDictionary *testData = @{
        @"stringValue": @"Test",
        @"numberValue": @123,
        @"arrayValue": @[@"one", @"two", @"three"]
    };
    
    [self.group configureWithDictionary:testData];
    
    // Test different types
    XCTAssertEqualObjects([self.group objectForKey:@"stringValue"], @"Test");
    XCTAssertEqualObjects([self.group objectForKey:@"numberValue"], @123);
    XCTAssertTrue([[self.group objectForKey:@"arrayValue"] isKindOfClass:[NSArray class]]);
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupObjectForNonExistentKey {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Object for Non-Existent Key"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    [self.group configureWithDictionary:@{@"key": @"value"}];
    
    // Test non-existent key
    id result = [self.group objectForKey:@"nonExistentKey"];
    XCTAssertNil(result, @"Should return nil for non-existent key");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Sub-Group Tests

- (void)testGroupForKey {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Group for Key"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    
    NSDictionary *subGroupData = @{
        @"subTitle": @"Sub Title",
        @"subValue": @100
    };
    
    [self.group configureWithDictionary:@{@"subGroup": subGroupData}];
    
    // Get sub-group
    Group *subGroup = [self.group groupForKey:@"subGroup"];
    XCTAssertNotNil(subGroup, @"Sub-group should not be nil");
    XCTAssertTrue([subGroup isKindOfClass:[Group class]], @"Should be Group instance");
    XCTAssertEqualObjects([subGroup objectForKey:@"subTitle"], @"Sub Title");
    XCTAssertEqualObjects([subGroup objectForKey:@"subValue"], @100);
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupForKeyWithNonDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Group for Key with Non-Dictionary"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    [self.group configureWithDictionary:@{@"notAGroup": @"stringValue"}];
    
    // Try to get group for non-dictionary value
    Group *result = [self.group groupForKey:@"notAGroup"];
    XCTAssertNil(result, @"Should return nil for non-dictionary value");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupsForKey {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Groups for Key"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    
    NSArray *subGroupsData = @[
        @{@"name": @"Group 1", @"value": @10},
        @{@"name": @"Group 2", @"value": @20},
        @{@"name": @"Group 3", @"value": @30}
    ];
    
    [self.group configureWithDictionary:@{@"subGroups": subGroupsData}];
    
    // Get multiple sub-groups
    NSArray *subGroups = [self.group groupsForKey:@"subGroups"];
    XCTAssertNotNil(subGroups, @"Sub-groups array should not be nil");
    XCTAssertEqual(subGroups.count, 3, @"Should have 3 sub-groups");
    
    Group *firstGroup = subGroups[0];
    XCTAssertTrue([firstGroup isKindOfClass:[Group class]]);
    XCTAssertEqualObjects([firstGroup objectForKey:@"name"], @"Group 1");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupsForKeyWithNonArray {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Groups for Key with Non-Array"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    [self.group configureWithDictionary:@{@"notAnArray": @"stringValue"}];
    
    // Try to get groups for non-array value
    NSArray *result = [self.group groupsForKey:@"notAnArray"];
    XCTAssertNil(result, @"Should return nil for non-array value");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Asset Tests

- (void)testGroupAssetForKey {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset for Key"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    
    NSDictionary *assetData = @{
        @"uid": @"asset123",
        @"filename": @"test.jpg",
        @"url": @"https://example.com/test.jpg"
    };
    
    [self.group configureWithDictionary:@{@"image": assetData}];
    
    // Get asset
    Asset *asset = [self.group assetForKey:@"image"];
    XCTAssertNotNil(asset, @"Asset should not be nil");
    XCTAssertTrue([asset isKindOfClass:[Asset class]], @"Should be Asset instance");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupAssetForKeyWithNonDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asset for Key with Non-Dictionary"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    [self.group configureWithDictionary:@{@"notAnAsset": @"stringValue"}];
    
    // Try to get asset for non-dictionary value
    Asset *result = [self.group assetForKey:@"notAnAsset"];
    XCTAssertNil(result, @"Should return nil for non-dictionary value");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupAssetsForKey {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Assets for Key"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    
    NSArray *assetsData = @[
        @{@"uid": @"asset1", @"filename": @"img1.jpg"},
        @{@"uid": @"asset2", @"filename": @"img2.jpg"},
        @{@"uid": @"asset3", @"filename": @"img3.jpg"}
    ];
    
    [self.group configureWithDictionary:@{@"images": assetsData}];
    
    // Get multiple assets
    NSArray *assets = [self.group assetsForKey:@"images"];
    XCTAssertNotNil(assets, @"Assets array should not be nil");
    XCTAssertEqual(assets.count, 3, @"Should have 3 assets");
    XCTAssertTrue([assets[0] isKindOfClass:[Asset class]]);
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupAssetsForKeyWithNonArray {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Assets for Key with Non-Array"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    [self.group configureWithDictionary:@{@"notAnArray": @"stringValue"}];
    
    // Try to get assets for non-array value
    NSArray *result = [self.group assetsForKey:@"notAnArray"];
    XCTAssertTrue(result.count == 0, @"Should return empty array for non-array value");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Markdown Tests

- (void)testGroupHTMLStringForMarkdownKey {
    XCTestExpectation *expectation = [self expectationWithDescription:@"HTML String for Markdown"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    
    NSString *markdown = @"# Test Header\n\nThis is **bold** text.";
    [self.group configureWithDictionary:@{@"markdown": markdown}];
    
    // Convert markdown to HTML
    NSString *html = [self.group HTMLStringForMarkdownKey:@"markdown"];
    XCTAssertNotNil(html, @"HTML should not be nil");
    XCTAssertTrue([html containsString:@"<h1>"], @"Should contain HTML header tag");
    XCTAssertTrue([html containsString:@"<strong>"], @"Should contain bold tag");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupHTMLStringForMarkdownKeyWithEmptyString {
    XCTestExpectation *expectation = [self expectationWithDescription:@"HTML String for Empty Markdown"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    [self.group configureWithDictionary:@{@"markdown": @""}];
    
    // Try to convert empty markdown
    NSString *html = [self.group HTMLStringForMarkdownKey:@"markdown"];
    XCTAssertNil(html, @"HTML should be nil for empty markdown");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupHTMLStringForNonExistentKey {
    XCTestExpectation *expectation = [self expectationWithDescription:@"HTML String for Non-Existent Key"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    [self.group configureWithDictionary:@{@"key": @"value"}];
    
    // Try to convert non-existent key
    NSString *html = [self.group HTMLStringForMarkdownKey:@"nonExistent"];
    XCTAssertNil(html, @"HTML should be nil for non-existent key");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupHTMLArrayForMarkdownKey {
    XCTestExpectation *expectation = [self expectationWithDescription:@"HTML Array for Markdown"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    
    NSArray *markdownArray = @[
        @"# Header 1",
        @"# Header 2",
        @"# Header 3"
    ];
    
    [self.group configureWithDictionary:@{@"markdowns": markdownArray}];
    
    // Convert markdown array to HTML array
    NSArray *htmlArray = [self.group HTMLArrayForMarkdownKey:@"markdowns"];
    XCTAssertNotNil(htmlArray, @"HTML array should not be nil");
    XCTAssertEqual(htmlArray.count, 3, @"Should have 3 HTML strings");
    XCTAssertTrue([htmlArray[0] containsString:@"<h1>"], @"First item should contain HTML header");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupHTMLArrayForMarkdownKeyWithNonArray {
    XCTestExpectation *expectation = [self expectationWithDescription:@"HTML Array for Non-Array"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    [self.group configureWithDictionary:@{@"notAnArray": @"string"}];
    
    // Try to convert non-array
    NSArray *htmlArray = [self.group HTMLArrayForMarkdownKey:@"notAnArray"];
    XCTAssertNil(htmlArray, @"HTML array should be nil for non-array value");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Entry Reference Tests

- (void)testGroupEntriesForKeyWithContentType {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entries for Key"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    
    NSArray *entriesData = @[
        @{@"uid": @"entry1", @"title": @"Entry 1"},
        @{@"uid": @"entry2", @"title": @"Entry 2"}
    ];
    
    [self.group configureWithDictionary:@{@"references": entriesData}];
    
    // Get entries
    NSArray *entries = [self.group entriesForKey:@"references" withContentType:@"source"];
    XCTAssertNotNil(entries, @"Entries should not be nil");
    XCTAssertEqual(entries.count, 2, @"Should have 2 entries");
    XCTAssertTrue([entries[0] isKindOfClass:[Entry class]]);
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupEntriesForKeyWithNonArray {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entries for Non-Array"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    [self.group configureWithDictionary:@{@"references": @"notAnArray"}];
    
    // Try to get entries for non-array
    NSArray *entries = [self.group entriesForKey:@"references" withContentType:@"source"];
    XCTAssertNil(entries, @"Entries should be nil for non-array value");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGroupEntriesForNonExistentKey {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entries for Non-Existent Key"];
    
    self.group = [[Group alloc] initWithStack:self.stack];
    [self.group configureWithDictionary:@{@"key": @"value"}];
    
    // Try to get entries for non-existent key
    NSArray *entries = [self.group entriesForKey:@"nonExistent" withContentType:@"source"];
    XCTAssertNil(entries, @"Entries should be nil for non-existent key");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end

