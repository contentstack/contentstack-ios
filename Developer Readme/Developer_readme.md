# DEVELOPER README
###### (make sure you follow this guidelines to continue working without much problems)
-----------------------------------------------------------------------------

> Use XCode 7.1 or greater for development

#### Code instructions

- Non-mutable as "copy", mutable as "strong" and delegates as "weak"
- Use extension for internal use


#### Documentation

- Install xcode plugin VVDocumenter and type /// for autogen of documentation (https://github.com/onevcat/VVDocumenter-Xcode)


#### Incuding 3rd party libraries

- All 3rd party libraries files should be added in target 'ThirdPartyExtension'
- Generate header by setting scheme as 'ThirdPartyExtension' and compiling them
- Add 3rd party libraries files from target dependency of 'ContentStackIO' target under compile sources.
- Mention library name, its version and URL below


#### 3rd party library used

- AFNetworking - 2.4.1
- MMMarkDown - 0.5
- ISO8601DateFormatter

#### TestCase

- Check all sdk methods via TestCases written in ObjC and Swift. No code snippets in AppDelegate.

#### Defining Deprecated API

- Dont delete deprecated method from .h/.m
- Use CSIOIO_DEPRECATED. For eg. CSIOIO_DEPRECATED("Please use etc etc")
- Create a Mark in .h/.m like //MARK: Deprecated API and put the deprecated method there with NSLog with Deprecated message.
