//
//  SyncStack.m
//  ThirdPartyExtension
//
//  Created by Uttam Ukkoji on 02/07/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

#import "SyncStack.h"
#import "CSIOInternalHeaders.h"
#import "BSONObjectIdGenerator.h"

@implementation SyncStack

-(instancetype)initWithParmas:(NSDictionary*) parmas {
    self = [super init];
    if (self) {
        self.params = parmas;
        if ([[self.params objectForKey:@"sync_token"] isKindOfClass:[NSString class]]) {
            self.syncToken = [self.params objectForKey:@"sync_token"];
        }
        if ([[self.params objectForKey:@"seq_id"]
             isKindOfClass:[NSString
                            class]]) {
            self.seqId = [self.params objectForKey:@"seq_id"];
        }
        self.items = [NSArray array];
    }
    return self;
}

-(void)parseSyncResult:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSNull class]]) {
        self.syncToken = nil;
        self.paginationToken = nil;
        self.hasMorePages = false;
        
        if ([dictionary objectForKey:@"sync_token"]) {
            /* For existing persisted data sync token should be set to nil. Seq Id will be generated for sync with the help of event_at field.
            */
            [self setExistingTokensNilAndGenerateSeqId:@"sync_token" dict:dictionary];
        }
        
        if ([dictionary objectForKey:@"last_seq_id"]) {
            self.seqId = [dictionary objectForKey:@"last_seq_id"];
        }
        if ([dictionary objectForKey:@"pagination_token"]) {
            self.hasMorePages = true;
            self.paginationToken = [dictionary objectForKey:@"pagination_token"];
        }
        if ([dictionary objectForKey:@"total_count"]) {
            self.totalCount = [[dictionary objectForKey:@"total_count"] unsignedIntValue];
        }
        if ([dictionary objectForKey:@"skip"] != nil && [[dictionary objectForKey:@"skip"] isKindOfClass:[NSNumber class]]){
            self.skip = [[dictionary objectForKey:@"skip"] unsignedIntValue];
        }
        if ([dictionary objectForKey:@"limit"] != nil && [[dictionary objectForKey:@"limit"] isKindOfClass:[NSNumber class]]){
            self.limit = [[dictionary objectForKey:@"limit"] unsignedIntValue];
        }
        if ([dictionary objectForKey:@"items"] && [[dictionary objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
            self.items = [dictionary objectForKey:@"items"];
            if (self.items.count > 0) {
                self.hasMorePages = true;
            }
        }
    }
}

-(NSDictionary*)getParameters {
    NSMutableDictionary *syncParams = [NSMutableDictionary dictionary];
    if (self.seqId != nil) {
        [syncParams setValue:self.seqId forKey:@"seq_id"];
    } else if (self.syncToken != nil) {
        [syncParams setValue:self.syncToken forKey:@"sync_token"];
    } else if (self.paginationToken != nil) {
        [syncParams setValue:self.paginationToken forKey:@"pagination_token"];
    } else {
        syncParams = [NSMutableDictionary dictionaryWithDictionary:self.params];
        [syncParams setValue:@"true" forKey:@"seq_id"];
        [syncParams setValue:@"true" forKey:@"init"];
    }
    return syncParams;
}

-(NSString*)generateSeqId:(NSString*) eventAt {
    // Create a date formatter to parse the date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDate *date = [dateFormatter dateFromString:eventAt];
    if (date) {
        // Convert the NSDate object to an NSTimeInterval
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        NSInteger timeIntervalInSeconds = (NSInteger)timeInterval;

        return [BSONObjectIdGenerator generate:timeIntervalInSeconds];
    } else {
        // Handle case where date conversion failed.
        [NSException raise:@"Unable to parse date string" format:@"Invalid date format %@", eventAt];
        return nil;
    }
}

-(void)setExistingTokensNilAndGenerateSeqId:(NSString *) key dict:(NSDictionary *)dictionary {
    NSMutableArray * items = [NSMutableArray array];
    items = [dictionary objectForKey: @"items"];
    if ([items isKindOfClass:[NSArray class]] && items.count > 0) {
        // Get the last object's event_at
        NSDictionary *lastObject = nil;
        for (NSInteger i = items.count - 1; i >= 0; i--) {
            id object = items[i];
            if ([object isKindOfClass:[NSDictionary class]]) {
                lastObject = object;
                break;
            }
        }
        self.seqId = [self generateSeqId:[lastObject objectForKey:@"event_at"]];
    } else {
        if ([key isEqual: @"sync_token"]) {
            self.syncToken = [dictionary objectForKey:@"sync_token"];
        } else {
            self.paginationToken = [dictionary objectForKey:@"pagination_token"];
        }
    }
}

@end
