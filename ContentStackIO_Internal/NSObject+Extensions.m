//
//  NSObject+Extensions.m
//  Contentstack
//
//  Created by Reefaq on 13/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import "NSObject+Extensions.h"

@implementation NSObject (Extensions)

- (NSArray*)networkErrorCodes
{
    static NSArray *codesArray;
    if (![codesArray count]) {
        @synchronized(self) {
            const int codes[] = {
                kCFURLErrorCannotConnectToHost,     //-1004
                kCFURLErrorNetworkConnectionLost,   //-1005
                kCFURLErrorDNSLookupFailed,         //-1006
                kCFURLErrorResourceUnavailable,     //-1008
                kCFURLErrorNotConnectedToInternet,  //-1009
                kCFURLErrorBadServerResponse,               //-1011
                kCFURLErrorInternationalRoamingOff, //-1018
                kCFURLErrorCallIsActive,                //-1019
                kCFURLErrorFileDoesNotExist,            //-1100
                kCFURLErrorNoPermissionsToReadFile,     //-1102
            };
            int size = sizeof(codes)/sizeof(int);
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0;i<size;++i) {
                [array addObject:[NSNumber numberWithInt:codes[i]]];
            }
            codesArray = [array copy];
        }
    }
    return codesArray;
}

-(NSArray*)localeCodes{
    static NSArray* localeCodes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localeCodes = @[@"af-za",
                        @"sq-al",
                        @"ar-dz",
                        @"ar-bh",
                        @"ar-eg",
                        @"ar-iq",
                        @"ar-jo",
                        @"ar-kw",
                        @"ar-lb",
                        @"ar-ly",
                        @"ar-ma",
                        @"ar-om",
                        @"ar-qa",
                        @"ar-sa",
                        @"ar-sy",
                        @"ar-tn",
                        @"ar-ae",
                        @"ar-ye",
                        @"hy-am",
                        @"cy-az-az",
                        @"lt-az-az",
                        @"eu-es",
                        @"be-by",
                        @"bg-bg",
                        @"ca-es",
                        @"zh-cn",
                        @"zh-hk",
                        @"zh-mo",
                        @"zh-sg",
                        @"zh-tw",
                        @"zh-chs",
                        @"zh-cht",
                        @"hr-hr",
                        @"cs-cz",
                        @"da-dk",
                        @"div-mv",
                        @"nl-be",
                        @"nl-nl",
                        @"en-au",
                        @"en-bz",
                        @"en-ca",
                        @"en-cb",
                        @"en-ie",
                        @"en-jm",
                        @"en-nz",
                        @"en-ph",
                        @"en-za",
                        @"en-tt",
                        @"en-gb",
                        @"en-us",
                        @"en-zw",
                        @"et-ee",
                        @"fo-fo",
                        @"fa-ir",
                        @"fi-fi",
                        @"fr-be",
                        @"fr-ca",
                        @"fr-fr",
                        @"fr-lu",
                        @"fr-mc",
                        @"fr-ch",
                        @"gl-es",
                        @"ka-ge",
                        @"de-at",
                        @"de-de",
                        @"de-li",
                        @"de-lu",
                        @"de-ch",
                        @"el-gr",
                        @"gu-in",
                        @"he-il",
                        @"hi-in",
                        @"hu-hu",
                        @"is-is",
                        @"id-id",
                        @"it-it",
                        @"it-ch",
                        @"ja-jp",
                        @"kn-in",
                        @"kk-kz",
                        @"kok-in",
                        @"ko-kr",
                        @"ky-kz",
                        @"lv-lv",
                        @"lt-lt",
                        @"mk-mk",
                        @"ms-bn",
                        @"ms-my",
                        @"mr-in",
                        @"mn-mn",
                        @"nb-no",
                        @"nn-no",
                        @"pl-pl",
                        @"pt-br",
                        @"pt-pt",
                        @"pa-in",
                        @"ro-ro",
                        @"ru-ru",
                        @"sa-in",
                        @"cy-sr-sp",
                        @"lt-sr-sp",
                        @"sk-sk",
                        @"sl-si",
                        @"es-ar",
                        @"es-bo",
                        @"es-cl",
                        @"es-co",
                        @"es-cr",
                        @"es-do",
                        @"es-ec",
                        @"es-sv",
                        @"es-gt",
                        @"es-hn",
                        @"es-mx",
                        @"es-ni",
                        @"es-pa",
                        @"es-py",
                        @"es-pe",
                        @"es-pr",
                        @"es-es",
                        @"es-uy",
                        @"es-ve",
                        @"sw-ke",
                        @"sv-fi",
                        @"sv-se",
                        @"syr-sy",
                        @"ta-in",
                        @"tt-ru",
                        @"te-in",
                        @"th-th",
                        @"tr-tr",
                        @"uk-ua",
                        @"ur-pk",
                        @"cy-uz-uz",
                        @"lt-uz-uz",
                        @"vi-vn"];
    });
    
    return localeCodes;
}

-(NSString*)localeCode:(NSUInteger)locale {
    return [self localeCodes][locale];
}

-(NSUInteger)indexOfLocaleCodeString:(NSString*)locale {
    return [[self localeCodes] indexOfObject:locale];
}

-(NSArray*)publishTypes {
    static NSArray* publishTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        publishTypes = @[@"asset_published",
                         @"entry_published",
                         @"asset_unpublished",
                         @"entry_unpublished",
                         @"asset_deleted",
                         @"entry_deleted",
                         @"content_type_deleted"];
    });
    return publishTypes;
}

-(NSString*)publishType:(NSUInteger)publishType {
    return [self publishTypes][publishType];
}

- (void)assertPropertyTypes:(NSDictionary *)properties {
    for (id k in properties.allKeys) {
        NSAssert([k isKindOfClass: [NSString class]], @"%@ property keys must be NSString. got: %@ %@", self, [k class], k);
        // would be convenient to do: id v = [properties objectForKey:k]; ..but, when the NSAssert's are stripped out in release, it becomes an unused variable error
        id object = [properties objectForKey:k];

        NSAssert([object isKindOfClass:[NSString class]] ||
                 [object isKindOfClass:[NSNumber class]] ||
                 [object isKindOfClass:[NSNull class]] ||
                 [object isKindOfClass:[NSArray class]] ||
                 [object isKindOfClass:[NSDictionary class]] ||
                 [object isKindOfClass:[NSDate class]] ||
                 [object isKindOfClass:[NSURL class]],
                 @"%@ property values must be NSString, NSNumber, NSNull, NSArray, NSDictionary, NSDate or NSURL. got: %@ %@", self, [object class], object);
    }
}

- (NSDictionary *)dictionaryFromJSONData:(NSData *)data {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return dict;
}

- (NSData *)jsonDataFromDictonary:(NSDictionary *)dict {
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    return JSONData;
}

- (NSString *)jsonStringFromDictonary:(NSDictionary *)dict {
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
}

- (NSArray *)arrayFromJSONData:(NSData *)data {
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return array;
}

- (NSString *)jsonStringFromArray:(NSArray*)array {
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:array options:0 error:NULL];
    return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
}


//MARK: Perform and Wait block

+ (void)performAndWait:(void (^)(dispatch_semaphore_t semaphore))perform{
    NSParameterAssert(perform);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    perform(semaphore);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

@end
