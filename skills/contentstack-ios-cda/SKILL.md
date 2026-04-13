---
name: contentstack-ios-cda
description: Use when implementing or changing CDA features – Stack/Config, entries, assets, sync, taxonomy, query, HTTP entry points, retry, callbacks, and Content Delivery API alignment
---

# Contentstack iOS CDA SDK – CDA Implementation

Use this skill when implementing or changing Content Delivery API (CDA) behavior in the iOS SDK.

## When to use

- Adding or modifying **Stack**, **Entry**, **Query**, **Asset**, **ContentType**, **SyncStack**, **Taxonomy**, **AssetLibrary**, **Group**, or **QueryResult** behavior.
- Changing **Config** (host, region, branch, delegate, early access) or how the stack builds API URLs.
- Adjusting how requests are issued or errors returned at the boundary between public API and **`CSIOCoreHTTPNetworking`**.

## Instructions

### Stack and Config

- **Entry point:** `+[Contentstack stackWithAPIKey:accessToken:environmentName:]` and `stackWithAPIKey:accessToken:environmentName:config:`.
- **Config:** Optional `Config` for custom host, region, branch, `id<CSURLSessionDelegate>`, early access feature flags, etc.
- **Reference:** `Contentstack.h` / `Contentstack.m`, `Stack.h` / `Stack.m`, `Config.h` / `Config.m`.

### CDA resources

- **Entries / content types / queries:** Follow existing `Stack` → content type → entry / query flows and completion-handler patterns.
- **Assets:** Use **Asset**, **AssetLibrary**, and existing fetch/query APIs.
- **Sync:** Use **SyncStack** and existing pagination/token patterns.
- **Taxonomy:** Use **Taxonomy** and related stack APIs.
- **Official API:** Align with [Content Delivery API](https://www.contentstack.com/docs/apis/content-delivery-api/) for parameters, responses, and semantics.

### HTTP and retry

- **HTTP:** CDA traffic goes through **`CSIOCoreHTTPNetworking`** and **`CSURLSessionManager`**. Preserve header construction and URL schemes used elsewhere.
- **Retry:** Implemented inside the HTTP layer (e.g. handling of specific error codes with backoff). When changing retry, verify behavior against CDA expectations and avoid unbounded retries.

### Errors and callbacks

- Surface failures through **`NSError`**, failure blocks, or delegates consistent with the class being edited.
- Do not change public callback contracts without a semver/compatibility plan.

## Key types (indicative)

- **Entry:** `Contentstack`, `Stack`, `Config`
- **CDA:** `Entry`, `Query`, `Asset`, `AssetLibrary`, `ContentType`, `SyncStack`, `Taxonomy`, `Group`, `QueryResult`
- **HTTP (internal):** `CSIOCoreHTTPNetworking`, `CSURLSessionManager`, `CSIOAPIURLs`, `CSIOConstants`

## References

- [Content Delivery API – Contentstack Docs](https://www.contentstack.com/docs/apis/content-delivery-api/)
- Project rules: `.cursor/rules/contentstack-ios-cda.mdc`, `.cursor/rules/ios.mdc`
- **AGENTS.md** – commands and directory map
