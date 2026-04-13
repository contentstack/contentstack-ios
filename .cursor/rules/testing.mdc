---
description: XCTest patterns, unit vs integration-style tests, fixtures, stability
globs:
  - "ContentstackTest/**/*.{h,m}"
---

# Testing Rules – Contentstack iOS CDA SDK

Apply when writing or editing tests in the **ContentstackTest** target.

## Test naming and layout

- **XCTest** case classes: suffix **`Test`** (e.g. `ContentstackMainTest`, `QueryResultTest`, `SyncTest`) matching existing files under **`ContentstackTest/`**.
- **Test methods:** `- (void)test...` with descriptive names; group related tests with `#pragma mark` sections where the file already uses that style.

## Unit vs integration-style

- **Unit-style:** Mock or avoid network where possible; assert parsing, model behavior, and edge cases quickly.
- **Integration-style:** Tests that call the live CDA require valid credentials—typically via **`config.json`** in the test bundle (see `ContentstackMainTest` and similar). Do not commit real tokens; document required keys for local/CI runs.

## XCTest usage

- Use **`XCTAssert*`** macros; use **`XCTestExpectation`** / **`waitForExpectationsWithTimeout:`** for async flows.
- Use **`setUp`** / **`tearDown`** for fixtures; load JSON or plist resources from **`[NSBundle bundleForClass:[self class]]`** when the project uses bundle resources.

## Stability

- Avoid time-dependent assertions unless necessary; prefer reasonable timeouts for network tests.
- Do not introduce flaky ordering assumptions or shared mutable global state across tests without synchronization.

## Coverage

- The **Contentstack** scheme enables code coverage for the **Contentstack** framework target. Add or extend tests when changing production behavior; do not drop coverage for critical paths without replacement tests.
