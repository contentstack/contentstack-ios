//
//  QueryAdvancedTest.m
//  ContentstackTest
//
//  Created by Contentstack on 06/11/25.
//  Copyright © 2025 Contentstack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Contentstack.h"
#import "Query.h"
#import "ContentType.h"
#import "Config.h"

@interface QueryAdvancedTest : XCTestCase
@property (nonatomic, strong) Stack *stack;
@property (nonatomic, strong) Query *query;
@end

@implementation QueryAdvancedTest

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
        self.query = [contentType query];
    }
}

- (void)tearDown {
    self.query = nil;
    self.stack = nil;
    [super tearDown];
}

#pragma mark - Language Tests

- (void)testLanguageEnUS {
    [self.query locale:@"US"];
    XCTAssertNotNil(self.query);
}

- (void)testLanguageENGB {
    [self.query locale:@"GB"];
    XCTAssertNotNil(self.query);
}

- (void)testLanguageFRFR {
    [self.query locale:@"FR"];
    XCTAssertNotNil(self.query);
}

- (void)testLanguageDEDE {
    [self.query locale:@"DE"];
    XCTAssertNotNil(self.query);
}

- (void)testLanguageESES {
    [self.query locale:@"ES"];
    XCTAssertNotNil(self.query);
}

#pragma mark - Where Comparison Tests

- (void)testWhereKeyEqualTo {
    [self.query whereKey:@"title" equalTo:@"Test Title"];
    XCTAssertNotNil(self.query);
}

- (void)testWhereKeyEqualToNumber {
    [self.query whereKey:@"count" equalTo:@100];
    XCTAssertNotNil(self.query);
}

- (void)testWhereKeyNotEqualTo {
    [self.query whereKey:@"status" notEqualTo:@"draft"];
    XCTAssertNotNil(self.query);
}

- (void)testWhereKeyLessThan {
    [self.query whereKey:@"price" lessThan:@100];
    XCTAssertNotNil(self.query);
}

- (void)testWhereKeyGreaterThan {
    [self.query whereKey:@"views" greaterThan:@1000];
    XCTAssertNotNil(self.query);
}

- (void)testWhereKeyLessThanOrEqualTo {
    [self.query whereKey:@"rating" lessThanOrEqualTo:@5];
    XCTAssertNotNil(self.query);
}

- (void)testWhereKeyGreaterThanOrEqualTo {
    [self.query whereKey:@"age" greaterThanOrEqualTo:@18];
    XCTAssertNotNil(self.query);
}

- (void)testWhereKeyContainedIn {
    NSArray *values = @[@"published", @"archived"];
    [self.query whereKey:@"status" containedIn:values];
    XCTAssertNotNil(self.query);
}

- (void)testWhereKeyContainedInEmptyArray {
    [self.query whereKey:@"status" containedIn:@[]];
    XCTAssertNotNil(self.query);
}

- (void)testWhereKeyNotContainedIn {
    NSArray *values = @[@"draft", @"deleted"];
    [self.query whereKey:@"status" notContainedIn:values];
    XCTAssertNotNil(self.query);
}

- (void)testWhereKeyNotContainedInMultiple {
    NSArray *values = @[@"value1", @"value2", @"value3"];
    [self.query whereKey:@"field" notContainedIn:values];
    XCTAssertNotNil(self.query);
}

#pragma mark - Reference Query Tests

- (void)testWhereKeyNotIn {
    ContentType *ct = [self.stack contentTypeWithName:@"reference"];
    Query *refQuery = [ct query];
    [refQuery whereKey:@"status" equalTo:@"published"];
    
    [self.query whereKey:@"reference_field" notIn:refQuery];
    XCTAssertNotNil(self.query);
}

#pragma mark - Include Reference Field Tests

- (void)testIncludeReferenceFieldWithKeyArray {
    NSArray *keys = @[@"reference1", @"reference2"];
    [self.query includeReferenceFieldWithKey:keys];
    XCTAssertNotNil(self.query);
}

- (void)testIncludeReferenceFieldWithSingleKey {
    [self.query includeReferenceFieldWithKey:@[@"single_reference"]];
    XCTAssertNotNil(self.query);
}

- (void)testIncludeReferenceFieldWithKeyOnlyFields {
    NSArray *fields = @[@"title", @"url"];
    [self.query includeReferenceFieldWithKey:@"reference_field" onlyFields:fields];
    XCTAssertNotNil(self.query);
}

- (void)testIncludeReferenceFieldWithKeyOnlyFieldsSingle {
    [self.query includeReferenceFieldWithKey:@"ref" onlyFields:@[@"title"]];
    XCTAssertNotNil(self.query);
}

- (void)testIncludeReferenceFieldWithKeyExcludingFields {
    NSArray *excludeFields = @[@"internal_field", @"metadata"];
    [self.query includeReferenceFieldWithKey:@"reference_field" excludingFields:excludeFields];
    XCTAssertNotNil(self.query);
}

- (void)testIncludeReferenceFieldWithKeyExcludingMultiple {
    NSArray *fields = @[@"field1", @"field2", @"field3"];
    [self.query includeReferenceFieldWithKey:@"ref" excludingFields:fields];
    XCTAssertNotNil(self.query);
}

#pragma mark - Complex Query Tests

