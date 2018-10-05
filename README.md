[![Contentstack](https://www.contentstack.com/docs/static/images/contentstack.png)](https://www.contentstack.com/)

## iOS SDK for Contentstack

Contentstack is a headless CMS with an API-first approach. It is a CMS that developers can use to build powerful cross-platform applications in their favorite languages. Build your application frontend, and Contentstack will take care of the rest. [Read More](https://www.contentstack.com/).

Contentstack provides iOS SDK to build application on top of iOS. Given below is the detailed guide and helpful resources to get started with our iOS SDK.


### Prerequisite


Latest Xcode and Mac OS X


### Setup and Installation


To use this SDK on iOS platform, you will have to install the SDK according to the steps given below.


##### Manual


1. Download the [Latest iOS SDK release](https://www.contentstack.com/docs/platforms/ios/ios_sdk_latest) and extract the zip file to your local disk.
2. Drag and drop Contentstack.framework into your project folder in Xcode. A window will appear, prompting you to choose one of the options for adding files. Click the ‘Destination’ checkbox to copy items into the destination group’s folder. This will add the SDK to your project.
3. In the project editor, select your app under TARGETS. Under the General tab, open Linked Frameworks and Libraries and add the following libraries:
- CoreGraphics.framework
- MobileCoreServices.framework
- Security.framework
- SystemConfiguration.framework

4. In your target app, click on the Build Settings tab and add the -ObjC flag to Other Linker Flags.

##### CocoaPods

1. Add the following line to your Podfile:
2. pod 'Contentstack'
3. Run pod install, and you should now have the latest Contentstack release.

##### Import Header/Module

You can import header file in Objective-C project as:
```sh
#import <Contentstack/Contentstack.h>;

You can also import as a Module:

//Objc

@import Contentstack

//Swift

import Contentstack
```
### Key Concepts for using Contentstack

#### Stack

A stack is like a container that holds the content of your app. Learn more about [Stacks](https://www.contentstack.com/docs/guide/stack).

#### Content Type

Content type lets you define the structure or blueprint of a page or a section of your digital property. It is a form-like page that gives Content Managers an interface to input and upload content. [Read more](https://www.contentstack.com/docs/guide/content-types).

#### Entry

An entry is the actual piece of content created using one of the defined content types. Learn more about [Entries](https://www.contentstack.com/docs/guide/content-management#working-with-entries).


#### Asset


Assets refer to all the media files (images, videos, PDFs, audio files, and so on) uploaded to Contentstack. These files can be used in multiple entries. Read more about [Assets](https://www.contentstack.com/docs/guide/content-management#working-with-assets).


#### Environment

A publishing environment corresponds to one or more deployment servers or a content delivery destination where the entries need to be published. Learn how to work with [Environments](https://www.contentstack.com/docs/guide/environments).

### Contentstack iOS SDK: 5-minute Quickstart

#### Initializing your SDK

To start using the SDK in your application, you will need to initialize the stack by providing the required keys and values associated with them:
```sh
//Objc

Stack *stack = [Contentstack stackWithAPIKey: API_KEY accessToken: ACCESS_TOKEN environmentName: ENVIRONMENT];
//Swift

let stack:Stack = Contentstack.stackWithAPIKey(API_KEY, accessToken: ACCESS_TOKEN, environmentName: ENVIRONMENT)
```
To get the api credentials mentioned above, you need to log into your Contentstack account and then in your top panel navigation, go to Settings -&gt; Stack to view both your API Key and your Access Token

The stack object that is returned is a Contentstack client object, which can be used to initialize different modules and make queries against our [Content Delivery API](https://contentstack.com/docs/apis/content-delivery-api/). The initialization process for each module is explained in the following section.


#### Querying content from your stack

To fetch all entries of of a content type, use the query given below:
```sh
//Obj-C

ContentType *contentTypeObject = [stack contentTypeWithName:@"my_content_type"];

Query *queryObject = [contentTypeObj query];



//Swift

var contentTypeObject:ContentType = stack.contentTypeWithName("my_content_type")

var queryObject:Query = contentTypeObj.query()
```


To fetch a specific entry from a content type, use the following query:
```sh
//Obj-C

ContentType * contentTypeObject = [stack contentTypeWithName:@"my_content_type"];

Entry *entryObject  = [contentTypeObject entryWithUID:@"ENTRY_UID"];

//Swift

var contentTypeObject:ContentType = stack.contentTypeWithName("my_content_type")

var entryObject:Entry = contentTypeObject.entryWithUID("ENTRY_UID")
```
### Advanced Queries

You can query for content types, entries, assets and more using our iOS API Reference.

[iOS API Reference Doc](https://www.contentstack.com/docs/platforms/ios/api-reference/)

### Working with Images

We have introduced Image Delivery APIs that let you retrieve images and then manipulate and optimize them for your digital properties. It lets you perform a host of other actions such as crop, trim, resize, rotate, overlay, and so on.

For example, if you want to crop an image (with width as 300 and height as 400), you simply need to append query parameters at the end of the image URL, such as, https://images.contentstack.io/v3/assets/blteae40eb499811073/bltc5064f36b5855343/59e0c41ac0eddd140d5a8e3e/download?crop=300,400. There are several more parameters that you can use for your images.

[Read Image Delivery API documentation](https://www.contentstack.com/docs/apis/image-delivery-api/).

You can use the Image Delivery API functions in this SDK as well. Here are a few examples of its usage in the SDK.

```sh
//Obj-C
/* set the image quality to 100 */
NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:100], @"quality", nil];
NSString *transformedUrl = [stack imageTransformWithUrl:imageURL andParams:params];

/* resize the image by specifying width and height */
NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:100], @"width", [NSNumber numberWithInt:100], @"height", nil];
NSString *transformedUrl = [stack imageTransformWithUrl:imageURL andParams:params];

/* enable auto optimization for the image */
NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"webp", @"auto", nil];
NSString *transformedUrl = [stack imageTransformWithUrl:imageURL andParams:params];


//Swift
/* set the image quality to 100 */
let params:[String : AnyObject?] = [
"quality":100 as AnyObject
];
let transformedUrl:String = stack.imageTransformation(withUrl: imageURL, andParams: params);

/* resize the image by specifying width and height */
let params:[String : AnyObject?] = [
"width":100 as AnyObject,
"height":100 as AnyObject,
];
let transformedUrl:String = stack.imageTransformation(withUrl: imageURL, andParams: params);

let params:[String : AnyObject?] = [
"auto":"webp" as AnyObject
];
let transformedUrl:String = stack.imageTransformation(withUrl: imageURL, andParams: params);

```

### Helpful Links

- [Contentstack Website](https://www.contentstack.com)
- [Official Documentation](http://contentstack.com/docs)
- [Content Delivery API Docs](https://contentstack.com/docs/apis/content-delivery-api/)

### The MIT License (MIT)

Copyright © 2012-2018 [Contentstack](https://www.contentstack.com/). All Rights Reserved

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
