---
name: framework
description: Use when changing Config, URL/session setup, CSIOCoreHTTPNetworking, CSURLSessionManager, retry behavior, or internal request flow
---

# Framework – Contentstack iOS CDA SDK

Use this skill when changing configuration, URL/session behavior, or the internal HTTP stack (not the high-level CDA object model).

## When to use

- Modifying **`Config`** properties or how **`Stack`** applies config to base URLs and headers.
- Changing **`CSIOCoreHTTPNetworking`** request building, response handling, or retry loops.
- Changing **`CSURLSessionManager`**, session configuration, delegate wiring, or operation queues.
- Adjusting **`CSIOAPIURLs`**, **`CSIOConstants`**, caching (`CSIOURLCache`), or internal extensions (`NSObject+Extensions`).

## Instructions

### Config and Stack

- **Config** exposes delivery-related options (host, region, branch, session delegate, early access). Preserve default behavior expected by existing apps when changing initialization or defaults.
- **Stack** ties config to the internal network object; keep reference lifetimes and teardown (`cancelAllRequestsOfStack:`) coherent.

### HTTP session layer

- **`CSURLSessionManager`** wraps **`NSURLSession`** with success/failure blocks and delegate callbacks. Changes here affect all CDA traffic—verify timeouts, TLS behavior, and background vs foreground assumptions.
- Do not fragment session usage: new CDA calls should use the same stack/session path as existing ones unless intentionally designing a new client.

### Retry and resilience

- Retry is implemented in **`CSIOCoreHTTPNetworking`** (e.g. handling of transient errors with bounded retries and backoff). When adjusting retry conditions or counts, document behavior and consider alignment with other Contentstack CDA SDKs’ retry policies where applicable.

### Errors

- Propagate **`NSError`** and API error payloads through the same paths used today so higher layers (`Stack`, `Entry`, `Query`, etc.) remain consistent.

## Key files (indicative)

- **Config / stack wiring:** `Config.m`, `Stack.m`
- **HTTP:** `CSIOCoreHTTPNetworking.m`, `CSIOCoreHTTPNetworking.h`
- **Session:** `CSURLSessionManager.m`, `CSURLSessionManager.h`, `CSURLSessionDelegate.h`
- **URLs / constants:** `CSIOAPIURLs.m`, `CSIOConstants.m`

## References

- Project rules: `.cursor/rules/contentstack-ios-cda.mdc`, `.cursor/rules/ios.mdc`
- CDA skill: `skills/contentstack-ios-cda/SKILL.md` for public CDA API changes that depend on framework behavior
