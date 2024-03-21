//
//  CSIOInternalHeaders.h
//  contentstack
//
//  Created by Reefaq on 15/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import "CSIOCoreNetworkingProtocol.h"
#import "Contentstack.h"
#import "SyncStack.h"
#import <Contentstack/Stack.h>
#import "Query.h"
#import "ContentType.h"
#import "Entry.h"
#import "Asset.h"
#import "QueryResult.h"
#import "ISO8601DateFormatter.h"
#import "Common.h"
#import "CSIOConstants.h"
#import <Contentstack/Config.h>
#import "AssetLibrary.h"
#import "Group.h"
#import "CSError.h"


//MARK: Extensions -

@interface Stack ()
@property (nonatomic, copy) NSString *hostURL;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, strong) NSMutableDictionary *stackHeaders;
@property (nonatomic, strong) NSObject<CSIOCoreNetworkingProtocol> *network;
@property (nonatomic, strong) ISO8601DateFormatter *commonDateFormatter;
@property (nonatomic, strong) NSMutableSet *requestOperationSet;

- (instancetype)initWithAPIKey:(NSString*)apiKey andaccessToken:(NSString *)accessToken andEnvironment:(NSString*)environment andConfig:(Config *)sConfig;
@end

@interface Contentstack()
+ (Contentstack *)sharedInstance;
@end


@interface Query ()
@property (nonatomic, assign) BOOL shouldFetchFromNetwork;
@property (nonatomic, strong) ContentType *contentType;
- (instancetype)initWithContentType:(ContentType *)contentType;
@property (nonatomic, strong) NSMutableDictionary *queryDictionary;

@end

@interface QueryResult ()
- (instancetype)initWithContentType:(ContentType *)contentType objectDictionary:(NSDictionary*)dictionary;
@property (nonatomic, strong) ContentType *contentType;
@end

@interface ContentType ()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableDictionary *headers;
@property (nonatomic, strong) NSMutableDictionary *postParamDictionary;

-(instancetype)initWithStack:(Stack *)stack withName:(NSString*)contentTypeName;
-(Entry *)entry;
-(Stack *)stack;
@end

@interface Entry ()
@property (nonatomic, assign, getter=isDeleted) BOOL deleted;
@property (nonatomic, strong) ContentType *contentType;
@property (nonatomic, strong) NSMutableDictionary *postParamDictionary;
- (instancetype)initWithContentType:(ContentType *)contentType;
- (instancetype)initWithContentType:(ContentType *)contentType withEntryUID:(NSString*)uid;

@end
@interface Asset ()
- (instancetype)initWithStack:(Stack *)stack;
- (instancetype)initWithStack:(Stack *)stack withAssetUID:(NSString*)assetUID;
@property (nonatomic, strong) NSMutableDictionary *postParamDictionary;

@end

@interface AssetLibrary ()
- (instancetype)initWithStack:(Stack *)stack;
@property (nonatomic, strong) NSMutableDictionary *postParamDictionary;
@end

@interface Group ()
- (void)configureWithDictionary:(NSDictionary*)dictionary;
- (instancetype)initWithStack:(Stack *)stack;
- (instancetype)initWithStack:(Stack *)stack andField:(NSString*)field;

@end


@interface SyncStack ()
-(instancetype)initWithParmas:(NSDictionary*) parmas;
-(void)parseSyncResult:(NSDictionary*) dictionary;
-(NSDictionary*)getParameters;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) NSString *paginationToken;
@property (nonatomic, copy) NSString *syncToken;

@property (nonatomic, assign) BOOL hasMorePages;
@property (nonatomic, assign) unsigned int skip;
@property (nonatomic, assign) unsigned int limit;
@property (nonatomic, assign) unsigned int totalCount;
@property (nonatomic, strong) NSDictionary *params;


@end

@interface CSError ()
+(instancetype)error:(NSDictionary*) errorDictionary statusCode:(NSInteger) statusCode;

@end
