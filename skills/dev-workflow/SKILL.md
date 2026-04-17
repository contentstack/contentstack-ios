---
name: dev-workflow
description: Use for Xcode workflows, CI, CocoaPods context, and deprecation policy in contentstack-ios.
---

# Development workflow – contentstack-ios

## When to use

- Shipping fixes for existing CocoaPods users
- Coordinating with messaging in `README.md` / `DEPRECATION.md` about Swift migration

## Instructions

### Maintenance mode

- Treat this SDK as **legacy**—favor bugfixes and safe updates; large new features should align with product strategy and often belong in **contentstack-swift**.

### CI

- GitHub Actions enforce branch naming and policies—see `.github/workflows/` for required checks.

### Releases

- **`release-package.yml`** and pod publishing—bump version in podspec and follow release checklist with mobile team.
