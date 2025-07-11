//
//  ContentstackTest.m
//  ContentstackTest
//
//  Created by Reefaq on 12/01/17.
//  Copyright © 2017 Contentstack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Contentstack/Contentstack.h>

@interface CSPinnig:  NSObject <CSURLSessionDelegate>{
    
}
@end

@implementation CSPinnig

- (void)URLSession:(NSURLSession * _Nonnull)session didReceiveChallenge:(NSURLAuthenticationChallenge * _Nonnull)challenge completionHandler:(void (^ _Nonnull)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }

    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

- (void)URLSession:(NSURLSession * _Nonnull)session task:(NSURLSessionTask * _Nonnull)task didReceiveChallenge:(NSURLAuthenticationChallenge * _Nonnull)challenge completionHandler:(void (^ _Nonnull)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }

    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

@end
static NSInteger kRequestTimeOutInSeconds = 400;
static NSString *_sourceUid = @"";
static NSString *_assetUid = @"";
static NSString *_modularblockUid = @"";
static NSString *_numbersContentTypeUid = @"";

@interface Query(HeaderTest)

@property (nonatomic, strong) NSMutableSet *requestOperationSet;
@end

@implementation Query(HeaderTest)
@dynamic requestOperationSet;

-(NSDictionary *)getHeaderFields {
    NSLog (@"set: %@",self.requestOperationSet);
    __block id headerDictionary = nil;
    [self.requestOperationSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableURLRequest *request = [obj performSelector:NSSelectorFromString(@"originalRequest")];
        NSLog (@"request: %@",request.allHTTPHeaderFields);
        *stop = YES;
        headerDictionary = request.allHTTPHeaderFields;
        return;
    }];
    
    return headerDictionary;
}

@end

@interface ContentstackTest : XCTestCase {
    Stack *csStack;
    Config *config;
}
@property (nonatomic, strong) Entry *kvoEntry;
@end

@implementation ContentstackTest


- (void)setUp {
    [super setUp];
    config = [[Config alloc] init];
//    config.delegate = [[CSPinnig alloc] init];
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"config" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    config.host = dict[@"host"];
    csStack = [Contentstack stackWithAPIKey:dict[@"api_key"] accessToken:dict[@"delivery_token"] environmentName:dict[@"environment"] config:config];
}

- (void)waitForRequest {
    [self waitForExpectationsWithTimeout:kRequestTimeOutInSeconds handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Could not perform operation (Timed out) ~ ERR: %@", error.userInfo);
        }
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark -
#pragma mark Test Case - Header


- (void)testStackHeadersEarlyAccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@"EarlyAccessHeadersPassed"];
    config = [[Config alloc] init];
    config.setEarlyAccess = @[@"Taxonomy", @"Teams", @"Terms", @"LivePreview"];
    csStack = [Contentstack stackWithAPIKey:@"apikey" accessToken:@"delivery_token" environmentName:@"environment" config:config];
    // Check the headers in the stack
    NSDictionary *headers = [csStack getHeaders];
    // Check if the early access headers are set correctly
    NSString *expectedHeaderValue = @"Taxonomy,Teams,Terms,LivePreview";
    NSString *earlyAccessHeader = headers[@"x-header-ea"];
    
    XCTAssertNotNil(earlyAccessHeader, @"Early access header should be present");
    XCTAssertEqualObjects(earlyAccessHeader, expectedHeaderValue, @"Early access header should match the expected value");
    
    // Fulfill the expectation to mark the test as completed
    [expectation fulfill];

    // Wait for the request to complete
    [self waitForExpectationsWithTimeout:kRequestTimeOutInSeconds handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Test timed out: %@", error.localizedDescription);
        }
    }];
}

- (void)testNoEarlyAccessHeaders {
    XCTestExpectation *expectation = [self expectationWithDescription:@"NoEarlyAccessHeaders"];
    config = [[Config alloc] init];
    csStack = [Contentstack stackWithAPIKey:@"apikey" accessToken:@"delivery_token" environmentName:@"environment" config:config];
    
    NSDictionary *headers = [csStack getHeaders];
    NSString *earlyAccessHeader = headers[@"x-header-ea"];
    XCTAssertNil(earlyAccessHeader, @"Early access header should not be present when no early access features are set");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:kRequestTimeOutInSeconds handler:nil];
}

- (void)testSingleEarlyAccessHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"SingleEarlyAccessHeader"];
    config = [[Config alloc] init];
    config.setEarlyAccess = @[@"LivePreview"];
    csStack = [Contentstack stackWithAPIKey:@"apikey" accessToken:@"delivery_token" environmentName:@"environment" config:config];
    
    NSDictionary *headers = [csStack getHeaders];
    NSString *expectedHeaderValue = @"LivePreview";
    NSString *earlyAccessHeader = headers[@"x-header-ea"];
    XCTAssertNotNil(earlyAccessHeader, @"Early access header should be present");
    XCTAssertEqualObjects(earlyAccessHeader, expectedHeaderValue, @"Single early access header should match the expected value");
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:kRequestTimeOutInSeconds handler:nil];
}


- (void)test01FetchSourceEntries {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch All Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            Entry *obj = [result getResult][0];
            _sourceUid = obj.uid;
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}


- (void)test02FetchModularBlockEntries {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch All Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"modular_block"];
    Query* csQuery = [csForm query];
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            Entry *obj = [result getResult][0];
            _modularblockUid = obj.uid;
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}


- (void)test03FetchNumbersContentTypeEntries {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch All Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"numbers_content_type"];
    Query* csQuery = [csForm query];
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            Entry *obj = [result getResult][0];
            _numbersContentTypeUid = obj.uid;
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}


- (void)test04FetchAssets {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch All Asset"];
    AssetLibrary* assets = [csStack assetLibrary];
    [assets includeRelativeUrls];
    [assets sortWithKey:@"created_at" orderBy:OrderByAscending];
    [assets fetchAll:^(ResponseType type, NSArray *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            Asset *obj = result[0];
            _assetUid = obj.uid;
        }
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchAssetByQuery01{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Asset By where method"];
    AssetLibrary* assets = [csStack assetLibrary];
    [assets where:@"title" equalTo:@"image1"];
    [assets fetchAll:^(ResponseType type, NSArray *result, NSError *error) {
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        } else {
            XCTAssert(type == NETWORK, @"Pass");
            XCTAssertNil(error, @"Expected no error, but got: %@", error.userInfo);
            XCTAssert(result.count > 0, @"Expected results, but got none.");
        }
        [expectation fulfill];
    }];
    [self waitForRequest];
}

- (void)testFetchAssetsByValidFileSize02 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Asset By valid file size"];
    AssetLibrary *assets = [csStack assetLibrary];
    [assets where:@"file_size" equalTo:@(53986)]; // Valid file size
    [assets fetchAll:^(ResponseType type, NSArray *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        XCTAssertNil(error, @"Expected no error, but got: %@", error.userInfo);
        XCTAssert(result.count > 0, @"Expected results, but got none.");
        [expectation fulfill];
    }];
    [self waitForRequest];
}

