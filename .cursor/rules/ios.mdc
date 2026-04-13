---
description: Objective-C standards and Contentstack iOS SDK layout for CDA sources
globs:
  - "Contentstack/**/*.{h,m}"
  - "ContentstackInternal/**/*.{h,m}"
  - "ThirdPartyExtension/**/*.{h,m}"
---

# iOS SDK Standards – Contentstack iOS CDA SDK

Apply these conventions when editing Objective-C code in the SDK (not test targets).

## Language and runtime

- **Objective-C** with Apple’s modern conventions: use `NS_ASSUME_NONNULL_BEGIN` / `END` (or explicit `nullable` / `nonnull`) on public headers where the project already does.
- **Swift consumers** import the module; avoid breaking Swift names without good reason (Objective-C names map to Swift automatically).

## Layout and modules

- **Public API** lives under **`Contentstack/`** (headers shipped via `public_header_files` in the podspec).
- **Internal implementation** lives under **`ContentstackInternal/`** (HTTP, URLs, constants, extensions). Do not expose internal headers as public API without an explicit decision.
- **Vendored / shared code** under **`ThirdPartyExtension/`** (e.g. `CSURLSessionManager`, markdown, ISO8601). Keep changes minimal and consistent with upstream vendoring policy.

## Naming

- **Classes:** Prefix or unprefixed names as established in this SDK (`Stack`, `Config`, `CSIOCoreHTTPNetworking`, etc.); do not introduce conflicting generic names.
- **Methods:** Objective-C style, descriptive selectors; match existing patterns for “fetch”, “callback”, “withConfig:”, etc.
- **Categories:** Use project prefixes on category methods to avoid collisions (`cs_` or existing project convention).
- **Test classes:** See **testing.mdc** (`*Test` XCTest case naming).

## Headers

- Public declarations belong in **`Contentstack/*.h`**; import umbrella patterns consistent with **`Contentstack.h`**.
- Use forward declarations (`@class`) in headers when possible to reduce compile coupling.

## Documentation

- Public API should retain or extend the existing block-comment style in headers (parameters, return value, Obj-C / Swift snippets where already used).

## General

- Prefer explicit error handling over silent failure when adding new async or network paths.
- Match existing memory management (ARC); avoid introducing non-ARC patterns.
