//
//  CSIOAPIURLs.m
//  Contentstack
//
//  Created by Reefaq on 13/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import "CSIOAPIURLs.h"
#import "CSIOConstants.h"

@implementation CSIOAPIURLs

//MARK: URLs -

// Query
static NSString *fetchContentTypeEntriesQuery = @"/%@/content_types/%@/entries";
// Entry
static NSString *fetchEntry = @"/%@/content_types/%@/entries/%@";
// Asset
static NSString *fetchAsset = @"/%@/assets/%@";
// AssetLibrary
static NSString *fetchAssetLibrary = @"/%@/assets";
//stack
static NSString *fetchLastActivity = @"/%@/content_types";
// stack
static NSString *fetchSchema = @"/%@/content_types";
// Content Type
static NSString *fetchContentTypeSchema = @"/%@/content_types/%@";
// sync
static NSString *syncData = @"/%@/stacks/sync";
// Taxonomy
static NSString *fetchTaxonomyWithVersion = @"/%@/taxonomies/entries";
//GlobalField
static NSString *fetchGlobalFieldWithVersion = @"/%@/global_fields/%@";
//GlobalFields
static NSString *findGlobalFieldsWithVersion = @"/%@/global_fields";


//MARK: Methods -

//stack
+(NSString *)fetchSchemaWithVersion:(NSString*)version {
    return [NSString stringWithFormat:fetchSchema,version];
}

//stack
+(NSString *)fetchContenTypeSchema:(NSString*)contentTypeUID withVersion:(NSString*)version {
    return [NSString stringWithFormat:fetchContentTypeSchema, version, contentTypeUID];
}

//Taxonomy
+(NSString *)fetchTaxonomyWithVersion:(NSString*)version {
    return [NSString stringWithFormat:fetchTaxonomyWithVersion, version];
}

//Query
+(NSString *)fetchContentTypeEntriesQueryURLWithUID:(NSString *)contentTypeUID withVersion:(NSString*)version{
    return [NSString stringWithFormat:fetchContentTypeEntriesQuery,version,contentTypeUID];
}

//Entry
+ (NSString *)fetchEntryURLWithContentTypeUID:(NSString *)contentTypeUID entryUID:(NSString*)entryUID withVersion:(NSString*)version; {
    return [NSString stringWithFormat:fetchEntry,version,contentTypeUID,entryUID];
}

+ (NSString *)fetchContentTypeSchemaQueryURLWithVersion:(NSString *)version {
    return [NSString stringWithFormat:fetchLastActivity,version];
}

//Asset
+ (NSString *)fetchAssetWithUID:(NSString*)assetUID withVersion:(NSString*)version  {
    return [NSString stringWithFormat:fetchAsset,version,assetUID];
}

//AssetLibrary
+ (NSString *)fetchAssetLibraryWithVersion:(NSString*)version{
    return [NSString stringWithFormat:fetchAssetLibrary,version];
}

//sync
+(NSString *)syncWithVersion:(NSString*)version {
    return [NSString stringWithFormat:syncData,version];
}

+(NSString*)fetchGlobalFieldWithVersion:(NSString*)globalFieldUID withVersion:(NSString*)version {
    return [NSString stringWithFormat:fetchGlobalFieldWithVersion, version, globalFieldUID];
}

+(NSString*)findGlobalFieldsWithVersion:(NSString*)version {
    return [NSString stringWithFormat:findGlobalFieldsWithVersion, version];
}
@end
