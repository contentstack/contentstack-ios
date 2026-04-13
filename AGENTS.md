# Contentstack iOS CDA SDK – Agent Guide

This document is the main entry point for AI agents working in this repository.

## Project

- **Name:** Contentstack iOS CDA SDK (contentstack-ios)
- **Purpose:** iOS client for the Contentstack **Content Delivery API (CDA)**. It fetches content (entries, assets, content types, sync, taxonomy) from Contentstack for iOS apps (Objective-C primary API; Swift-compatible headers).
- **Repo:** [contentstack-ios](https://github.com/contentstack/contentstack-ios)

## Tech stack

- **Languages:** Objective-C (public SDK surface), with Swift-callable APIs via generated/bridged headers
- **IDE / build:** Xcode, `Contentstack.xcodeproj`
- **Distribution:** CocoaPods (`Contentstack.podspec`); no Swift Package Manager manifest in-repo today
- **HTTP:** `NSURLSession` via `CSURLSessionManager` and `CSIOCoreHTTPNetworking` (internal)
- **Testing:** XCTest, target **ContentstackTest** (`ContentstackTest.xctest`), scheme **Contentstack** (tests enabled; code coverage for **Contentstack** framework)

## Main entry points

- **`Contentstack`** – Factory: `+[Contentstack stackWithAPIKey:accessToken:environmentName:]` and `stackWithAPIKey:accessToken:environmentName:config:` return a **`Stack`**.
- **`Stack`** – Main API surface: content types, entries, queries, assets, asset library, sync, taxonomy, etc.
- **`Config`** – Optional settings: host, region, version (read-only where applicable), branch, URL session delegate, early access headers.
- **Paths (source):** `Contentstack/` (public headers + implementation), `ContentstackInternal/` (HTTP, URLs, constants, internal helpers), `ThirdPartyExtension/` (networking session layer, markdown, ISO8601).
- **Paths (tests):** `ContentstackTest/`

## Commands

- **Build framework:**  
  `xcodebuild -project Contentstack.xcodeproj -scheme Contentstack -destination 'generic/platform=iOS' -configuration Debug build`
- **Run tests:**  
  `xcodebuild -project Contentstack.xcodeproj -scheme Contentstack -destination 'platform=iOS Simulator,name=<Device>' test`  
  Pick a simulator you have installed (e.g. **iPhone 16**). Tests may require **`ContentstackTest/config.json`** (or equivalent) with stack credentials for integration-style cases—do not commit secrets.
- **CocoaPods lint (maintainers):**  
  `pod lib lint Contentstack.podspec`

Use **Product → Test** in Xcode as an alternative to `xcodebuild test`.

## Rules and skills

- **`.cursor/rules/`** – Cursor rules for this repo:
  - **README.md** – Index of all rules and when each applies.
  - **dev-workflow.md** – Branches, tests, PR expectations.
  - **ios.mdc** – Applies to SDK Objective-C sources: style, structure, naming.
  - **contentstack-ios-cda.mdc** – Applies to SDK core: CDA patterns, Stack/Config, HTTP/retry, callbacks, CDA alignment.
  - **testing.mdc** – Applies to **ContentstackTest**: XCTest naming, unit vs integration-style tests.
  - **code-review.mdc** – Always applied: PR/review checklist (aligned with other Contentstack CDA SDKs).
- **`skills/`** – Reusable skill docs:
  - **contentstack-ios-cda** – CDA implementation and SDK core behavior.
  - **testing** – Adding or refactoring tests.
  - **code-review** – PR review or pre-submit checklist.
  - **framework** – Config, HTTP session layer, retry behavior, and networking internals.

Refer to `.cursor/rules/README.md` for the rule index and to `skills/README.md` for when to use each skill.

For cross-SDK alignment, see the Java CDA SDK’s **AGENTS.md** and `.cursor/rules/` in [contentstack-java](https://github.com/contentstack/contentstack-java) (patterns are analogous; APIs and build tools differ).
