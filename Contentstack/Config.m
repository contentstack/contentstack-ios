//
//  Config.m
//  Contentstack
//
//  Created by Priyanka Mistry on 01/06/16.
//  Copyright © 2016 Contentstack. All rights reserved.
//

#import <Contentstack/Config.h>
#import "CSIOConstants.h"
#import "NSObject+Extensions.h"
@implementation Config
-(instancetype)init {
    self = [super init];
    if (self) {
        _region = US;
        _host = @"cdn.contentstack.io";
        _version = kCSIO_ApiVersion;
        _setEarlyAccess = nil;
    }
    return self;
}
- (void)setRegion:(ContentstackRegion)region {
    _region = region;
    // Always update host when region changes and notify observers
    _host = [self hostURL:_region];  // Update host based on region
}

- (NSDictionary<NSString *, NSString *> *)earlyAccessHeaders {
    if (_setEarlyAccess.count > 0) {
        NSString *earlyAccessString = [_setEarlyAccess componentsJoinedByString:@","];
        return @{@"x-header-ea": earlyAccessString};
    }
    return @{};
}
@end
