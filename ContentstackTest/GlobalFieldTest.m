//
//  GlobalFieldTest.m
//  Contentstack
//
//  Created by Reeshika Hosmani on 02/06/25.
//  Copyright © 2025 Contentstack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Contentstack/Contentstack.h>
#import "CSIOInternalHeaders.h"
#import "GlobalField.h"
#import "ContentstackDefinitions.h"

@interface GlobalFieldTest : XCTestCase{
    Stack *csStack;
    Config *config;
}

@property (nonatomic, strong) Stack *stack;
@property (nonatomic, strong) GlobalField *globalField;

@end

@implementation GlobalFieldTest

- (void)setUp {
    [super setUp];
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"config" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *configdict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.stack = [Contentstack stackWithAPIKey:configdict[@"api_key"]
                                  accessToken:configdict[@"delivery_token"]
                              environmentName:configdict[@"environment"]];
    // Initialize global field
    self.globalField = [self.stack globalFieldWithName:@"global_field_uid"];
}

- (void)tearDown {
    self.stack = nil;
    self.globalField = nil;
    [super tearDown];
}

- (void)testFetchGlobalField {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch GlobalField"];
    
    [self.globalField includeBranch];
    
    // Call fetch method
    [self.globalField fetch:^(ResponseType type, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error fetching global field: %@", error);
        }
        
        // Verify no error
        XCTAssertNil(error, @"Error should be nil");
        
        // Verify globalField properties
        XCTAssertNotNil(self.globalField.title, @"Title should not be nil");
        XCTAssertNotNil(self.globalField.uid, @"UID should not be nil");
        XCTAssertNotNil(self.globalField.Description, @"Description should not be nil");
        
        // Verify data types
        XCTAssertTrue([self.globalField.title isKindOfClass:[NSString class]], @"Title should be NSString");
        XCTAssertTrue([self.globalField.uid isKindOfClass:[NSString class]], @"UID should be NSString");
        XCTAssertTrue([self.globalField.description isKindOfClass:[NSString class]], @"Description should be NSString");
        
        [expectation fulfill];
    }];
    
    // Wait for expectation
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Test timeout error: %@", error);
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testFetchGlobalFieldWithInvalidName {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Invalid GlobalField"];
    
    // Create globalField with invalid name
    GlobalField *invalidGlobalField = [self.stack globalFieldWithName:@"invalid_global_field"];
    
    // Call fetch method
    [invalidGlobalField fetch:^(ResponseType type, NSError * _Nullable error) {
        // Verify error is not nil
        XCTAssertNotNil(error, @"Error should not be nil");
        
        [expectation fulfill];
    }];
    
    // Wait for expectation
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testFetchGlobalFieldWithIncludeBranch {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch GlobalField with Branch"];
    
    // Include branch
    [self.globalField includeBranch];
    
    // Call fetch method
    [self.globalField fetch:^(ResponseType type, NSError * _Nullable error) {
        // Verify no error
        XCTAssertNil(error, @"Error should be nil");
        
        // Verify branch is included
        XCTAssertNotNil(self.globalField.branch, @"Branch should not be nil");
        
        [expectation fulfill];
    }];
    
    // Wait for expectation
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testFetchGlobalFieldWithIncludeSchema {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch GlobalField with Schema"];
    
    // Include schema
    [self.globalField includeGlobalFieldSchema];
    
    // Call fetch method
    [self.globalField fetch:^(ResponseType type, NSError * _Nullable error) {
        // Verify no error
        XCTAssertNil(error, @"Error should be nil");
        
        // Verify schema is included in properties
        XCTAssertNotNil(self.globalField.schema, @"Schema should not be nil");
        
        [expectation fulfill];
    }];
    
    // Wait for expectation
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)testFetchAllGlobalFields {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch all GlobalFields"];
    
    // Call fetch method
    [self.globalField fetchAll:^(ResponseType type, NSArray<GlobalField *> * _Nullable result, NSError * _Nullable error) {
        
        // Verify no error
        XCTAssertNil(error, @"Error should be nil");
        XCTAssertNotNil(result, @"Result is not null");
        [expectation fulfill];
        
    }];
    
    // Wait for expectation
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

@end
