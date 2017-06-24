[![Built.io Contentstack](https://contentstackdocs.built.io/static/images/logo.png)](https://www.built.io/products/contentstack/overview)

# iOS SDK for Built.io Contentstack

iOS client for [Built.io Contentstack](https://www.built.io/products/contentstack/overview)  is the API-first CMS for your app. This SDK interacts only with the [Content Delivery Rest API](https://contentstackdocs.built.io/developer/restapi).

Contentstack is the CMS without the BS. With this headless cms, developers can build powerful cross-platform applications using their favorite front-end javascript frameworks and iOS/Android clients. 

You build your front-end and we will take care of delivering content through APIs, optimized for each destination. - [more here](https://www.built.io/products/contentstack/overview) 

### Prerequisite
 - Xcode 7.0 and later and Mac OS X 10.10.4 and later

### Setup and Installation
To use this SDK on iOS platform, you will have to install the SDK according to the steps given below.

##### Manual
1. Download the [Latest iOS SDK release](https://github.com/raweng/BuiltIOContentstack-iOS/releases) and extract the zip file to your local disk.
2. Drag and drop Contentstack.framework into your project folder in Xcode. 
    A window will appear, prompting you to choose one of the options for adding files. Click the ‘Destination’ checkbox to copy items into the destination group’s folder. This will add  the SDK to your project.

3. In the project editor, select your app under `TARGETS`. Under the `General` tab, open `Linked Frameworks and Libraries` and add the following libraries:
    - CoreGraphics.framework
    - MobileCoreServices.framework
    - Security.framework
    - SystemConfiguration.framework
4. In your target app, click on the `Build Settings` tab and add the `-ObjC` flag to `Other Linker Flags`.

##### [CocoaPods](https://cocoapods.org)

1. Add the following line to your Podfile:

	pod 'Contentstack'

	Run `pod install`, and you should now have the latest Contentstack release.

##### Import Header/Module
You can import header file in Objective-C project as:

	#import <Contentstack/Contentstack.h>

You can also import as a Module:

```sh
//Objc
@import Contentstack

//Swift
import Contentstack
```

### Key Concepts for using Contentstack

##### Stack
A stack is like a container that holds the content of your app. Learn more about creating stacks. [watch videos tutorials with documentation](https://contentstackdocs.built.io/developer/android/quickstart)

##### Content Type

A content type is the structure of a section with one or more fields within it. It is a form-like page that gives Content Managers an interface to input and upload content. 

##### Entry

An entry is the actual piece of content created using one of the defined content types. 

##### Asset

Assets refer to all the media files (images, videos, PDFs, audio files, and so on) uploaded to Built.io Contentstack. These files can be used in multiple entries.  

##### Environment

A publishing environment corresponds to one or more deployment servers or a content delivery destination where the entries need to be published. 


### 5 minute Quickstart

#### Initializing your Stack client

To start using the SDK in your application, you will need to initialize the stack by providing the required keys and values associated with them:

```
//Objc
Stack *stack = [Contentstack stackWithAPIKey: API_KEY accessToken: ACCESS_TOKEN environmentName: ENVIRONMENT];

//Swift
let stack:Stack = Contentstack.stackWithAPIKey(API_KEY, accessToken: ACCESS_TOKEN, environmentName: ENVIRONMENT)
```

To get the api credentials mentioned above, you need to log into your Contentstack account and then in your top panel navigation, go to Settings -> Stack to view both your `API Key` and your `Access Token`


The `stack` object that is returned is a Built.io Contentstack client object, which can be used to initialize different modules and make queries against our [Content Delivery API](https://contentstackdocs.built.io/rest/api/content-delivery-api/). The initialization process for each module is explained below.


#### Querying content from your stack

Let us take an example where we try to obtain all entries of the Content Type my_content_type.

```
//Obj-C
ContentType *contentTypeObject = [stack contentTypeWithName:@"my_content_type"];
Query *queryObject = [contentTypeObj query];
  
//Swift
var contentTypeObject:ContentType = stack.contentTypeWithName("my_content_type")
var queryObject:Query = contentTypeObj.query()
 
```

Let us take another example where we try to obtain only a specific entry from the Content Type `my_content_type`.

```
//Obj-C
ContentType * contentTypeObject = [stack contentTypeWithName:@"my_content_type"];
Entry *entryObject  = [contentTypeObject entryWithUID:@"ENTRY_UID"];
 
//Swift
var contentTypeObject:ContentType = stack.contentTypeWithName("my_content_type")
var entryObject:Entry = contentTypeObject.entryWithUID("ENTRY_UID")
```

### More Usage

You can query for content types, entries, assets and more using our completely documented api. Here are some useful examples:

Get a specific `ContentType` by `content_type_uid`

```
//Obj-C
ContentType *blogType = [stack contentTypeWithName:@"blog"];
 
//Swift
var blogType:ContentType = stack.contentTypeWithName("blog")
```

Get a specific `Entry` by `entry_uid`

```
//Obj-C
Entry * blogEntry  = [blogType entryWithUID:@"blt1234567890abcef"];
 
//Swift
var blogEntry:Entry = blogType.entryWithUID("blt1234567890abcef")
```

Fetch all entries of requested `content_type` by quering.

```
//Obj-C
Query * query  = [blogType query];
 
//Swift
var query: Query = blogType.query()
```

### How Do I Contribute?
Contentstack team want to make contributing to this project as easy as possible. Please find a Contribution Guidelines to contribute.

### Dependency library
iOS Contentstack SDK contains following dependency:

- [AFNetworking - 2.4.1](https://github.com/AFNetworking/AFNetworking/releases/tag/2.4.1)
- [MMMarkDown - 0.5](https://github.com/mdiep/MMMarkdown/releases/tag/0.5)
- [ISO8601DateFormatter](https://github.com/boredzo/iso-8601-date-formatter)


### Next steps

- [Online Query Guide](https://contentstackdocs.built.io/developer/ios/query-guide)
- [Online API Reference (iOS examples coming soon)](https://contentstackdocs.built.io/ios/api/)

### Links
 - [Website](https://www.built.io/products/contentstack/overview)
 - [Official Documentation](http://contentstackdocs.built.io/developer/ios/quickstart)
 - [Content Delivery Rest API](https://contentstackdocs.built.io/developer/restapi)

### The MIT License (MIT)
Copyright © 2012-2017 [Built.io](https://www.built.io/). All Rights Reserved

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