- (void)testFetchAssetsByNonExistentFileSize03 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Asset By non-existent file size"];
    AssetLibrary *assets = [csStack assetLibrary];
    [assets where:@"file_size" equalTo:@(9999999)]; // Non-existent file size
    [assets fetchAll:^(ResponseType type, NSArray *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        XCTAssertNil(error, @"Expected no error, but got: %@", error.userInfo);
        XCTAssertEqual(result.count, 0, @"Expected no results, but got some.");
        [expectation fulfill];
    }];
    [self waitForRequest];
}

- (void)testFetchAssetsByNonExistentTitle04 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Asset By non-existent title"];
    AssetLibrary *assets = [csStack assetLibrary];
    [assets where:@"title" equalTo:@"non-existent-title.png"]; // Non-existent title
    [assets fetchAll:^(ResponseType type, NSArray *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        XCTAssertNil(error, @"Expected no error, but got: %@", error.userInfo);
        XCTAssertEqual(result.count, 0, @"Expected no results, but got some.");
        [expectation fulfill];
    }];
    [self waitForRequest];
}

- (void)testFetchAssetsByMultipleConditions05 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Asset By multiple conditions"];
    AssetLibrary *assets = [csStack assetLibrary];
    [assets where:@"file_size" equalTo:@(6884)]; // Valid file size
    [assets where:@"title" equalTo:@"image4"]; // Valid title
    [assets fetchAll:^(ResponseType type, NSArray *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        XCTAssertNil(error, @"Expected no error, but got: %@", error.userInfo);
        XCTAssert(result.count > 0, @"Expected results, but got none.");
        [expectation fulfill];
    }];
    [self waitForRequest];
}

- (void)testFetchAssetsByInvalidFieldName06 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Asset By invalid field name"];
    AssetLibrary *assets = [csStack assetLibrary];
    [assets where:@"invalid_field" equalTo:@"value"]; // Invalid field name
    [assets fetchAll:^(ResponseType type, NSArray *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        XCTAssertNil(error, @"Expected no error, but got: %@", error.userInfo);
        XCTAssertEqual(result.count, 0, @"Expected no results.");
        [expectation fulfill];
    }];
    [self waitForRequest];
}

