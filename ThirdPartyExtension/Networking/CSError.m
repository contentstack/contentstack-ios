//
//  CSError.m
//  Contentstack
//
//  Created by Uttam Ukkoji on 24/10/19.
//  Copyright © 2019 Contentstack. All rights reserved.
//

#import "CSError.h"

@interface CSError ()
@property (readwrite, nonatomic, strong) NSString *errorMessage;
@property (readwrite, nonatomic, strong) NSDictionary *errorInfo;
@property (readwrite, nonatomic) NSInteger errorCode;
@property (readwrite, nonatomic) NSInteger statusCode;
@end

@implementation CSError

+(instancetype)error:(NSDictionary *)errorDictionary statusCode:(NSInteger)statusCode {
     return [[[self class] alloc] initWitherror:(NSDictionary *)errorDictionary statusCode:(NSInteger)statusCode];
}

-(instancetype)initWitherror:(NSDictionary *)errorDictionary statusCode:(NSInteger)statusCode {
    self = [super initWithDomain:@"contentstack" code:statusCode userInfo:errorDictionary];
     if (self) {
         self.statusCode = statusCode;
         if ([errorDictionary valueForKey:@"error_message"] && ![[errorDictionary valueForKey:@"error_message"] isKindOfClass:[NSNull class]]) {
             self.errorMessage = [errorDictionary valueForKey:@"error_message"];
         }
         if ([errorDictionary valueForKey:@"error_code"] && ![[errorDictionary valueForKey:@"error_code"] isKindOfClass:[NSNull class]] && [[errorDictionary valueForKey:@"error_code"] integerValue]) {
             self.errorCode = [[errorDictionary valueForKey:@"error_code"] integerValue];
         }
         if ([errorDictionary valueForKey:@"errors"] && ![[errorDictionary valueForKey:@"errors"] isKindOfClass:[NSNull class]]) {
             self.errorInfo = [errorDictionary valueForKey:@"errors"];
         }
     }
    return self;
}
@end
