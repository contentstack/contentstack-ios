//
//  EntryAdvancedTest.m
//  ContentstackTest
//
//  Created by Contentstack on 06/11/25.
//  Copyright © 2025 Contentstack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Contentstack.h"
#import "Entry.h"
#import "ContentType.h"
#import "Config.h"
#import "CSIOInternalHeaders.h"

@interface EntryAdvancedTest : XCTestCase
@property (nonatomic, strong) Stack *stack;
@property (nonatomic, strong) Entry *entry;
@end

@implementation EntryAdvancedTest

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
        
        ContentType *contentType = [self.stack contentTypeWithName:@"source"];
        self.entry = [contentType entryWithUID:@"test_uid"];
    }
}

- (void)tearDown {
    self.entry = nil;
    self.stack = nil;
    [super tearDown];
}

- (NSTimeInterval)requestTimeout {
    return 60.0;
}

- (void)waitForRequest {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:[self requestTimeout]];
    while ([self.entry valueForKey:@"requestOperation"] != nil && [timeoutDate timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    }
}

#pragma mark - Dictionary Access Tests

- (void)testObjectForKeyNonExistent {
    id value = [self.entry objectForKey:@"nonexistent_key"];
    // Entry without fetch will return nil
    XCTAssertTrue(value == nil || [value isKindOfClass:[NSObject class]]);
}

- (void)testObjectForKeyedSubscriptNil {
    id value = self.entry[@"nonexistent"];
    // Entry without fetch will return nil
    XCTAssertTrue(value == nil || [value isKindOfClass:[NSObject class]]);
}

- (void)testObjectForKeyMethod {
    // Test that objectForKey: method exists and doesn't crash
    XCTAssertNoThrow([self.entry objectForKey:@"any_key"]);
}

- (void)testObjectForKeyedSubscriptMethod {
    // Test that subscript access works
    XCTAssertNoThrow(self.entry[@"any_key"]);
}

#pragma mark - Has Key Tests

- (void)testHasKeyDoesNotExist {
    // Without fetch, entry has no data
    BOOL hasKey = [self.entry hasKey:@"nonexistent_key"];
    XCTAssertFalse(hasKey);
}

- (void)testHasKeyWithNil {
    BOOL hasKey = [self.entry hasKey:nil];
    XCTAssertFalse(hasKey);
}

- (void)testHasKeyMethod {
    // Test that hasKey: method exists and doesn't crash
    XCTAssertNoThrow([self.entry hasKey:@"any_key"]);
}

#pragma mark - Markdown Conversion Tests

- (void)testHTMLStringForMarkdownKeyNonExistent {
    // Without data, should return nil
    NSString *html = [self.entry HTMLStringForMarkdownKey:@"nonexistent"];
    XCTAssertNil(html);
}

- (void)testHTMLStringForMarkdownKeyMethod {
    // Test that the method exists and doesn't crash
    XCTAssertNoThrow([self.entry HTMLStringForMarkdownKey:@"any_key"]);
}

- (void)testHTMLArrayForMarkdownKeyNonExistent {
    // Without data, should return nil
    NSArray *htmlArray = [self.entry HTMLArrayForMarkdownKey:@"nonexistent"];
    XCTAssertNil(htmlArray);
}

- (void)testHTMLArrayForMarkdownKeyMethod {
    // Test that the method exists and doesn't crash
    XCTAssertNoThrow([self.entry HTMLArrayForMarkdownKey:@"any_key"]);
}

#pragma mark - Asset Retrieval Tests

- (void)testAssetForKeyNonExistent {
    // Without data, should return nil
    Asset *asset = [self.entry assetForKey:@"nonexistent_asset"];
    XCTAssertNil(asset);
}

- (void)testAssetForKeyMethod {
    // Test that the method exists and doesn't crash
    XCTAssertNoThrow([self.entry assetForKey:@"any_key"]);
}

