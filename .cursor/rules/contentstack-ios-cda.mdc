---
description: Contentstack CDA patterns – Stack/Config, HTTP, retry, callbacks, Content Delivery API
globs:
  - "Contentstack/**/*.{h,m}"
  - "ContentstackInternal/**/*.{h,m}"
---

# Contentstack iOS CDA – SDK Rules

Apply when editing the SDK core (`Contentstack/`, `ContentstackInternal/`). Keep behavior aligned with the [Content Delivery API](https://www.contentstack.com/docs/apis/content-delivery-api/).

## Stack and Config

- **Entry point:** `+[Contentstack stackWithAPIKey:accessToken:environmentName:]` and `stackWithAPIKey:accessToken:environmentName:config:` return a **`Stack`**. Use **`Config`** for optional settings (host, region, branch, delegate, early access).
- **Defaults:** Follow existing **`Config`** initialization (host/version behavior as implemented in `Config` / stack setup).
- **Region / branch:** Support regional endpoints and branch delivery via **`Config`** properties, consistent with CDA docs and current stack URL building (`CSIOAPIURLs`, etc.).

## HTTP layer

- **Requests** should flow through **`CSIOCoreHTTPNetworking`** and **`CSURLSessionManager`** (and related internal types). Do not bypass the shared session stack for CDA calls without a strong reason.
- **Headers:** Preserve User-Agent, access token, environment, and other required CDA headers as built in existing request code (`CSIOConstants`, stack configuration).
- **Errors:** Map API failures to existing patterns (`NSError`, failure blocks, or error callbacks) so app code receives consistent semantics.

## Retry and resilience

- Retry logic for transient failures lives in the networking layer (e.g. **`CSIOCoreHTTPNetworking`** handling of status / error codes). When changing retry behavior, keep defaults and caps consistent with CDA-friendly backoff and document any behavior change.
- Unlike some other SDKs, retry is not always exposed as a separate public **`Config`** surface; prefer adjusting the internal implementation coherently.

## Callbacks and async

- Use **blocks**, delegates (`CSURLSessionDelegate`), and existing completion patterns already used on **`Stack`**, **`Entry`**, **`Query`**, **`Asset`**, **`SyncStack`**, etc.
- Do not change public callback signatures without a compatibility plan (semver / migration note).

## CDA concepts

- **Entry, Query, Asset, Content Type, Sync, Taxonomy, AssetLibrary, Group, QueryResult** – follow existing class names and CDA semantics (query parameters, response parsing). When adding CDA features, align with the official Content Delivery API documentation and with other Contentstack CDA SDKs where practical.