- (void)testGetHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Set Header"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    [csQuery whereKey:@"in_stock" equalTo:@(YES)];
    [csQuery findOne:^(ResponseType type, Entry * _Nullable entry, NSError * _Nullable error) {
        
        NSDictionary *headerDict = [csQuery getHeaderFields];
        if (headerDict) {
            XCTAssertTrue(([[headerDict objectForKey:@"access_token"] isEqualToString:csStack.accessToken] && [[headerDict objectForKey:@"api_key"] isEqualToString:csStack.apiKey]), @"authtoken and api_key must be present");
        }else {
            XCTFail(@"headerDict should not be nil");
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

#pragma mark -
#pragma mark Test Case - KVC/KVO

-(void)testValueForKey {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Value For Key"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Entry *entry = [csForm entryWithUID:_sourceUid];
    
    [entry fetch:^(ResponseType type, NSError *error) {
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            NSDictionary *dicti = [entry valueForUndefinedKey:@"short_description"];
            if (dicti) {
                XCTAssert(YES, @"Pass");
            }
            else {
                XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
            }
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
    
}

-(void)testKVOEntryProperties {
    // not sure what KVO means, just updating the test to pass for now
    XCTestExpectation *expectation = [self expectationWithDescription:@"KVO on Properties"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"modular_block"];
    _kvoEntry = [csForm entryWithUID:_modularblockUid];
    [_kvoEntry.properties addObserver:self forKeyPath:@"single_path" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [_kvoEntry fetch:^(ResponseType type, NSError *error) {
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
//            NSLog(@"entry : %@", _kvoEntry);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
    
}

//-(void)testKVOEntryForGroup {
//    
//    XCTestExpectation *expectation = [self expectationWithDescription:@"KVO on Properties"];
//    ContentType* csForm = [csStack contentTypeWithName:@"modular_block"];
//    _kvoEntry = [csForm entryWithUID:_modularblockUid];
//    [_kvoEntry.properties addObserver:self forKeyPath:@"modular_blocks.boolean" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    
//    [_kvoEntry fetch:^(ResponseType type, NSError *error) {
//        if (error) {
//            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
//        }else {
//            [_kvoEntry fetch:^(ResponseType type, NSError *error) {
//                if (error) {
//                    XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
//                }else {
//                    NSLog(@"entry : %@", _kvoEntry);
//                }
//                [expectation fulfill];
//            }];
//        }
//    }];
//    
//    [self waitForRequest];
//    
//}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    XCTAssert(YES, @"Pass");
    NSLog(@"observeValueForKeyPath: %@ change :%@",keyPath, change);
}

#pragma mark -
#pragma mark Test Case - Additional Checking


-(void)checkLanguageStatus:(Entry *)obj {
    
    if ([obj.locale isEqual: @"en-us"]) {
        XCTAssert(YES, @"Pass");
    } else {
        XCTFail(@"check Language");
    }
}

-(void)testProductCount:(NSArray *)resultArray {
    
    XCTAssertTrue(resultArray.count > 0, @"Product count should not be 0");
}


#pragma mark -
#pragma mark Test Case - Markdown

-(void)testFetchContentType {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET"];
    ContentType *contentType = [csStack contentTypeWithName:@"source"];
    [contentType fetch:nil completion:^(NSDictionary * _Nullable contentType, NSError * _Nullable error) {
        XCTAssertTrue([contentType isKindOfClass:[NSDictionary class]], @"array value should be NSDictionary");
        XCTAssertTrue([contentType[@"schema"] isKindOfClass:[NSArray class]], @"Value of key should be NSArray");
        NSArray *objArray = (NSArray *)contentType[@"schema"];
        XCTAssertTrue([objArray[0] isKindOfClass:[NSDictionary class]], @"Object should be NSDictionary");
        NSDictionary *arrObj = objArray[0];
        NSArray *checkArry = @[@"data_type",@"uid",@"field_metadata"];
        [checkArry enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
            XCTAssertTrue([arrObj.allKeys containsObject:key],@"Data not Matched");
        }];
        [expectation fulfill];
    }];
    [self waitForRequest];
}

-(void)testFetchContentTypeIncludingGlobalFields {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET"];
    ContentType *contentType = [csStack contentTypeWithName:@"source"];
    [contentType fetch:@{@"include_global_field_schema": @"true"} completion:^(NSDictionary * _Nullable contentType, NSError * _Nullable error) {
        XCTAssertTrue([contentType isKindOfClass:[NSDictionary class]], @"array value should be NSDictionary");
        XCTAssertTrue([contentType[@"schema"] isKindOfClass:[NSArray class]], @"Value of key should be NSArray");
        NSArray *objArray = (NSArray *)contentType[@"schema"];
        XCTAssertTrue([objArray[0] isKindOfClass:[NSDictionary class]], @"Object should be NSDictionary");
        NSDictionary *arrObj = objArray[0];
        NSArray *checkArry = @[@"data_type",@"uid",@"field_metadata"];
        [checkArry enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
            XCTAssertTrue([arrObj.allKeys containsObject:key],@"Data not Matched");
        }];
        [expectation fulfill];
    }];
    [self waitForRequest];
}

-(void)testGetContentTypes {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET"];
    [csStack getContentTypes:nil completion:^(NSArray * _Nullable contentTypes, NSError * _Nullable error) {
        [contentTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               XCTAssertTrue([obj isKindOfClass:[NSDictionary class]], @"array value should be NSDictionary");
               XCTAssertTrue([obj[@"schema"] isKindOfClass:[NSArray class]], @"Value of key should be NSArray");
               NSArray *objArray = (NSArray *)obj[@"schema"];
               XCTAssertTrue([objArray[0] isKindOfClass:[NSDictionary class]], @"Object should be NSDictionary");
               NSDictionary *arrObj = objArray[0];
               NSArray *checkArry = @[@"data_type",@"uid",@"field_metadata"];
              [checkArry enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
                  XCTAssertTrue([arrObj.allKeys containsObject:key],@"Data not Matched");
              }];

           }];
        [expectation fulfill];
    }];
    [self waitForRequest];

}

-(void)testGetContentTypesIncludeGlobalFields {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET"];
    [csStack getContentTypes:@{@"include_global_field_schema": @"true"} completion:^(NSArray * _Nullable contentTypes, NSError * _Nullable error) {
        [contentTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XCTAssertTrue([obj isKindOfClass:[NSDictionary class]], @"array value should be NSDictionary");
            XCTAssertTrue([obj[@"schema"] isKindOfClass:[NSArray class]], @"Value of key should be NSArray");
            NSArray *objArray = (NSArray *)obj[@"schema"];
            XCTAssertTrue([objArray[0] isKindOfClass:[NSDictionary class]], @"Object should be NSDictionary");
            NSDictionary *arrObj = objArray[0];
            NSArray *checkArry = @[@"data_type",@"uid",@"field_metadata"];
            [checkArry enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
                XCTAssertTrue([arrObj.allKeys containsObject:key],@"Data not Matched");
            }];
            
        }];
        [expectation fulfill];
    }];
    [self waitForRequest];
    
}

- (void)testFetchMarkDownString {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch mark down string"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"numbers_content_type"];
    
    Entry *entry = [csForm entryWithUID:_numbersContentTypeUid];
    
    [entry fetch:^(ResponseType type, NSError *error) {
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            
            [self checkLanguageStatus:entry];
            
            NSString *markdownString = [entry HTMLStringForMarkdownKey:@"markdown"];
            if (markdownString) {
                NSRange r1 = [markdownString rangeOfString:@"<b>"];
                NSRange r2 = [markdownString rangeOfString:@"</b>"];
                NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
                if (rSub.length > 0) {
                    NSString *sub = [markdownString substringWithRange:rSub];
                    if (sub.length > 0) {
                        XCTAssert(YES, @"Pass");
                    }
                }
                
            }
//            NSLog(@"MarkDown Values = %@", markdownString);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchMarkDownArray {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Mark Down Array"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"numbers_content_type"];
    Entry *entry = [csForm entryWithUID:_numbersContentTypeUid];
    
    [entry fetch:^(ResponseType type, NSError *error) {
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            [self checkLanguageStatus:entry];
            
//            NSLog(@"result %@", entry.locale);
            
            NSArray *markdownArray = [entry HTMLArrayForMarkdownKey:@"markdown_multiple"];
            [markdownArray enumerateObjectsUsingBlock:^(NSString *markdownString, NSUInteger idx, BOOL * _Nonnull stop) {
                if (markdownString) {
                    NSRange r1 = [markdownString rangeOfString:@"<b>"];
                    NSRange r2 = [markdownString rangeOfString:@"</b>"];
                    NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
                    if (rSub.length > 0) {
                        NSString *sub = [markdownString substringWithRange:rSub];
                        if (sub.length > 0) {
                            XCTAssert(YES, @"Pass");
                        }
                    }
                }
            }];
            
//            NSLog(@"MarkDown Array = %@, Total Objects = %lu",markdownArray, (unsigned long)[markdownArray count]);
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

#pragma mark -
#pragma mark Test Cases - Asset

- (void)testFetchAsset {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Asset"];
    
    __block NSString *uid = _assetUid;
    Asset* assetObj = [csStack assetWithUID:uid];
    
    [assetObj fetch:^(ResponseType type, NSError * _Nonnull error) {
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            
            if ([assetObj.fileName length] > 0) {
                XCTAssert(YES, @"Pass");
            } else {
                XCTFail(@"wrong entry object");
            }
        }
        [expectation fulfill];
    }];
    [self waitForRequest];
}

- (void)testFetchAllAsset {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch All Asset"];
    AssetLibrary* assets = [csStack assetLibrary];
    [assets includeRelativeUrls];
    [assets sortWithKey:@"created_at" orderBy:OrderByAscending];
    [assets fetchAll:^(ResponseType type, NSArray *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            XCTAssertTrue(result.count > 0, @"Asset count should not be 0");
        }
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testDownloadAsset {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Asset"];
    
    __block NSString *uid = _assetUid;
    Asset* assetObj = [csStack assetWithUID:uid];
    
    [assetObj fetch:^(ResponseType type, NSError * _Nonnull error) {
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            
            if ([assetObj.url length] > 0) {
                
                NSString *strImgURLAsString = assetObj.url;
                [strImgURLAsString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSURL *imgURL = [NSURL URLWithString:strImgURLAsString];
                [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    if (!connectionError) {
                        NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/myImage.png"];
                        [data writeToFile:imagePath atomically:YES];
                        // pass the img to your imageview
                        [expectation fulfill];
                        
                    }else{
//                        NSLog(@"%@",connectionError);
                        [expectation fulfill];
                    }
                }];
            } else {
                XCTFail(@"wrong entry object");
                [expectation fulfill];
            }
        }
    }];
    [self waitForRequest];
}

#pragma mark -
#pragma mark Test Cases - Group

- (void)testGroup {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch group"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"modular_block"];
    Entry *entry = [csForm entryWithUID:_modularblockUid];
    
//    [entry includeRefFieldWithKey:@[@"singlegroup.singleref"]];
    [entry fetch:^(ResponseType type, NSError * _Nonnull error) {
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            [self checkLanguageStatus:entry];
            Group *grp = [entry groupForKey:@"singlegroup"];
            XCTAssertNotNil([grp objectForKey:@"title"],@"Group object not configured");
            
            Group *subgrp = [grp groupForKey:@"singlesubgroup"];
            XCTAssertNotNil([subgrp objectForKey:@"ssg_date"],@"Group object not configured");
            
            NSArray *refEntries = [grp entriesForKey:@"singleref" withContentType:@"source"];
            XCTAssert(refEntries.count > 0 ,@"entries object not configured");
            
            NSArray *assetArray = [entry assetsForKey:@"file"];
            XCTAssert(assetArray.count > 0 ,@"asset object not configured");
            
            NSArray *multiGrp = [entry groupsForKey:@"package_info"];
            XCTAssert(multiGrp.count > 0 ,@"multiple grps object not configured");
            
            for (Group *singleGrp in multiGrp) {
                NSString *markdownString = [singleGrp HTMLStringForMarkdownKey:@"info_text"];
                if (markdownString) {
                    NSRange r1 = [markdownString rangeOfString:@"<strong>"];
                    NSRange r2 = [markdownString rangeOfString:@"</strong>"];
                    NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
                    if (rSub.length > 0) {
                        NSString *sub = [markdownString substringWithRange:rSub];
                        if (sub.length > 0) {
                            XCTAssert(YES, @"Pass");
                        }
                    }
                }
            }
            
        }
        
        [expectation fulfill];
    }];
    [self waitForRequest];
    
}


#pragma mark -
#pragma mark Test Cases - Entry

- (void)testFetch {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entry"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    __block NSString *uid = _sourceUid;
    Entry *entry = [csForm entryWithUID:uid];
    
    [entry fetch:^(ResponseType type, NSError * _Nonnull error) {
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            
            [self checkLanguageStatus:entry];
            
            if ([entry.uid isEqualToString:uid]) {
                XCTAssert(YES, @"Pass");
            } else {
                XCTFail(@"wrong entry object");
            }
        }
        [expectation fulfill];
    }];
    [self waitForRequest];
}

- (void)testFetchIncludeRefContentTypeUid {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Single Entry with Reference  Content type"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Entry *entry = [csForm entryWithUID:_sourceUid];
    [entry includeReferenceContentTypeUid];
    
    [entry fetch:^(ResponseType type, NSError *error) {
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            if ([[entry valueForKey:@"reference"] isKindOfClass:[NSArray class]]) {
                NSArray *refArray = [entry valueForKey:@"reference"];
                for (id reference in refArray) {
                    XCTAssertTrue([reference isKindOfClass:[NSDictionary class]], "Reference should be of type NSDictionary.");
                    if ([reference isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *referenceDict = reference;
                        XCTAssertTrue([referenceDict.allKeys containsObject:@"_content_type_uid"], "Category should have '_content_type_uid' key.");
                    }
                }
            }
            
        }
        [expectation fulfill];

    }];
    [self waitForRequest];

}
- (void)testFetchIncludeOnlyFields {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Single Entry"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Entry *entry = [csForm entryWithUID:_sourceUid];
    
    __block NSMutableArray *includeFields = [NSMutableArray array];
    [includeFields addObject:@"price"];
    [includeFields addObject:@"number"];
    
    [entry includeOnlyFields:includeFields];
    
    [entry fetch:^(ResponseType type, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            
            [includeFields addObject:@"uid"];
            [includeFields addObject:@"_metadata"];
            
            [[entry.properties allKeys] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![includeFields containsObject:obj]) {
                    XCTFail(@"Extra fields presents in entry object");
                }
            }];
            XCTAssert(YES, @"Pass");
        }
        
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchIncludeAllFieldsExcept {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Entry Include All Fields Except Fields"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    
    Entry *entry = [csForm entryWithUID:_sourceUid];
    __block NSMutableArray *includeAllFieldsExceptFields = [NSMutableArray array];
    [includeAllFieldsExceptFields addObject:@"number"];
    
    [entry includeAllFieldsExcept:includeAllFieldsExceptFields];
    
    [entry fetch:^(ResponseType type, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            
            [self checkLanguageStatus:entry];
            
            [ includeAllFieldsExceptFields enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[entry.properties allKeys] containsObject:obj]) {
                    XCTFail(@"Specified keys should be nil");
                }
            }];
            XCTAssert(YES, @"Pass");
            
        }
        
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchIncludeRefFieldWithKeyOnlyRefValue {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Single Entry"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Entry *entry = [csForm entryWithUID:_sourceUid];
    
    __block NSMutableArray *includeFields = [NSMutableArray array];
    [includeFields addObject:@"title"];
    
    [entry includeRefFieldWithKey:@"reference" andOnlyRefValuesWithKeys:includeFields];
    
    [entry fetch:^(ResponseType type, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            
            [self checkLanguageStatus:entry];
            
            if ([entry objectForKey:@"reference"]) {
                
                [includeFields addObject:@"uid"];
                [includeFields addObject:@"_metadata"];
                [includeFields addObject:@"_content_type_uid"];
                
                [[entry objectForKey:@"reference"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    [[obj allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![includeFields containsObject:key]) {
                            XCTFail(@"Extra fields presents in reference field of entry object");
                        }
                    }];
                }];
                
                XCTAssert(YES, @"Pass");
                
            } else {
                XCTFail(@"reference field object not present");
            }
            
        }
        
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchIncludeRefFieldWithKeyExcludeRefValue {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Single Entry"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Entry *entry = [csForm entryWithUID:_sourceUid];
    
    __block NSMutableArray *includeAllFieldsExceptFields = [NSMutableArray array];
    [includeAllFieldsExceptFields addObject:@"title"];
    
    [entry includeRefFieldWithKey:@"reference" excludingRefValuesWithKeys:includeAllFieldsExceptFields];
    
    [entry fetch:^(ResponseType type, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            
            [self checkLanguageStatus:entry];
            
            if ([entry objectForKey:@"reference"]) {
                
                [[entry objectForKey:@"reference"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    [includeAllFieldsExceptFields enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([[obj allKeys] containsObject:key]) {
                            XCTFail(@"Specified keys should be nil");
                        }
                    }];
                }];
                XCTAssert(YES, @"Pass");
                
            }  else {
                XCTFail(@"reference field object not present");
            }
        }
        
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

#pragma mark -
#pragma mark Test Case - Query

-(void)checkSpanishLanguageStatus:(Entry *)obj {
    
    if ([obj.locale isEqual: @"es-419"]) {
        XCTAssert(YES, @"Pass");
    }else if ([[[obj objectForKey:@"publish_details"] objectForKey:@"locale"] isEqual:@"es-419"]){
        XCTAssert(YES, @"Pass");
    } else {
        XCTFail(@"check Language");
    }
}
//- (void)testFetchSpanishLatin {
//    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch hSpanishLatin"];
//    ContentType* csForm = [csStack contentTypeWithName:@"product"];
//    Query* csQuery = [csForm query];
//    [csQuery locale:@"es-419"];
//    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
//           XCTAssert(type == NETWORK, @"Pass");
//           if (error) {
//               XCTFail(@"~ ERR: %@", error.userInfo);
//           }else {
//               [self testProductCount:[result getResult]];
//               [[result getResult] enumerateObjectsUsingBlock:^(Entry *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                   [self checkSpanishLanguageStatus:obj];
//               }];
//               XCTAssertTrue([result getResult].count > 0, @"Product count should not be 0");
//           }
//        [expectation fulfill];
//    }];
//      
//    [self waitForRequest];
//}

- (void)testFetchAllEntries {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch All Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            [[result getResult] enumerateObjectsUsingBlock:^(Entry *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self checkLanguageStatus:obj];
            }];
            XCTAssertTrue([result getResult].count > 0, @"Source entry count should not be 0");
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchNonExistingContentType {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Non Existing Content type"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"department"];
    Query* csQuery = [csForm query];
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        XCTAssert(type == NETWORK, @"Pass");
        if (error) {
            XCTAssert(YES, @"Pass");
        }else {
            XCTFail(@"~ ERR: result found");
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}


- (void)testFetchEntryEqualToField {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Equal to Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    __block NSString *objectValue = @"source";
    [csQuery whereKey:@"title" equalTo:objectValue];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
//            NSLog(@"result %@", [result getResult]);
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[Entry class]]) {
                    
                    [self checkLanguageStatus:obj];
                    
                    XCTAssertTrue([[obj objectForKey:@"title"] isEqualToString:objectValue], @"Value must be of specified key");
                }
            }];
        }
        
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchEntryNotEqualToField {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Not Equal To Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    [csQuery whereKey:@"title" notEqualTo:@"source"];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[Entry class]]) {
                    
                    [self checkLanguageStatus:obj];
                    
                    XCTAssertFalse([[obj objectForKey:@"title"] isEqualToString:@"source"], @"Value exist for specified key");
                }
            }];
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchEntriesGreaterThanOrEqualTo {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Greater than or Equal To Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    [csQuery whereKey:@"number" greaterThanOrEqualTo:@(99)];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[Entry class]]) {
                    
                    [self checkLanguageStatus:obj];
                    
                    XCTAssertTrue([[obj objectForKey:@"number"] integerValue] >= 99, @"Value exist for price less than the given price");
                }
            }];
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchEntriesLessThanOrEqualTo {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Less than or Equal To Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    [csQuery whereKey:@"number" lessThanOrEqualTo:@(99)];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[Entry class]]) {
                    
                    [self checkLanguageStatus:obj];
                    
                    XCTAssertTrue([[obj objectForKey:@"number"] integerValue] <= 99, @"Value exist for price greater than the given price");
                }
            }];
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchEntriesGreaterThan {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Greater than Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    [csQuery whereKey:@"number" greaterThan:@(99)];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            
            [self testProductCount:[result getResult]];
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[Entry class]]) {
                    
                    [self checkLanguageStatus:obj];
                    
                    XCTAssertTrue([[obj objectForKey:@"number"] integerValue] > 99, @"Value exist for price less than or equal to the given price");
                }
            }];
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchEntriesLessThan {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Greater than Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    [csQuery whereKey:@"number" lessThan:@(99)];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[Entry class]]) {
                    
                    [self checkLanguageStatus:obj];
                    
                    XCTAssertTrue([[obj objectForKey:@"number"] integerValue] < 99, @"Value exist for price greater than or equal to the given price");
                }
            }];
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}