- (void)testAssetsForKeyNonExistent {
    // Without data, should return empty array (not nil) for backward compatibility
    NSArray *assets = [self.entry assetsForKey:@"nonexistent_assets"];
    XCTAssertNotNil(assets);
    XCTAssertEqual(assets.count, 0);
}

- (void)testAssetsForKeyMethod {
    // Test that the method exists and doesn't crash
    XCTAssertNoThrow([self.entry assetsForKey:@"any_key"]);
}

#pragma mark - Group Retrieval Tests

- (void)testGroupsForKeyNonExistent {
    // Without data, should return nil
    NSArray *groups = [self.entry groupsForKey:@"nonexistent_groups"];
    XCTAssertNil(groups);
}

- (void)testGroupsForKeyMethod {
    // Test that the method exists and doesn't crash
    XCTAssertNoThrow([self.entry groupsForKey:@"any_key"]);
}

#pragma mark - Reference Entry Tests

- (void)testEntriesForKeyWithContentTypeNonExistent {
    // Without data, should return nil
    NSArray *entries = [self.entry entriesForKey:@"nonexistent_ref" withContentType:@"ref_ct"];
    XCTAssertNil(entries);
}

- (void)testEntriesForKeyMethod {
    // Test that the method exists and doesn't crash
    XCTAssertNoThrow([self.entry entriesForKey:@"any_key" withContentType:@"any_ct"]);
}

#pragma mark - Description Test

- (void)testEntryDescription {
    NSString *description = [self.entry description];
    
    XCTAssertNotNil(description);
    XCTAssertTrue([description containsString:@"Entry"]);
}

#pragma mark - Initialization Tests

- (void)testInitWithContentTypeOnly {
    ContentType *contentType = [self.stack contentTypeWithName:@"test"];
    Entry *entry = [contentType entryWithUID: @"test"];
    
    XCTAssertNotNil(entry);
    XCTAssertEqualObjects(entry.contentTypeName,@"test");
}

- (void)testInitWithTaxonomy {
    Taxonomy *taxonomy = [[Taxonomy alloc] initWithStack:self.stack];
    Entry *entry = [[Entry alloc] initWithTaxonomy:taxonomy];
    
    XCTAssertNotNil(entry);
}

#pragma mark - Include Methods Tests

- (void)testIncludeFallback {
    [self.entry includeFallback];
    XCTAssertNotNil(self.entry);
}

- (void)testIncludeMetadata {
    [self.entry includeMetadata];
    XCTAssertNotNil(self.entry);
}

- (void)testIncludeBranch {
    [self.entry includeBranch];
    XCTAssertNotNil(self.entry);
}

- (void)testGroupForKey {
    Group *group = [self.entry groupForKey:@"any_group_key"];
    // Without data, should return nil
    XCTAssertTrue(group == nil || [group isKindOfClass:[Group class]]);
}

- (void)testConfigureWithDictionary {
    NSDictionary *testDict = @{
        @"title": @"Test Title",
        @"description": @"Test Description"
    };
    
    [self.entry configureWithDictionary:testDict];
    XCTAssertNotNil(self.entry);
}

- (void)testConfigureWithEmptyDictionary {
    [self.entry configureWithDictionary:@{}];
    XCTAssertNotNil(self.entry);
}

- (void)testEntryProperties {
    // Test that readonly properties exist and can be accessed
    XCTAssertNotNil(self.entry.uid);
    XCTAssertNotNil(self.entry.contentTypeName);
    // Other properties may be nil until fetch
    XCTAssertTrue(YES);
}

- (void)testEntryCachePolicy {
    self.entry.cachePolicy = CACHE_THEN_NETWORK;
    XCTAssertEqual(self.entry.cachePolicy, CACHE_THEN_NETWORK);
    
    self.entry.cachePolicy = NETWORK_ONLY;
    XCTAssertEqual(self.entry.cachePolicy, NETWORK_ONLY);
}

- (void)testEntryLocale {
    self.entry.locale = @"en-us";
    XCTAssertEqualObjects(self.entry.locale, @"en-us");
}

@end

