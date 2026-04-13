//
//  NSObjectExtensionsTest.m
//  ContentstackTest
//
//  Created by Contentstack on 06/11/25.
//  Copyright © 2025 Contentstack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Stack.h"
#import "NSObject+Extensions.h"

@interface NSObjectExtensionsTest : XCTestCase
@property (nonatomic, strong) NSObject *testObject;
@end

@implementation NSObjectExtensionsTest

- (void)setUp {
    [super setUp];
    self.testObject = [[NSObject alloc] init];
}

- (void)tearDown {
    self.testObject = nil;
    [super tearDown];
}

#pragma mark - Network Error Codes Tests

- (void)testNetworkErrorCodes {
    NSArray *errorCodes = [self.testObject networkErrorCodes];
    
    XCTAssertNotNil(errorCodes, @"Network error codes should not be nil");
    XCTAssertGreaterThan(errorCodes.count, 0, @"Should have error codes");
    
    // Verify it contains expected error codes
    XCTAssertTrue([errorCodes containsObject:@(kCFURLErrorNotConnectedToInternet)]);
    XCTAssertTrue([errorCodes containsObject:@(kCFURLErrorCannotConnectToHost)]);
}

- (void)testNetworkErrorCodesCaching {
    NSArray *codes1 = [self.testObject networkErrorCodes];
    NSArray *codes2 = [self.testObject networkErrorCodes];
    
    // Should return the same cached instance
    XCTAssertEqual(codes1, codes2, @"Should return cached array");
}

#pragma mark - Host URLs Tests

- (void)testHostURLS {
    NSArray *urls = [self.testObject hostURLS];
    
    XCTAssertNotNil(urls, @"Host URLs should not be nil");
    XCTAssertGreaterThan(urls.count, 0, @"Should have host URLs");
    XCTAssertTrue([urls containsObject:@"cdn.contentstack.io"]);
    XCTAssertTrue([urls containsObject:@"eu-cdn.contentstack.com"]);
}

- (void)testHostURLForUSRegion {
    NSString *url = [self.testObject hostURL:0]; // US region
    XCTAssertEqualObjects(url, @"cdn.contentstack.io");
}

- (void)testHostURLForEURegion {
    NSString *url = [self.testObject hostURL:1]; // EU region
    XCTAssertEqualObjects(url, @"eu-cdn.contentstack.com");
}

- (void)testHostURLForAURegion {
    NSString *url = [self.testObject hostURL:2]; // AU region
    XCTAssertEqualObjects(url, @"au-cdn.contentstack.com");
}

- (void)testHostURLForAzureNARegion {
    NSString *url = [self.testObject hostURL:3]; // Azure NA
    XCTAssertEqualObjects(url, @"azure-na-cdn.contentstack.com");
}

- (void)testHostURLForAzureEURegion {
    NSString *url = [self.testObject hostURL:4]; // Azure EU
    XCTAssertEqualObjects(url, @"azure-eu-cdn.contentstack.com");
}

- (void)testHostURLForGCPNARegion {
    NSString *url = [self.testObject hostURL:5]; // GCP NA
    XCTAssertEqualObjects(url, @"gcp-na-cdn.contentstack.com");
}

- (void)testHostURLForGCPEURegion {
    NSString *url = [self.testObject hostURL:6]; // GCP EU
    XCTAssertEqualObjects(url, @"gcp-eu-cdn.contentstack.com");
}

#pragma mark - Region Code Tests

- (void)testRegionCodeUS {
    NSString *code = [self.testObject regionCode:0];
    XCTAssertEqualObjects(code, @"us");
}

- (void)testRegionCodeEU {
    NSString *code = [self.testObject regionCode:1];
    XCTAssertEqualObjects(code, @"eu");
}

- (void)testRegionCodeAU {
    NSString *code = [self.testObject regionCode:2];
    XCTAssertEqualObjects(code, @"au");
}

- (void)testRegionCodeAzureNA {
    NSString *code = [self.testObject regionCode:3];
    XCTAssertEqualObjects(code, @"azure-na");
}

- (void)testRegionCodeAzureEU {
    NSString *code = [self.testObject regionCode:4];
    XCTAssertEqualObjects(code, @"azure-eu");
}

- (void)testRegionCodeGCPNA {
    NSString *code = [self.testObject regionCode:5];
    XCTAssertEqualObjects(code, @"gcp-na");
}

- (void)testRegionCodeGCPEU {
    NSString *code = [self.testObject regionCode:6];
    XCTAssertEqualObjects(code, @"gcp-eu");
}

#pragma mark - Locale Code Tests

- (void)testLocaleCodeEnUS {
    NSString *code = [self.testObject localeCode:0];
    XCTAssertEqualObjects(code, @"af-za", @"First locale should be af-za");
}

- (void)testLocaleCodeMultiple {
    // Test a few different locales
    NSString *code1 = [self.testObject localeCode:1];
    NSString *code2 = [self.testObject localeCode:2];
    
    XCTAssertNotNil(code1);
    XCTAssertNotNil(code2);
    XCTAssertNotEqual(code1, code2, @"Different indices should return different locales");
}

- (void)testIndexOfLocaleCodeString {
    NSUInteger index = [self.testObject indexOfLocaleCodeString:@"en-us"];
    XCTAssertEqual(index, 49, @"en-us should be at index 49");
}

- (void)testIndexOfLocaleCodeStringMultiple {
    // Get a locale code and find its index
    NSString *code = [self.testObject localeCode:5];
    NSUInteger index = [self.testObject indexOfLocaleCodeString:code];
    XCTAssertEqual(index, 5, @"Should find correct index");
}

