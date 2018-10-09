//
//  CSIOConstants.m
//  contentstack
//
//  Created by Reefaq on 13/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#import "CSIOConstants.h"

@implementation CSIOConstants

NSString *const kCSIO_ApiVersion = @"v3";
NSString *const kCSIO_DefaultHost =  @"cdn.contentstack.io";
BOOL const kCSIO_DefaultHostSSL =  YES;


NSString *const kCSIO_HTTPGET = @"GET";
NSString *const kCSIO_HTTPPOST = @"POST";
NSString *const kCSIO_HTTPPUT = @"PUT";
NSString *const kCSIO_HTTPDELETE = @"DELETE";
NSString *const kCSIO_HTTPMethod = @"_method";

NSString *const kCSIO_Authtoken = @"authtoken";
NSString *const kCSIO_Accesstoken = @"access_token";

//Query
NSString *const kCSIO_Queryable = @"query";
NSString *const kCSIO_Include = @"include";
NSString *const kCSIO_Exists = @"$exists";
NSString *const kCSIO_Ascending = @"asc";
NSString *const kCSIO_Descending = @"desc";
NSString *const kCSIO_Only = @"only";
NSString *const kCSIO_BASE = @"BASE";
NSString *const kCSIO_Except = @"except";
NSString *const kCSIO_Delta = @"delta";
NSString *const kCSIO_ALL = @"ALL";
NSString *const kCSIO_QueryAnd = @"$and";
NSString *const kCSIO_QueryOr = @"$or";
NSString *const kCSIO_InQuery = @"$in_query";
NSString *const kCSIO_NotInQuery = @"$nin_query";
NSString *const kCSIO_Typeahead = @"typeahead";
//query
NSString *const kCSIO_NotEqualTo = @"$ne";
NSString *const kCSIO_LessThan = @"$lt";
NSString *const kCSIO_GreaterThanEqualTo = @"$gte";
NSString *const kCSIO_LessThanEqualTo = @"$lte";
NSString *const kCSIO_GreaterThan = @"$gt";
NSString *const kCSIO_ContainedIn = @"$in";
NSString *const kCSIO_NotContainedIn = @"$nin";
NSString *const kCSIO_Select = @"$select";
NSString *const kCSIO_ClassUID = @"class_uid";
NSString *const kCSIO_FieldKey = @"key";
NSString *const kCSIO_DontSelect = @"$dont_select";
NSString *const kCSIO_Regex = @"$regex";
NSString *const kCSIO_Options = @"$options";
NSString *const kCSIO_Owner = @"_owner";

//include
NSString *const kCSIO_IncludeSchema = @"include_schema";
NSString *const kCSIO_IncludeContentType = @"include_content_type";
NSString *const kCSIO_IncludeCount = @"include_count";
NSString *const kCSIO_IncludeUnpublished = @"include_unpublished";
//
NSString *const kCSIO_BeforeUID = @"before_uid";
NSString *const kCSIO_AfterUID = @"after_uid";
NSString *const kCSIO_Limit = @"limit";
NSString *const kCSIO_Skip = @"skip";
NSString *const kCSIO_Count = @"count";

//Site
NSString *const kCSIO_SiteApiKey = @"api_key";
NSString *const kCSIO_Environment = @"environment";
NSString *const kCSIO_EnvironmentUID = @"environment_uid";

//Form
NSString *const kCSIO_ContentTypeUID = @"form_uid";

//Entry
NSString *const kCSIO_EntryUID = @"entry_uid";
NSString *const kCSIO_Metadata = @"_metadata";
NSString *const kCSIO_Entry = @"entry";
NSString *const kCSIO_Entries = @"entries";
NSString *const kCSIO_UID = @"uid";
NSString *const kCSIO_Tags = @"tags";
NSString *const kCSIO_True = @"true";
NSString *const kCSIO_False = @"false";
NSString *const kCSIO_PUSH = @"PUSH";
NSString *const kCSIO_PULL = @"PULL";
NSString *const kCSIO_WHERE = @"WHERE";
NSString *const kCSIO_UPSERT = @"UPSERT";
NSString *const kCSIO_UPDATE = @"UPDATE";
NSString *const kCSIO_ADD = @"ADD";
NSString *const kCSIO_SUB = @"SUB";
NSString *const kCSIO_MUL = @"MUL";
NSString *const kCSIO_DIV = @"DIV";
NSString *const kCSIO_Data = @"data";
NSString *const kCSIO_Index = @"index";
NSString *const kCSIO_ACL = @"ACL";
NSString *const kCSIO_Published = @"published";
NSString *const kCSIO_IncludeUser = @"include_owner";
NSString *const kCSIO_Locale = @"locale";
NSString *const kCSIO_CreatedBy = @"created_by";
NSString *const kCSIO_UpdatedBy = @"updated_by";
NSString *const kCSIO_DeletedBy = @"deleted_by";
NSString *const kCSIO_URL = @"url";
NSString *const kCSIO_Title = @"title";
NSString *const kCSIO_Schema = @"schema";

//Asset
NSString *const kCSIO_Upload = @"asset";
NSString *const kCSIO_Uploads = @"assets";
NSString *const kCSIO_FileName = @"filename";
NSString *const kCSIO_FileSize = @"file_size";
NSString *const kCSIO_ContentType = @"content_type";
NSString *const kCSIO_RelativeUrls = @"relative_urls";


NSString *const kCSIO_CreatedAt = @"created_at";
NSString *const kCSIO_UpdatedAt = @"updated_at";
NSString *const kCSIO_DeletedAt = @"deleted_at";

//sync
NSString *const kCSIO_Init = @"init";
NSString *const kCSIO_Start_From = @"start_from";
NSString *const kCSIO_Pagination_Token = @"pagination_token";
NSString *const kCSIO_Sync_Token = @"sync_token";
NSString *const kCSIO_Content_Type = @"content_type_uid";
NSString *const kCSIO_Items = @"items";
NSString *const kCSIO_Type = @"type";

@end
