### Version: 3.6.0
#### Date: Jul-29-2019

##### New Features:
- Query
   - added method 'includeReferenceContentTypeUid'
   - added method 'locale'
- Entry
   - added method 'includeReferenceContentTypeUid'
   - added method 'includeContentType'
   - added method 'locale'
   
##### API deprecation:
- Query
   - deprecated method 'language'
- Entry
   - deprecated method 'language'
   
##### API removed:
- Config
   - removed property attribute 'ssl'
   - removed method 'includeSchema'
- Stack
   - removed property attribute 'ssl'

### Version: 3.5.0
#### Date: Apr-12-2019

##### API deprecation:
- Config
   - removed property attribute 'ssl'
- Stack
   - removed property attribute 'ssl'

##### New Features:
- Stack
  - added method 'getContentTypes:'
- ContentType
  - added method 'fetch:'
  
##### 
### Version: 3.4.0
#### Date: Oct-22-2018

##### New Features:
- Stack
  - added method 'sync:'
  - added method 'syncToken:completion:'
  - aded method 'syncPaginationToken:completion:'
  - added method 'syncFrom:completion:'
  - added method 'syncOnly:completion:'
  - added method 'syncOnly:from:completion:'
  - added method 'syncLocale:completion:'
  - added method 'syncLocale:from:completion:'
  - added method 'syncPublishType:completion:'
  - added method 'syncOnly:locale:from:completion:'
  - added method 'syncOnly:locale:from:publishType:completion:'

- SyncStack
  - Added New Class

### Version: 3.3.1
#### Date: Jun-08-2018
##### Change:

- Added string 'BUILT_NULLABLE_P' in Entry.h
  - Old Code - (void)fetch:(void(^)(ResponseType type, NSError *error))callback;
  - Updated Code - (void)fetch:(void(^)(ResponseType type, NSError * BUILT_NULLABLE_P error))callback;

### Version: 3.3.0
#### Date: Dec-15-2017

##### New Features:

- Entry
  - added method ‘addParamKey:andValue:’

- Query
  - added method 'addParamKey:andValue:'

- Asset
  - added method ‘addParamKey:andValue:’


### Version: 3.2.0
#### Date: Nov-10-2017

##### New Features:

- Stack
  - added method ‘imageTransformWithUrl:andParams:’

- Query
  - added method 'includeContentType:'

- QueryResult
  - added property ‘content_type’

##### API deprecation:

- Query
  - Deprecated property 'includeSchema'

### Version: 3.1.1
#### Date: Jun-24-2017

##### API deprecation:

- Entry
  - removed property 'publishDetails'

- Asset
  - removed property 'publishDetails:'

### Version: 3.1.0
#### Date: Dec-19-2016

##### New Features:

- Group
  - Added New Class

- Entry
  - added method 'groupForKey:'
  - added method 'groupsForKey:'
  - added method ‘entriesForKey:withContentType:'

- AssetLibrary
  - added method ‘sortWithKey:orderBy:’
  - added method ‘objectsCount’
  - added method ‘includeCount’
  - added method ‘includeRelativeUrls’
  - added method ‘setHeader:forKey:’
  - added method ‘addHeadersWithDictionary:’
  - added method ‘removeHeaderForKey:’

- Asset
  - added method ‘setHeader:forKey:’
  - added method ‘addHeadersWithDictionary:’
  - added method ‘removeHeaderForKey:’

##### Modifications:

- Asset
  - Class name modified from ‘Assets’ to ‘Asset’
  - renamed property ’assetType’ to ‘fileType’ 
	
### Version: 3.0.0
#### Date: Oct-19-2016

##### New Features:

- Config
  - Added New Class

- Assets
  - Added New Class

- AssetLibrary
  - Added New Class

- Contentstack
  - added method 'stackWithAPIKey:accessToken:environmentName:config:'

- Entry
  - added property 'publishDetails'

- Stack
  - added readonly property 'config'
  - added method 'asset'
  - added method 'assetWithUID:'
  - added method 'assetLibrary'
  - added method 'fetchLastActivity:'


##### API deprecation:

- Contentstack
  - removed method 'stackWithAPIKey:accessToken:environmentUID:'

- Entry
  - removed property 'metadata'

- Stack
  - removed property 'isEnvironmentUID'
  - removed method 'setEnvironment:isEnvironmentUID:'

- Query
  - removed method 'afterUID:'
  - removed method 'beforeUID:'


### Version: 1.0.1
#### Date: Sept-22-2016

##### Bug Fixes:

- Entry
  - Fixed fetch method which now return response as per environment.

- Query
  - Fixed search method issue causing improper result.


### Version: 1.0.0
#### Date: Feb-11-2016

##### Changes:
- Introduce ContentStack SDK for iOS.
