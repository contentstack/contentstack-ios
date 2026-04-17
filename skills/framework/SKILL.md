---
name: framework
description: Use for Xcode build settings, deployment targets, CocoaPods podspec, and iOS platform constraints.
---

# Build & platform – contentstack-ios

## When to use

- Changing **Contentstack.podspec** minimum iOS version or dependencies
- Updating Xcode recommended settings or bitcode/architecture flags

## Instructions

### CocoaPods

- **`Contentstack.podspec`** is the packaging contract—validate `pod lib lint` / `pod spec lint` before release when changing deps or source files.

### Xcode

- Keep deployment target aligned with supported customer apps; document bumps in changelog.

### Swift interop

- If exposing annotations for Swift callers, verify **Swift name** attributes and nullability match intended usage.
