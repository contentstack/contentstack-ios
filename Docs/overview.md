#Overview

[Contentstack](https://www.contentstack.com/) is a content management system that facilitates the process of publication by separating the content from site-related programming and design.

#### Installation
#####**[CocoaPods (Recommended)](https://cocoapods.org)**

Add the following line to your Podfile:  

     pod 'Contentstack'

Run `pod install`, and you should now have the latest Contentstack release.


##### Manual

1. Download the [Latest iOS SDK release](https://www.contentstack.com/docs/platforms/ios/ios_sdk_latest) and extract the zip file to your local disk.

2. Drag and drop Contentstack.framework into your project folder in Xcode. 
    A window will appear, prompting you to choose one of the options for adding files. Click the ‘Destination’ checkbox to copy items into the destination group’s folder. This will add  the SDK to your project.

3. In the project editor, select your app under `TARGETS`. Under the `General` tab, open `Linked Frameworks and Libraries` and add the following libraries:
     - CoreGraphics.framework
     - MobileCoreServices.framework
     - Security.framework
     - SystemConfiguration.framework

4. In your target app, click on the `Build Settings` tab and add the `-ObjC` flag to `Other Linker Flags`.


#### Import Header/Module
You can import header file in Objective-C project as:

     #import <Contentstack/Contentstack.h>

You can also import as a Module:

     //Objc
     @import Contentstack

     //Swift
     import Contentstack