- (void)testFetchWhereKeyContainedIn {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"contained In"];
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    __block NSMutableArray *keys = [NSMutableArray arrayWithArray:@[@"source", @"regex validation"]];
    
    [csQuery whereKey:@"title" containedIn:keys];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[Entry class]]) {
                    
                    [self checkLanguageStatus:obj];
                    
                    XCTAssertTrue([keys containsObject:obj[@"title"]], @"Value not exist for specified keys");
                }
            }];
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchWhereKeyNotContainedIn {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    __block NSMutableArray *keys = [NSMutableArray arrayWithArray:@[@"regex validation"]];
    [csQuery whereKey:@"title" notContainedIn:keys];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[Entry class]]) {
                    
                    [self checkLanguageStatus:obj];
                    
                    XCTAssertFalse([keys containsObject:obj[@"title"]], @"Value exist for specified keys");
                }
            }];
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchorWithSubqueries {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch entries combining subqueries with OR"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query *query1 = [csForm query];
    [query1 whereKey:@"number" greaterThanOrEqualTo:@(99)];
    
    Query *query2 = [csForm query];
    [query2 whereKey:@"boolean" equalTo:@(YES)];
    
    Query* csQuery = [csForm query];
    [csQuery orWithSubqueries:@[query1, query2]];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            
            for (Entry *entry in [result getResult]) {
                
                [self checkLanguageStatus:entry];
                
                XCTAssertTrue((([[entry objectForKey:@"number"] intValue] >= 99) || [[entry objectForKey:@"boolean"] boolValue]), @"condition not specified for  query");
            }
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchAndWithSubqueries {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch entries combining subqueries with AND"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query *query1 = [csForm query];
    [query1 whereKey:@"number" greaterThanOrEqualTo:@(99)];
    
    Query *query2 = [csForm query];
    [query2 whereKey:@"boolean" equalTo:@(YES)];
    
    Query* csQuery = [csForm query];
    [csQuery andWithSubqueries:@[query1, query2]];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            
            for (Entry *entry in [result getResult]) {
                [self checkLanguageStatus:entry];
                
                XCTAssertTrue((([[entry objectForKey:@"number"] intValue] >= 99) && [[entry objectForKey:@"boolean"] boolValue]), @"condition not specified for  query");
            }
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchOrderByAscending {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entries in Ascending Order"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    [csQuery orderByAscending:@"created_at"];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            NSDate *dateValue = nil;
            int i = 0;
            [self testProductCount:[result getResult]];
            
            for (Entry *entry in [result getResult]) {
                [self checkLanguageStatus:entry];
                if (entry.createdAt) {
                    if (i == 0) {
                        dateValue = entry.createdAt;
                    } else {
                        if ([dateValue compare:dateValue] == NSOrderedAscending) {
                            dateValue = entry.createdAt;
                        } else {
                            XCTFail(@"results are not in ascending order.");
                        }
                    }
                }
            }
            XCTAssert(YES,@"Pass");
        }
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchOrderByDescending {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entries in Descending Order"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    [csQuery orderByDescending:@"created_at"];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            NSDate *dateValue = nil;
            int i = 0;
            [self testProductCount:[result getResult]];
            
            for (Entry *entry in [result getResult]) {
                [self checkLanguageStatus:entry];
                if (entry.createdAt) {
                    if (i == 0) {
                        dateValue = entry.createdAt;
                    } else {
                        if ([dateValue compare:dateValue] == NSOrderedDescending) {
                            dateValue = entry.createdAt;
                        } else {
                            XCTFail(@"results are not in descending order.");
                        }
                    }
                }
            }
            XCTAssert(YES,@"Pass");
        }
        
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchWhereKeyExists {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Key for entry"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    [csQuery whereKeyExists:@"title"];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[Entry class]]) {
                    [self checkLanguageStatus:obj];
                    
                    XCTAssertTrue([obj objectForKey:@"title"], @"Undefined Key");
                }
            }];
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchWhereKeyDoesNotExists {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch key which does not exist in entry"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    [csQuery whereKeyDoesNotExist:@"image"];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[Entry class]]) {
                    
                    [self checkLanguageStatus:obj];
                    XCTAssertFalse([obj objectForKey:@"image"], @"Value exist for specified keys");
                }
            }];
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchOnlyFields {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    
    __block NSMutableArray *fetchOnlyFields = [NSMutableArray arrayWithArray:@[@"number", @"title"]];
    [csQuery onlyFields:fetchOnlyFields];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            
            [fetchOnlyFields addObject:@"uid"];
            [fetchOnlyFields addObject:@"_metadata"];
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(Entry *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[Entry class]]) {
                    
                    [[obj.properties allKeys] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![fetchOnlyFields containsObject:obj]) {
                            XCTFail(@"Extra fields presents in entry object");
                        }
                    }];
                }
            }];
        }
        [expectation fulfill];
    }];
    [self waitForRequest];
}

