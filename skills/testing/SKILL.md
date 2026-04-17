---
name: testing
description: Use for XCTest setup and running tests in the contentstack-ios Xcode project.
---

# Testing – contentstack-ios

## When to use

- Adding regression tests for bugfixes
- Validating changes across iOS simulator destinations

## Instructions

### XCTest

- Use the Xcode test navigator and shared schemes—ensure new tests are added to the correct target and scheme.

### Credentials

- Do not embed live stack keys in the repo; use local xcconfig or CI secrets patterns approved by the team.

### Scope

- Focus tests on SDK contract behavior; full app-level UI tests belong in consumer apps.