- (void)testIndexOfInvalidLocaleCode {
    NSUInteger index = [self.testObject indexOfLocaleCodeString:@"invalid-locale"];
    XCTAssertEqual(index, NSNotFound, @"Invalid locale should return NSNotFound");
}

#pragma mark - Publish Type Tests

- (void)testPublishTypeAssetPublished {
    NSString *type = [self.testObject publishType:0];
    XCTAssertEqualObjects(type, @"asset_published");
}

- (void)testPublishTypeEntryPublished {
    NSString *type = [self.testObject publishType:1];
    XCTAssertEqualObjects(type, @"entry_published");
}

- (void)testPublishTypeAssetUnpublished {
    NSString *type = [self.testObject publishType:2];
    XCTAssertEqualObjects(type, @"asset_unpublished");
}

- (void)testPublishTypeEntryUnpublished {
    NSString *type = [self.testObject publishType:3];
    XCTAssertEqualObjects(type, @"entry_unpublished");
}

- (void)testPublishTypeAssetDeleted {
    NSString *type = [self.testObject publishType:4];
    XCTAssertEqualObjects(type, @"asset_deleted");
}

- (void)testPublishTypeEntryDeleted {
    NSString *type = [self.testObject publishType:5];
    XCTAssertEqualObjects(type, @"entry_deleted");
}

- (void)testPublishTypeContentTypeDeleted {
    NSString *type = [self.testObject publishType:6];
    XCTAssertEqualObjects(type, @"content_type_deleted");
}

#pragma mark - JSON Conversion Tests

- (void)testDictionaryFromJSONData {
    NSDictionary *testDict = @{@"key": @"value", @"number": @123};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:testDict options:0 error:nil];
    
    NSDictionary *result = [self.testObject dictionaryFromJSONData:jsonData];
    
    XCTAssertNotNil(result);
    XCTAssertEqualObjects(result[@"key"], @"value");
    XCTAssertEqualObjects(result[@"number"], @123);
}

- (void)testDictionaryFromInvalidJSONData {
    NSData *invalidData = [@"invalid json" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [self.testObject dictionaryFromJSONData:invalidData];
    
    XCTAssertNil(result, @"Should return nil for invalid JSON");
}

- (void)testDictionaryFromNilData {
    NSDictionary *result = [self.testObject dictionaryFromJSONData:nil];
    XCTAssertNil(result, @"Should return nil for nil data");
}

- (void)testJSONDataFromDictionary {
    NSDictionary *testDict = @{@"key": @"value", @"number": @123};
    
    NSData *jsonData = [self.testObject jsonDataFromDictonary:testDict];
    
    XCTAssertNotNil(jsonData);
    XCTAssertGreaterThan(jsonData.length, 0);
    
    // Verify it can be converted back
    NSDictionary *parsedDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    XCTAssertEqualObjects(parsedDict[@"key"], @"value");
}

- (void)testJSONStringFromDictionary {
    NSDictionary *testDict = @{@"key": @"value"};
    
    NSString *jsonString = [self.testObject jsonStringFromDictonary:testDict];
    
    XCTAssertNotNil(jsonString);
    XCTAssertTrue([jsonString containsString:@"key"]);
    XCTAssertTrue([jsonString containsString:@"value"]);
}

- (void)testArrayFromJSONData {
    NSArray *testArray = @[@"item1", @"item2", @123];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:testArray options:0 error:nil];
    
    NSArray *result = [self.testObject arrayFromJSONData:jsonData];
    
    XCTAssertNotNil(result);
    XCTAssertEqual(result.count, 3);
    XCTAssertEqualObjects(result[0], @"item1");
    XCTAssertEqualObjects(result[2], @123);
}

- (void)testArrayFromInvalidJSONData {
    NSData *invalidData = [@"invalid json" dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *result = [self.testObject arrayFromJSONData:invalidData];
    
    XCTAssertNil(result, @"Should return nil for invalid JSON");
}

- (void)testJSONStringFromArray {
    NSArray *testArray = @[@"item1", @"item2", @123];
    
    NSString *jsonString = [self.testObject jsonStringFromArray:testArray];
    
    XCTAssertNotNil(jsonString);
    XCTAssertTrue([jsonString containsString:@"item1"]);
    XCTAssertTrue([jsonString containsString:@"item2"]);
    XCTAssertTrue([jsonString containsString:@"123"]);
}

#pragma mark - Property Type Assertion Tests

- (void)testAssertPropertyTypesWithValidProperties {
    NSDictionary *validProps = @{
        @"string": @"value",
        @"number": @123,
        @"null": [NSNull null],
        @"array": @[@1, @2],
        @"dict": @{@"key": @"value"},
        @"date": [NSDate date],
        @"url": [NSURL URLWithString:@"https://example.com"]
    };
    
    // Should not throw
    XCTAssertNoThrow([self.testObject assertPropertyTypes:validProps]);
}

- (void)testAssertPropertyTypesWithEmptyDictionary {
    NSDictionary *emptyDict = @{};
    XCTAssertNoThrow([self.testObject assertPropertyTypes:emptyDict]);
}

#pragma mark - Perform and Wait Tests

- (void)testPerformAndWait {
    __block BOOL executed = NO;
    
    [NSObject performAndWait:^(dispatch_semaphore_t semaphore) {
        // Simulate async work
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            executed = YES;
            dispatch_semaphore_signal(semaphore);
        });
    }];
    
    XCTAssertTrue(executed, @"Block should have executed and waited");
}

- (void)testPerformAndWaitImmediateSignal {
    __block BOOL executed = NO;
    
    [NSObject performAndWait:^(dispatch_semaphore_t semaphore) {
        executed = YES;
        dispatch_semaphore_signal(semaphore);
    }];
    
    XCTAssertTrue(executed, @"Block should have executed");
}

@end