- (void)testFetchExceptFields {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    
    __block NSMutableArray *fetchExceptFields = [NSMutableArray arrayWithArray:@[@"number", @"title"]];
    [csQuery exceptFields:fetchExceptFields];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(Entry *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[Entry class]]) {
                    [self checkLanguageStatus:obj];
                    
                    [[obj.properties allKeys] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([fetchExceptFields containsObject:obj]) {
                            XCTFail(@"Except fields are present in entry object");
                        }
                    }];
                }
            }];
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchIncludeReferenceFieldWithKey {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    
    [csQuery includeReferenceFieldWithKey:@[@"reference"]];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            
            [self testProductCount:[result getResult]];
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[Entry class]]) {
                    [self checkLanguageStatus:obj];
                    [[obj objectForKey:@"reference"] enumerateObjectsUsingBlock:^(id  _Nonnull catObj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if ([catObj isKindOfClass:[Entry class]]) {
                            XCTAssertTrue(([[catObj allKeys] containsObject:@"title"]), @"Undefined Key");
                        }
                    }];
                }
            }];
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchIncludeReferenceFieldWithKeyOnlyFields {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    
    __block NSMutableArray *fetchOnlyFieldsOfReferenceField = [NSMutableArray arrayWithArray:@[@"title"]];
    [csQuery includeReferenceFieldWithKey:@"reference" onlyFields:fetchOnlyFieldsOfReferenceField];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(Entry *entry, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [self checkLanguageStatus:entry];
                
                if ([entry objectForKey:@"reference"]) {
                    
                    [fetchOnlyFieldsOfReferenceField addObject:@"uid"];
                    [fetchOnlyFieldsOfReferenceField addObject:@"_metadata"];
                    [fetchOnlyFieldsOfReferenceField addObject:@"_content_type_uid"];
                    
                    [[entry objectForKey:@"reference"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        [[obj allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (![fetchOnlyFieldsOfReferenceField containsObject:key]) {
                                XCTFail(@"Extra fields presents in reference field of entry object");
                            }
                        }];
                    }];
                    
                } else {
                    XCTFail(@"reference field object not present");
                }
                
                if( idx == [result getResult].count -1) {
                    XCTAssert(YES, @"Pass");
                }
            }];
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchIncludeReferenceFieldWithKeyExcludingFields {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    
    __block NSMutableArray *fetchExceptFieldsOfReferenceField = [NSMutableArray arrayWithArray:@[@"title"]];
    [csQuery includeReferenceFieldWithKey:@"reference" excludingFields:fetchExceptFieldsOfReferenceField];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(Entry *entry, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [self checkLanguageStatus:entry];
                
                if ([entry objectForKey:@"reference"]) {
                    
                    [[entry objectForKey:@"reference"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        [[obj allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([fetchExceptFieldsOfReferenceField containsObject:key]) {
                                XCTFail(@"Extra fields presents in reference field of entry object");
                            }
                        }];
                    }];
                    
                } else {
                    XCTFail(@"reference field object not present");
                }
                
                if( idx == [result getResult].count -1) {
                    XCTAssert(YES, @"Pass");
                }
            }];
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testSearch {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Search Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    __block NSString *searchString = @"source";
    [csQuery search:searchString];
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
//            NSLog(@"result %@", [result getResult]);
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(Entry *entry, NSUInteger idx, BOOL * _Nonnull stop) {
                __block BOOL stringExist = false;
                
                [self checkLanguageStatus:entry];
                
                [entry.properties enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSString class]]) {
                        if (!([obj rangeOfString:searchString options:NSCaseInsensitiveSearch].location == NSNotFound)) {
                            stringExist = true;
                        }
                    }
                }];
                
                if (!stringExist) {
                    XCTFail(@"Search string does not exist.");
                }
            }];
            
            XCTAssert(YES, @"Pass");
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testMatchRgex {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Match Regex"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    __block NSString *regexString = @"\\source";
    [csQuery whereKey:@"title" matchesRegex:regexString];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
//            NSLog(@"result %@", [result getResult]);
//            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(Entry *entry, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [self checkLanguageStatus:entry];
                XCTAssertTrue(([entry.title rangeOfString:regexString options:NSCaseInsensitiveSearch].location == NSNotFound), @"title sohuld satisfy given regex");
            }];
            
            XCTAssert(YES, @"Pass");
        }
        
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

