//
//  CSIOConstants.h
//  contentstack
//
//  Created by Reefaq on 13/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSIOConstants : NSObject

FOUNDATION_EXPORT NSString *const kCSIO_ApiVersion;
FOUNDATION_EXPORT NSString *const kCSIO_DefaultHost;
FOUNDATION_EXPORT BOOL const kCSIO_DefaultHostSSL;

FOUNDATION_EXPORT NSString *const kCSIO_HTTPGET;
FOUNDATION_EXPORT NSString *const kCSIO_HTTPPOST;
FOUNDATION_EXPORT NSString *const kCSIO_HTTPPUT;
FOUNDATION_EXPORT NSString *const kCSIO_HTTPDELETE;
FOUNDATION_EXPORT NSString *const kCSIO_HTTPMethod;

FOUNDATION_EXPORT NSString *const kCSIO_Authtoken;
FOUNDATION_EXPORT NSString *const kCSIO_Accesstoken;

FOUNDATION_EXPORT NSString *const kCSIO_Queryable;
FOUNDATION_EXPORT NSString *const kCSIO_Include;
FOUNDATION_EXPORT NSString *const kCSIO_Exists;
FOUNDATION_EXPORT NSString *const kCSIO_Ascending;
FOUNDATION_EXPORT NSString *const kCSIO_Descending;
FOUNDATION_EXPORT NSString *const kCSIO_Only;
FOUNDATION_EXPORT NSString *const kCSIO_BASE;
FOUNDATION_EXPORT NSString *const kCSIO_Except;
FOUNDATION_EXPORT NSString *const kCSIO_Delta;
FOUNDATION_EXPORT NSString *const kCSIO_ALL;
FOUNDATION_EXPORT NSString *const kCSIO_QueryAnd;
FOUNDATION_EXPORT NSString *const kCSIO_QueryOr;
FOUNDATION_EXPORT NSString *const kCSIO_InQuery;
FOUNDATION_EXPORT NSString *const kCSIO_NotInQuery;
FOUNDATION_EXPORT NSString *const kCSIO_Owner;
FOUNDATION_EXPORT NSString *const kCSIO_Typeahead;
// Query
FOUNDATION_EXPORT NSString *const kCSIO_NotEqualTo;
FOUNDATION_EXPORT NSString *const kCSIO_LessThan;
FOUNDATION_EXPORT NSString *const kCSIO_GreaterThanEqualTo;
FOUNDATION_EXPORT NSString *const kCSIO_LessThanEqualTo;
FOUNDATION_EXPORT NSString *const kCSIO_GreaterThan;
FOUNDATION_EXPORT NSString *const kCSIO_ContainedIn;
FOUNDATION_EXPORT NSString *const kCSIO_NotContainedIn;
FOUNDATION_EXPORT NSString *const kCSIO_Select;
FOUNDATION_EXPORT NSString *const kCSIO_ClassUID;
FOUNDATION_EXPORT NSString *const kCSIO_FieldKey;
FOUNDATION_EXPORT NSString *const kCSIO_DontSelect;
FOUNDATION_EXPORT NSString *const kCSIO_Regex;
FOUNDATION_EXPORT NSString *const kCSIO_Options;
FOUNDATION_EXPORT NSString *const kCSIO_IncludeSchema;
FOUNDATION_EXPORT NSString *const kCSIO_IncludeContentType;
FOUNDATION_EXPORT NSString *const kCSIO_IncludeCount;
FOUNDATION_EXPORT NSString *const kCSIO_IncludeUnpublished;
FOUNDATION_EXPORT NSString *const kCSIO_BeforeUID;
FOUNDATION_EXPORT NSString *const kCSIO_AfterUID;
FOUNDATION_EXPORT NSString *const kCSIO_Limit;
FOUNDATION_EXPORT NSString *const kCSIO_Skip;
FOUNDATION_EXPORT NSString *const kCSIO_Count;
FOUNDATION_EXPORT NSString *const kCSIO_Schema;

// site
FOUNDATION_EXPORT NSString *const kCSIO_SiteApiKey;
FOUNDATION_EXPORT NSString *const kCSIO_Environment;
FOUNDATION_EXPORT NSString *const kCSIO_EnvironmentUID;
FOUNDATION_EXPORT NSString *const kCSIO_ContentTypeUID;

// Entry
FOUNDATION_EXPORT NSString *const kCSIO_EntryUID;
FOUNDATION_EXPORT NSString *const kCSIO_Metadata;
FOUNDATION_EXPORT NSString *const kCSIO_Entry;
FOUNDATION_EXPORT NSString *const kCSIO_Entries;
FOUNDATION_EXPORT NSString *const kCSIO_UID;
FOUNDATION_EXPORT NSString *const kCSIO_Tags;
FOUNDATION_EXPORT NSString *const kCSIO_True;
FOUNDATION_EXPORT NSString *const kCSIO_PUSH;
FOUNDATION_EXPORT NSString *const kCSIO_PULL;
FOUNDATION_EXPORT NSString *const kCSIO_WHERE;
FOUNDATION_EXPORT NSString *const kCSIO_UPSERT;
FOUNDATION_EXPORT NSString *const kCSIO_UPDATE;
FOUNDATION_EXPORT NSString *const kCSIO_ADD;
FOUNDATION_EXPORT NSString *const kCSIO_SUB;
FOUNDATION_EXPORT NSString *const kCSIO_MUL;
FOUNDATION_EXPORT NSString *const kCSIO_DIV;
FOUNDATION_EXPORT NSString *const kCSIO_Data;
FOUNDATION_EXPORT NSString *const kCSIO_Index;
FOUNDATION_EXPORT NSString *const kCSIO_False;
FOUNDATION_EXPORT NSString *const kCSIO_ACL;
FOUNDATION_EXPORT NSString *const kCSIO_Published;
FOUNDATION_EXPORT NSString *const kCSIO_IncludeUser;
FOUNDATION_EXPORT NSString *const kCSIO_Locale;
FOUNDATION_EXPORT NSString *const kCSIO_CreatedBy;
FOUNDATION_EXPORT NSString *const kCSIO_UpdatedBy;
FOUNDATION_EXPORT NSString *const kCSIO_DeletedBy;
FOUNDATION_EXPORT NSString *const kCSIO_URL;
FOUNDATION_EXPORT NSString *const kCSIO_Title;
FOUNDATION_EXPORT NSString *const kCSIO_Schema;

// Asset
FOUNDATION_EXPORT NSString *const kCSIO_Upload;
FOUNDATION_EXPORT NSString *const kCSIO_Uploads;
FOUNDATION_EXPORT NSString *const kCSIO_FileSize;
FOUNDATION_EXPORT NSString *const kCSIO_FileName;
FOUNDATION_EXPORT NSString *const kCSIO_ContentType;
FOUNDATION_EXPORT NSString *const kCSIO_RelativeUrls;


FOUNDATION_EXPORT NSString *const kCSIO_CreatedAt;
FOUNDATION_EXPORT NSString *const kCSIO_UpdatedAt;
FOUNDATION_EXPORT NSString *const kCSIO_DeletedAt;

//sync
FOUNDATION_EXPORT NSString *const kCSIO_Init;
FOUNDATION_EXPORT NSString *const kCSIO_Start_From;
FOUNDATION_EXPORT NSString *const kCSIO_Pagination_Token;
FOUNDATION_EXPORT NSString *const kCSIO_Sync_Token;
FOUNDATION_EXPORT NSString *const kCSIO_Content_Type;
FOUNDATION_EXPORT NSString *const kCSIO_Type;
FOUNDATION_EXPORT NSString *const kCSIO_Items;

@end
