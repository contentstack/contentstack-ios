//
//  Common.h
//  Userful Macro
//
//  Created by Reefaq on 06/12/12.
//  Copyright (c) 2012 Reefaq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// App Information
#define AppName                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
#define AppVersion              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define AppBuildVersion              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

// OS Information
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v    options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//Hardware Information
#define IS_WIDESCREEN                               (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE                                   ([[[UIDevice currentDevice] model ] rangeOfString:@"iPhone"].length>0)
#define IS_IPOD                                     ([[[UIDevice currentDevice]model] rangeOfString:@"iPod"].length>0)
#define IS_IPAD                                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE_5                                 (!IS_IPAD && IS_WIDESCREEN)

#define ACTUAL_SCREEN_RESOLUTION                           (CGSizeMake([[UIScreen mainScreen]bounds].size.width * [[UIScreen mainScreen] scale], [[UIScreen mainScreen]bounds].size.height * [[UIScreen mainScreen] scale]))


/* key, observer, object */
#define ObserveValue(key, observer, objectToObserve) [(objectToObserve) addObserver:observer forKeyPath:key options:NSKeyValueObservingOptionOld context:nil];
#define StopObserveValue(key, observer, objectToObserve) [(objectToObserve) removeObserver:observer forKeyPath:key context:nil];


// User Interface Related

#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#endif

#ifndef RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#endif

#ifndef HSVCOLOR
#define HSVCOLOR(h,s,v) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
#endif

#ifndef HSVACOLOR
#define HSVACOLOR(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]
#endif

#ifndef RGBA
#define RGBA(r,g,b,a) (r)/255.0, (g)/255.0, (b)/255.0, (a)
#endif

#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define SetNetworkActivityIndicator(x)      [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define IsNetworkActivityIndicatorVisible      [UIApplication sharedApplication].networkActivityIndicatorVisible

#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif

#define DEFINE_CLASS_CONST(name, value) NSString* const name = value

#define DECLARE_CLASS_CONST(name) extern NSString* const name

#if defined(__COREFOUNDATION_CFURL__)
#define URL_ENCODE(string) (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) string, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);

#define URL_DECODE(string) (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef) string, CFSTR(""), kCFStringEncodingUTF8);
#endif

static inline BOOL isEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}
