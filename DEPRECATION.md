# Deprecation notice: Contentstack iOS SDK (CocoaPods)

This page is for **developers using the Contentstack iOS SDK** distributed through **CocoaPods** and the **Objective-C** Content Delivery API (CDA) client in this repository.

## What this means for you

**We are deprecating this SDK as the recommended path for new iOS work.** If you are **starting a new project**, use our **[Contentstack Swift SDK](https://github.com/contentstack/contentstack-swift)** instead, and add it with **Swift Package Manager** (see links below).

**If you already ship an app** that uses `pod 'Contentstack'`, you can **keep using it**. Your integration continues to work. Plan a move to the Swift SDK when it fits your release schedule—you do not have to change immediately.

## What to use for new projects

| | Link |
|---|------|
| **Swift SDK (recommended)** | [github.com/contentstack/contentstack-swift](https://github.com/contentstack/contentstack-swift) |
| **Add the package (SPM)** | [Swift Package Index – Contentstack Swift SDK](https://swiftpackageindex.com/contentstack/contentstack-swift) |
| **API documentation** | [Contentstack Swift SDK (CDA) reference](https://www.contentstack.com/docs/developers/sdks/content-delivery-sdk/swift/reference) |

The Swift SDK is actively maintained and is where new features and improvements will appear.

## Why we are making this change

The wider **CocoaPods** ecosystem is [moving to a read-only model for publishing new pod versions](https://blog.cocoapods.org/CocoaPods-Specs-Repo/). This Objective-C SDK has been delivered mainly through CocoaPods; aligning **new** development on our **Swift** SDK and **SPM** matches where the platform and our product investment are headed.

## Support for this SDK going forward

This repository will stay in **maintenance**: we may address critical or security issues where we can, but **we do not plan new features** here. Feature work goes into the Swift SDK.

## Dates worth knowing

- The CocoaPods project has published a timeline for when **new pod versions** can no longer be submitted to their central registry, with a milestone around **December 2, 2026**. See their **[official announcement](https://blog.cocoapods.org/CocoaPods-Specs-Repo/)** for full detail.
- That industry change is separate from your day-to-day use of an **already published** `Contentstack` pod version today—existing installs are not “turned off” by Contentstack because of this page.

If you need help choosing a migration path or timing, contact **[Contentstack support](https://www.contentstack.com/)** or your account team.
