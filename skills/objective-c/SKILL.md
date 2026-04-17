---
name: objective-c
description: Use for Objective-C source layout, Xcode project organization, and naming in contentstack-ios.
---

# Objective-C & layout – contentstack-ios

## When to use

- Adding `.m` / `.h` files to the Xcode project
- Refactoring categories, protocols, or module boundaries

## Instructions

### Project

- Primary IDE project is **`Contentstack.xcodeproj`**—keep file references and target membership correct when adding sources.

### Style

- Follow existing patterns for memory management (ARC), nullability annotations, and error handling used in the codebase.

### Resources

- Asset bundles and plists should stay minimal—verify impact on CocoaPods consumers when adding resources.
