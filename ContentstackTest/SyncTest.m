

//
//  SyncTest.m
//  ContentstackTest
//
//  Created by Uttam Ukkoji on 04/07/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

#import <Contentstack/Contentstack.h>
#import <XCTest/XCTest.h>

static NSInteger kRequestTimeOutInSeconds = 60;
static NSString *syncToken = @"";

@interface SyncTest : XCTestCase {
    Stack *csStack;
    Config *config;
    CGFloat count;
    NSDateFormatter *formatter;
}
@end

@implementation SyncTest

- (void)setUp {
    [super setUp];
    config = [[Config alloc] init];
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"config" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    config.host = dict[@"host"];
    csStack = [Contentstack stackWithAPIKey:dict[@"api_key"] accessToken:dict[@"delivery_token"] environmentName:dict[@"environment"] config:config];
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:SSSSSZ";
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

- (void)testSync {
    count = 0;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Sync"];
    [csStack sync:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
        count += syncStack.items.count;
        if (syncStack.syncToken != nil) {
            syncToken = syncStack.syncToken;
            XCTAssertEqual(syncStack.totalCount, count);
            [expectation fulfill];
        }
    }];
    
    [self waitForRequest];
}

- (void)testSyncToken {
    count = 0;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Sync"];
    [csStack syncToken:syncToken completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
        count += syncStack.items.count;
        if (syncStack.syncToken != nil) {
            XCTAssertEqual(syncStack.totalCount, syncStack.totalCount);
            [expectation fulfill];
        }
    }];
    [self waitForRequest];
}

- (void)testSyncFromDate {
    XCTestExpectation *expectation = [self expectationWithDescription:@"SyncFromDate"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1534617000];
    
    [csStack syncFrom:date completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
        for (NSDictionary *item in syncStack.items) {
            if ([[item objectForKey:@"event_at"] isKindOfClass:[NSString class]]) {
                NSDate *daatee = [formatter dateFromString:[[item objectForKey:@"event_at"] stringByReplacingOccurrencesOfString:@"." withString:@""]];
                XCTAssertLessThanOrEqual(date.timeIntervalSince1970, daatee.timeIntervalSince1970);
            }
        }
        if (syncStack.syncToken != nil) {
            [expectation fulfill];
        }
            
        }];
    [self waitForRequest];
}

- (void)testSyncPublishType {
    XCTestExpectation *expectation = [self expectationWithDescription:@"SyncPublishType"];
    [csStack syncPublishType:(ENTRY_DELETED) completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
        for (NSDictionary *item in syncStack.items) {
            if ([[item objectForKey:@"type"] isKindOfClass:[NSString class]]) {
                XCTAssertTrue([[item objectForKey:@"type"] isEqualToString:@"entry_deleted"]);
            }
        }
        if (syncStack.syncToken != nil) {
            [expectation fulfill];
        }

    }];
    [self waitForRequest];
}

- (void)testSyncOnlyClass {
    XCTestExpectation *expectation = [self expectationWithDescription:@"SyncOnlyClass"];
    [csStack syncOnly:@"product" completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
        for (NSDictionary *item in syncStack.items) {
            if ([[item objectForKey:@"content_type_uid"] isKindOfClass:[NSString class]]) {
                XCTAssertTrue([[item objectForKey:@"content_type_uid"] isEqualToString:@"product"]);
            }
        }
        if (syncStack.syncToken != nil) {
            [expectation fulfill];
        }    }];
    [self waitForRequest];
}

-(void)testSyncOnlyWithLocale {
    XCTestExpectation *expectation = [self expectationWithDescription:@"SyncOnlyWithLocale"];
    [csStack syncOnly:@"product" locale:@"en-us" from:nil completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
        for (NSDictionary *item in syncStack.items) {
            if ([[item objectForKey:@"content_type_uid"] isKindOfClass:[NSString class]]) {
                XCTAssertTrue([[item objectForKey:@"content_type_uid"] isEqualToString:@"product"]);
            }
            if ([[item objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = [item objectForKey:@"data"];
                if ([data valueForKeyPath:@"publish_details.locale"] != nil && [[data objectForKey:@"publish_details.locale"] isKindOfClass:[NSString class]]) {
                    XCTAssertTrue([[data objectForKey:@"publish_details.locale"] isEqualToString:@"en-us" ]);
                }
            }
        }
        if (syncStack.syncToken != nil) {
            [expectation fulfill];
        }
    }];
    [self waitForRequest];
}

- (void)testSyncOnlyClassAndDate {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1534617000];

    XCTestExpectation *expectation = [self expectationWithDescription:@"SyncOnlyClassAndDate"];
    [csStack syncOnly:@"product" from:date completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
        for (NSDictionary *item in syncStack.items) {
            if ([[item objectForKey:@"content_type_uid"] isKindOfClass:[NSString class]]) {
                XCTAssertTrue([[item objectForKey:@"content_type_uid"] isEqualToString:@"product"]);
            }
            if ([[item objectForKey:@"event_at"] isKindOfClass:[NSString class]]) {
                NSDate *daatee = [formatter dateFromString:[[item objectForKey:@"event_at"] stringByReplacingOccurrencesOfString:@"." withString:@""]];
                XCTAssertLessThanOrEqual(date.timeIntervalSince1970, daatee.timeIntervalSince1970);
            }
        }
        if (syncStack.syncToken != nil) {
            [expectation fulfill];
        }    }];
    [self waitForRequest];
}

-(void)testSyncLocal {
    XCTestExpectation *expectation = [self expectationWithDescription:@"SyncLocal"];
    [csStack syncLocale:@"en-us" completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
        for (NSDictionary *item in syncStack.items) {
            if ([[item objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = [item objectForKey:@"data"];
                if ([data valueForKeyPath:@"publish_details.locale"] != nil && [[data objectForKey:@"publish_details.locale"] isKindOfClass:[NSString class]]) {
                    XCTAssertTrue([[data objectForKey:@"publish_details.locale"] isEqualToString:@"en-us" ]);
                }
            }
        }
        if (syncStack.syncToken != nil) {
            [expectation fulfill];
        }
    }];
    [self waitForRequest];
}


-(void)testSyncLocaleWithDate {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1534617000];

    XCTestExpectation *expectation = [self expectationWithDescription:@"SyncLocaleWithDate"];
    [csStack syncLocale:@"en-us" from:date completion:^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
        for (NSDictionary *item in syncStack.items) {
            if ([[item objectForKey:@"event_at"] isKindOfClass:[NSString class]]) {
                NSDate *daatee = [formatter dateFromString:[[item objectForKey:@"event_at"] stringByReplacingOccurrencesOfString:@"." withString:@""]];
                XCTAssertLessThanOrEqual(date.timeIntervalSince1970, daatee.timeIntervalSince1970);
            }
            if ([[item objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = [item objectForKey:@"data"];
                if ([data objectForKey:@"publish_details.locale"] != nil && [[data objectForKey:@"publish_details.locale"] isKindOfClass:[NSString class]]) {
                    XCTAssertTrue([[data objectForKey:@"publish_details.locale"] isEqualToString:@"en-us" ]);
                }
            }
        }
        if (syncStack.syncToken != nil) {
            [expectation fulfill];
        }
    }];
    [self waitForRequest];
}



@end