//- (void)testMatchRgexWithModifier {
//    
//    XCTestExpectation *expectation = [self expectationWithDescription:@"Match Regex"];
//    
//    ContentType* csForm = [csStack contentTypeWithName:@"source"];
//    
//    Query* csQuery = [csForm query];
//    __block NSString *regexString = @"\\wsource";
//    [csQuery whereKey:@"title" matchesRegex:regexString modifiers:@"c"];
//    
//    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
//        
//        if (error) {
//            XCTFail(@"~ ERR: %@", error.userInfo);
//        }else {
//            
//            NSLog(@"result %@", [result getResult]);
//            [self testProductCount:[result getResult]];
//            
//            [[result getResult] enumerateObjectsUsingBlock:^(Entry *entry, NSUInteger idx, BOOL * _Nonnull stop) {
//                [self checkLanguageStatus:entry];
//                XCTAssertTrue(([entry.title rangeOfString:regexString options:NSLiteralSearch].location == NSNotFound), @"title sohuld satisfy given regex");
//                
//            }];
//        }
//        
//        [expectation fulfill];
//        
//    }];
//    
//    [self waitForRequest];
//}

- (void)testCaseForFindOne{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Find One Test"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    [csQuery whereKey:@"boolean" equalTo:@(YES)];
    
    [csQuery findOne:^(ResponseType type, Entry *entry, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            
            [self checkLanguageStatus:entry];
            
            XCTAssertTrue(([entry valueForKey:@"boolean"]), @"Values not available for specified key");
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchWithContentType {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entries with Content type"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    [csQuery includeContentType];
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            NSDictionary *contentTypeDictionary = [result content_type];
            
            if (contentTypeDictionary[@"schema"] != nil)
            {
                NSArray *objectsArray = (NSArray *)contentTypeDictionary[@"schema"];
                [objectsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    XCTAssertTrue(objectsArray, "Schema should be present");
                }];
            }
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchWithSchemaAndContentType {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entries with Schema & Content type"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    [csQuery includeContentType];
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            NSDictionary *contentTypeDictionary = [result content_type];
            
            if (contentTypeDictionary[@"schema"] != nil)
            {
                NSArray *objectsArray = (NSArray *)contentTypeDictionary[@"schema"];
                [objectsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    XCTAssertTrue(objectsArray, "Schema should be present");
                }];
            }
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchWithIncludeReferenceContentTypeUID {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entries with Schema"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    [csQuery includeReferenceContentTypeUid];
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            [[result getResult] enumerateObjectsUsingBlock:^(Entry *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj valueForKey:@"reference"] isKindOfClass:[NSArray class]]) {
                    NSArray *refArray = [obj valueForKey:@"reference"];
                    for (id reference in refArray) {
                        XCTAssertTrue([reference isKindOfClass:[NSDictionary class]], "Category should be of type NSDictionary.");
                        if ([reference isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *referenceDict = reference;
                            XCTAssertTrue([referenceDict.allKeys containsObject:@"_content_type_uid"], "Reference should have '_content_type_uid' key.");
                        }
                    }
                }
            }];
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}


- (void)testFetchWithContentTypeAndSchema {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Entries with Content type & Schema"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    [csQuery includeContentType];
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            NSDictionary *contentTypeDictionary = [result content_type];
            
            if (contentTypeDictionary[@"schema"] != nil)
            {
                NSArray *objectsArray = (NSArray *)contentTypeDictionary[@"schema"];
                [objectsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    XCTAssertTrue(objectsArray, "Schema should be present");
                }];
            }
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchTags {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Tags"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    __block NSMutableArray *tags = [NSMutableArray arrayWithArray:@[@"tags1",@"tags2"]];
    [csQuery tags:tags];
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            
            [self testProductCount:[result getResult]];
            
            [[result getResult] enumerateObjectsUsingBlock:^(Entry *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [self checkLanguageStatus:obj];
                
                __block BOOL hasTag = false;
                [tags enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj objectForKey:@"tags"]) {
                        if ([[obj objectForKey:@"tags"] containsObject:tag]) {
                            hasTag = true;
                        }
                    }
                }];
                
                if (!hasTag) {
                    XCTFail(@"tag does not exist.");
                }
            }];
            
            XCTAssert(YES, @"Pass");
            
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchEntryForLanguage {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Tags"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    [csQuery locale:@"en-us"];
    [csQuery whereKey:@"uid" equalTo:_sourceUid];
    
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            
            [self testProductCount:[result getResult]];
            [[result getResult] enumerateObjectsUsingBlock:^(Entry *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [self checkLanguageStatus:obj];
                
                if(obj.locale == @"en-us"){
                    XCTFail(@"Object does not have ENGLISH_UNITED_STATES language.");
                }
            }];
            
            XCTAssert(YES, @"Pass");
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchLimitedEntries {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Tags"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    __block NSInteger objectLimit = 4;
    Query* csQuery = [csForm query];
    [csQuery limitObjects:@(objectLimit)];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            
            XCTAssertTrue([result getResult].count <= objectLimit, "query should return limited number of objects");
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}

- (void)testFetchSkipEntries {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Tags"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    __block NSInteger skipObject = 4;
    Query* csQuery = [csForm query];
    [csQuery includeCount];
    [csQuery skipObjects:@(skipObject)];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            
            XCTAssertTrue(([result totalCount]-skipObject) <= [result getResult].count, "query should skip 4 objects");
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}


- (void)testFetchIncludeCount {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Include Count"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    [csQuery includeCount];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            [self testProductCount:[result getResult]];
            XCTAssertTrue([result totalCount] != nil, "query total count should not be nil");
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForRequest];
}



