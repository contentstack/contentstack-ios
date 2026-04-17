---
name: contentstack-ios-cda
description: Use for the Objective-C Content Delivery API, public headers, and CocoaPods-facing behavior.
---

# iOS CDA SDK (Objective-C) – contentstack-ios

## When to use

- Changing public classes or headers consumed via **`#import <Contentstack/...>`**
- Documenting migration paths to the Swift SDK

## Instructions

### API surface

- Preserve **binary and source compatibility** for shipping apps unless a major pod version documents breaks.

### Headers

- Keep umbrella / module map consistent with CocoaPods expectations; update consumer-facing snippets in `README.md` when public API changes.

### Direction

- Prefer pointing new development to **contentstack-swift** + SPM; keep this repo accurate for existing integrations only.
