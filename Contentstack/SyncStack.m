//
//  SyncStack.m
//  ThirdPartyExtension
//
//  Created by Uttam Ukkoji on 02/07/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

#import "SyncStack.h"
#import "CSIOInternalHeaders.h"
@implementation SyncStack

-(instancetype)initWithParmas:(NSDictionary*) parmas {
    self = [super init];
    if (self) {
        self.params = parmas;
        if ([[self.params objectForKey:@"sync_token"] isKindOfClass:[NSString class]]) {
            self.syncToken = [self.params objectForKey:@"sync_token"];
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
            /* For existing persisted data sync token will be deleted. Seq Id will be generated for sync with the help of event_at field.
            */
            if ([dictionary objectForKey:@"items"] && [[dictionary objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
                NSMutableArray * items = [NSMutableArray array];
                items = [dictionary objectForKey:@"items"];
                if (items.count > 0) {
                    self.syncToken = nil;
                    self.seqId = [self generateSeqId:[dictionary objectForKey:@"event_at"]];
                } else {
                    self.syncToken = [dictionary objectForKey:@"sync_token"];
                }
            } else {
                self.syncToken = [dictionary objectForKey:@"sync_token"];
            }
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
    return @"65c217c4c1ac8a3f43218d2f";
}
@end