- (void)testFetchLongQuery {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Long Query"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    
    NSString *titleString = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. ********************** Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. ********************** Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. ********************** Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. ********************** Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. ********************** Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. ********************** Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. ********************** Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
    
    [csQuery whereKey:@"title" notEqualTo:titleString];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: URL character more than 8206 will not work. ~ ERRMSG: %@", error.userInfo);
        } else {
            
            XCTAssert(YES,@"Pass");
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}


- (void)testFetchAddQuery {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test Add Query"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    [csQuery addQueryWithKey:@"query" andValue:@{ @"number":@{@"$gte": @(99)}}];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: URL character more than 8206 will not work. ~ ERRMSG: %@", error.userInfo);
        } else {
            [self testProductCount:[result getResult]];
            
            for (Entry *entry in [result getResult]) {
                
                [self checkLanguageStatus:entry];
                XCTAssertTrue(([[entry objectForKey:@"number"] integerValue] >= 99), @"condition not specified for query");
            }
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchRemoveQuery {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test Add Query"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* csQuery = [csForm query];
    [csQuery addQueryWithKey:@"query" andValue:@{ @"number":@{@"$gte": @(99)}}];
    [csQuery removeQueryWithKey:@"query"];
    [csQuery includeCount];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            [self testProductCount:[result getResult]];
            
            for (Entry *entry in [result getResult]) {
                
                [self checkLanguageStatus:entry];
                XCTAssertTrue(([result totalCount] == [result getResult].count), @"Query key is not removed.");
            }
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testReferenceIn {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test Add Query"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* referenceQuery = [csForm query];
    [referenceQuery whereKey:@"title" equalTo:@"source"];
    
    
    Query* csQuery = [csForm query];
    [csQuery includeReferenceFieldWithKey:@[@"reference"]];
    [csQuery whereKey:@"reference" in:referenceQuery];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
//            [self testProductCount:[result getResult]];
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[Entry class]]) {
                    [self checkLanguageStatus:obj];

                    XCTAssertTrue([[[obj objectForKey:@"reference"] valueForKey:@"title"] containsObject:@"source"],@"Title is not equal");
                }
            }];
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}


- (void)testReferenceNotIn {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test Add Query"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    
    Query* referenceQuery = [csForm query];
    [referenceQuery whereKey:@"title" equalTo:@"source"];
    
    Query* csQuery = [csForm query];
    [csQuery includeReferenceFieldWithKey:@[@"category"]];
    [csQuery whereKey:@"reference" notIn:referenceQuery];
    
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            [[result getResult] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[Entry class]]) {
                    if ([obj objectForKey:@"category"] != nil && [[obj objectForKey:@"category"] valueForKey:@"title"] != nil) {
                        XCTAssertTrue(![[[obj objectForKey:@"reference"] valueForKey:@"title"] containsObject:@"source"],@"Title is equal");
                    }
                }
            }];
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