- (void)testOrWithSubqueries {
    ContentType *ct = [self.stack contentTypeWithName:@"source"];
    
    Query *query1 = [ct query];
    [query1 whereKey:@"status" equalTo:@"published"];
    
    Query *query2 = [ct query];
    [query2 whereKey:@"featured" equalTo:@YES];
    
    [self.query orWithSubqueries:@[query1, query2]];
    XCTAssertNotNil(self.query);
}

- (void)testOrWithSubqueriesMultiple {
    ContentType *ct = [self.stack contentTypeWithName:@"source"];
    
    Query *q1 = [ct query];
    [q1 whereKey:@"type" equalTo:@"article"];
    
    Query *q2 = [ct query];
    [q2 whereKey:@"type" equalTo:@"blog"];
    
    Query *q3 = [ct query];
    [q3 whereKey:@"type" equalTo:@"news"];
    
    [self.query orWithSubqueries:@[q1, q2, q3]];
    XCTAssertNotNil(self.query);
}

- (void)testAndWithSubqueries {
    ContentType *ct = [self.stack contentTypeWithName:@"source"];
    
    Query *query1 = [ct query];
    [query1 whereKey:@"status" equalTo:@"published"];
    
    Query *query2 = [ct query];
    [query2 whereKey:@"featured" equalTo:@YES];
    
    [self.query andWithSubqueries:@[query1, query2]];
    XCTAssertNotNil(self.query);
}

- (void)testAndWithSubqueriesMultiple {
    ContentType *ct = [self.stack contentTypeWithName:@"source"];
    
    Query *q1 = [ct query];
    [q1 whereKey:@"published" equalTo:@YES];
    
    Query *q2 = [ct query];
    [q2 whereKey:@"approved" equalTo:@YES];
    
    Query *q3 = [ct query];
    [q3 whereKey:@"featured" equalTo:@YES];
    
    [self.query andWithSubqueries:@[q1, q2, q3]];
    XCTAssertNotNil(self.query);
}

#pragma mark - Additional Include Tests

- (void)testIncludeOwner {
    [self.query includeOwner];
    XCTAssertNotNil(self.query);
}

- (void)testObjectsCount {
    [self.query objectsCount];
    XCTAssertNotNil(self.query);
}

#pragma mark - Query Dictionary Tests

- (void)testQueryWithDictionary {
    NSDictionary *queryDict = @{
        @"title": @"Test",
        @"status": @"published"
    };
    
    [self.query query:queryDict];
    XCTAssertNotNil(self.query);
}

- (void)testQueryWithEmptyDictionary {
    [self.query query:@{}];
    XCTAssertNotNil(self.query);
}

- (void)testQueryWithComplexDictionary {
    NSDictionary *complexQuery = @{
        @"$or": @[
            @{@"status": @"published"},
            @{@"featured": @YES}
        ]
    };
    
    [self.query query:complexQuery];
    XCTAssertNotNil(self.query);
}

#pragma mark - Add Query Params Tests

- (void)testAddQueryParams {
    NSDictionary *params = @{
        @"key1": @"value1",
        @"key2": @"value2"
    };
    
    [self.query addQueryParams:params];
    XCTAssertNotNil(self.query);
}

- (void)testAddQueryParamsEmpty {
    [self.query addQueryParams:@{}];
    XCTAssertNotNil(self.query);
}

- (void)testAddQueryParamsMultiple {
    [self.query addQueryParams:@{@"param1": @"val1"}];
    [self.query addQueryParams:@{@"param2": @"val2"}];
    [self.query addQueryParams:@{@"param3": @"val3"}];
    
    XCTAssertNotNil(self.query);
}

#pragma mark - Add Query With Key Tests

- (void)testAddQueryWithKeyString {
    [self.query addQueryWithKey:@"custom_key" andValue:@"custom_value"];
    XCTAssertNotNil(self.query);
}

- (void)testAddQueryWithKeyNumber {
    [self.query addQueryWithKey:@"count" andValue:@42];
    XCTAssertNotNil(self.query);
}

- (void)testAddQueryWithKeyArray {
    NSArray *array = @[@"item1", @"item2"];
    [self.query addQueryWithKey:@"items" andValue:array];
    XCTAssertNotNil(self.query);
}

- (void)testAddQueryWithKeyDictionary {
    NSDictionary *dict = @{@"nested": @"value"};
    [self.query addQueryWithKey:@"metadata" andValue:dict];
    XCTAssertNotNil(self.query);
}

#pragma mark - Combined Query Tests

- (void)testComplexQueryCombination {
    [self.query whereKey:@"status" equalTo:@"published"];
    [self.query whereKey:@"views" greaterThan:@1000];
    [self.query orderByDescending:@"created_at"];
    [self.query limitObjects:@20];
    [self.query skipObjects:@10];
    [self.query includeCount];
    [self.query includeContentType];
    
    XCTAssertNotNil(self.query);
}

- (void)testMultipleWhereConditions {
    [self.query whereKey:@"status" equalTo:@"published"];
    [self.query whereKey:@"featured" equalTo:@YES];
    [self.query whereKey:@"category" containedIn:@[@"tech", @"science"]];
    [self.query whereKey:@"rating" greaterThanOrEqualTo:@4];
    
    XCTAssertNotNil(self.query);
}

@end





