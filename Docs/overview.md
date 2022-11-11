#Overview

[Contentstack](https://www.contentstack.com/) is a content management system that facilitates the process of publication by separating the content from site-related programming and design.

#### Installation
#####**[CocoaPods (Recommended)](https://cocoapods.org)**

Add the following line to your Podfile:  

     pod 'Contentstack'

Run `pod install`, and you should now have the latest Contentstack release.

#### Import Header/Module
You can import header file in Objective-C project as:

     #import <Contentstack/Contentstack.h>

You can also import as a Module:

     //Objc
     @import Contentstack

     //Swift
     import Contentstack


#### Initializing your SDK

To start using the SDK in your application, you will need to initialize the stack by providing the required keys and values associated with them:
    
     //Objc
     Stack *stack = [Contentstack stackWithAPIKey: API_KEY accessToken: ACCESS_TOKEN environmentName: ENVIRONMENT];
     
     //Swift
     let stack:Stack = Contentstack.stackWithAPIKey(API_KEY, accessToken: ACCESS_TOKEN, environmentName: ENVIRONMENT)
     
To get the api credentials mentioned above, you need to log into your Contentstack account and then in your top panel navigation, go to Settings -&gt; Stack to view both your API Key and your Access Token

The stack object that is returned is a Contentstack client object, which can be used to initialize different modules and make queries against our [Content Delivery API](https://contentstack.com/docs/apis/content-delivery-api/). The initialization process for each module is explained in the following section.


#### Querying content from your stack

To fetch all entries of of a content type, use the query given below:
    
     //Objc
     ContentType *contentTypeObject = [stack contentTypeWithName:@"my_content_type"];
     Query *queryObject = [contentTypeObj query];
     
     //Swift
     var contentTypeObject:ContentType = stack.contentTypeWithName("my_content_type")
     var queryObject:Query = contentTypeObj.query()
     

To fetch a specific entry from a content type, use the following query:

     //Objc
     ContentType * contentTypeObject = [stack contentTypeWithName:@"my_content_type"];
     Entry *entryObject  = [contentTypeObject entryWithUID:@"ENTRY_UID"];
     
     //Swift
     var contentTypeObject:ContentType = stack.contentTypeWithName("my_content_type")
     var entryObject:Entry = contentTypeObject.entryWithUID("ENTRY_UID")
     
