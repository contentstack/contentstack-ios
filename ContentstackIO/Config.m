//
//  Config.m
//  Contentstack
//
//  Created by Priyanka Mistry on 01/06/16.
//  Copyright © 2016 Contentstack. All rights reserved.
//

#import "Config.h"
#import "CSIOConstants.h"

@implementation Config
-(instancetype)init {
    self = [super init];
    if (self) {
        _host = kCSIO_DefaultHost;
        _isSSL = kCSIO_DefaultHostSSL;
        _version = kCSIO_ApiVersion;        
    }
    return self;
}

@end