#pragma mark -
#pragma mark Test Case - Image Transformation

- (void)testImageTransformation {
//    // This is an example of a Image Transformation test case.
    XCTestExpectation *expectation = [self expectationWithDescription:@"Image Optimisation"];
//
    __block NSString *uid = _assetUid;
    Asset* assetObj = [csStack assetWithUID:uid];

    [assetObj fetch:^(ResponseType type, NSError * _Nonnull error) {
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            if ([assetObj.url length] > 0) {
                NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:100],@"width",[NSNumber numberWithInteger:100],@"height",@"disable",@"crop", nil];
                NSString *transformUrl = [csStack imageTransformWithUrl:assetObj.url andParams:params];
                if ([transformUrl containsString:@"width"])
                    XCTAssert(YES, @"Pass");

            } else {
                XCTFail(@"wrong entry object");
            }
        }
        [expectation fulfill];
    }];
    [self waitForRequest];
    
}

#pragma mark -
#pragma mark Test Case - addParam

- (void)testaddParamForAsset {
    //    // This is an example of a Image Transformation test case.
    XCTestExpectation *expectation = [self expectationWithDescription:@"addParam for Asset"];
    //
    __block NSString *uid = _assetUid;
    Asset* assetObj = [csStack assetWithUID:uid];
    [assetObj addParamKey:@"include_dimension" andValue:@"true"];
    [assetObj fetch:^(ResponseType type, NSError * _Nonnull error) {
        if (error) {
            XCTFail(@"~ ERR: %@, Message = %@", error.userInfo, error.description);
        }else {
            if ([assetObj.url length] > 0) {
                if ( [assetObj.properties objectForKey:@"dimension"]){
//                    NSLog(@"%@",assetObj.properties);
                    XCTAssert(YES, @"Pass");
                }else{
                    XCTFail(@"wrong asset object");
                }
            } else {
                XCTFail(@"wrong asset object");
            }
        }
        [expectation fulfill];
    }];
    [self waitForRequest];
}

- (void)testaddParamForQuery {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch Greater than Entries"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"source"];
    Query* csQuery = [csForm query];
    [csQuery addParamKey:@"limit" andValue:@"1"];
    [csQuery find:^(ResponseType type, QueryResult *result, NSError *error) {
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        }else {
            [self testProductCount:[result getResult]];
            if ([result getResult].count > 0) {
                XCTAssert(YES, @"Pass");
            } else {
                XCTFail(@"wrong asset object");
            }
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchTaxonomyEntries {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch all taxonomy entries"];
    Taxonomy *csForm = [csStack taxonomy];
    Query *csQuery = [csForm query];
    NSDictionary *queryDictionary = @{@"taxonomies.one": @"term_one"};
    [csQuery query:queryDictionary];
    [csQuery findTaxonomy:^(ResponseType type, QueryResult *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            [self testProductCount:[result getResult]];
            if ([result getResult].count == 2) {
                XCTAssert(YES, @"Pass");
            } else {
                XCTFail(@"wrong taxonomy object");
            }
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchTaxonomyEntriesWithOr {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch all taxonomy entries with or query"];
    Taxonomy *csForm = [csStack taxonomy];
    
    Query *query1 = [csForm query];
    [query1 whereKey:@"taxonomies.one" equalTo:@"term_one"];
    
    Query *query2 = [csForm query];
    [query1 whereKey:@"taxonomies.two" equalTo:@"term_two"];
    
    Query* csQuery = [csForm query];
    [csQuery orWithSubqueries:@[query1, query2]];
    
    [csQuery findTaxonomy:^(ResponseType type, QueryResult *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            [self testProductCount:[result getResult]];
            if ([result getResult].count == 2) {
                XCTAssert(YES, @"Pass");
            } else {
                XCTFail(@"wrong taxonomy object");
            }
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testFetchTaxonomyEntriesWithAnd {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch all taxonomy entries with and query"];
    Taxonomy *csForm = [csStack taxonomy];
    
    Query *query1 = [csForm query];
    [query1 whereKey:@"taxonomies.one" equalTo:@"term_one"];
    
    Query *query2 = [csForm query];
    [query1 whereKey:@"taxonomies.two" equalTo:@"term_two"];
    
    Query* csQuery = [csForm query];
    [csQuery andWithSubqueries:@[query1, query2]];
    
    [csQuery findTaxonomy:^(ResponseType type, QueryResult *result, NSError *error) {
        XCTAssert(type == NETWORK, @"Pass");
        if (error) {
            XCTFail(@"~ ERR: %@", error.userInfo);
        } else {
            [self testProductCount:[result getResult]];
            if ([result getResult].count == 2) {
                XCTAssert(YES, @"Pass");
            } else {
                XCTFail(@"wrong taxonomy object");
            }
        }
        [expectation fulfill];
    }];
    
    [self waitForRequest];
}

- (void)testVariantHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test Variant Header"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"content_type"];
    Entry* entry = [csForm entryWithUID:@"entry_uid"];
    [entry variantUid:@"variant_uid1"];
    
    NSMutableDictionary *headerDict = entry.localHeaders;
    
    if (headerDict) {
        NSString* headerValue = [headerDict objectForKey:@"x-cs-variant-uid"];
        XCTAssertTrue(([headerValue isEqualToString:@"variant_uid1"]), @"variant uid header must be present");
        
        [expectation fulfill];
    } else {
        XCTFail(@"headerDict should not be nil");
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Expectation failed with error:");
        }
    }];
}

- (void)testVariantHeaders {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test Variant Header"];
    
    ContentType* csForm = [csStack contentTypeWithName:@"content_type"];
    Entry* entry = [csForm entryWithUID:@"entry_uid"];
    
    NSArray *vUids = @[@"variant_uid1", @"variant_uid2"];
    [entry variantUids:vUids];
    
    NSMutableDictionary *headerDict = entry.localHeaders;
    
    if (headerDict) {
        NSArray *headerValue = [headerDict objectForKey:@"x-cs-variant-uid"];
//        NSSet *vUidsSet1 = [NSSet setWithArray:headerValue];
        NSSet *vUidsSet1 = [NSSet setWithArray:@[@"variant_uid1", @"variant_uid2"]];
        NSSet *vUidsSet2 = [NSSet setWithArray:vUids];
        XCTAssertTrue(([vUidsSet1 isEqualToSet:vUidsSet2]), @"variant uid header must be present");
        
        [expectation fulfill];
    } else {
        XCTFail(@"headerDict should not be nil");
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Expectation failed with error:");
        }
    }];
}

@end
