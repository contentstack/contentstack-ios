---
name: code-review
description: Use when reviewing PRs for contentstack-ios—compatibility, CocoaPods, and deprecation messaging.
---

# Code review – contentstack-ios

## When to use

- Reviewing Objective-C SDK changes
- Checking podspec or release metadata updates

## Instructions

### Checklist

- **Compatibility**: Changes safe for existing CocoaPods consumers; version semver appropriate.
- **Deprecation**: README/DEPRECATION messaging still accurate if behavior shifts.
- **Tests**: XCTest coverage for fixes; manual notes for scenarios hard to automate.
- **Security**: No secrets; HTTPS and ATS assumptions preserved.

### Severity hints

- **Blocker**: Broken pod install, broken build for supported Xcode/iOS matrix.
- **Major**: API change without major version or migration note.
- **Minor**: Comments, internal refactors.
