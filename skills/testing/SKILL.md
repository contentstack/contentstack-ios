---
name: testing
description: Use when writing or refactoring ContentstackTest – XCTest, fixtures, async, naming, unit vs integration-style
---

# Testing – Contentstack iOS CDA SDK

Use this skill when adding or refactoring tests in the **ContentstackTest** target.

## When to use

- Writing new XCTest cases or methods.
- Adding bundle resources (e.g. JSON fixtures) for tests.
- Debugging flaky or slow network tests.

## Instructions

### XCTest and layout

- Tests live under **`ContentstackTest/`** and compile into **`ContentstackTest.xctest`** (scheme **Contentstack**).
- **Class naming:** `*Test` (e.g. `ContentstackMainTest`, `QueryAdvancedTest`).
- **Method naming:** `- (void)testFeatureName` or similar descriptive selectors.

### Fixtures and credentials

- Integration-style tests often load **`config.json`** from the test bundle (see `ContentstackMainTest`). Required keys should match what existing tests read (`api_key`, `delivery_token`, `environment`, `host`, etc.).
- Never commit production tokens. For CI, use secrets or skip network tests when credentials are missing (follow patterns already in the suite if present).

### Async and timeouts

- Use **`XCTestExpectation`** and **`waitForExpectationsWithTimeout:`** (or `waitForExpectations`) for asynchronous stack/entry/query completion handlers.
- Choose timeouts appropriate to network latency; avoid excessively short timeouts that flake on slow networks.

### Unit vs integration-style

- Prefer fast, deterministic unit tests for pure logic (parsing, edge cases) when you can isolate behavior.
- Use real-stack tests sparingly and only when validating end-to-end CDA integration.

### Execution

- **Xcode:** `⌘U` with scheme **Contentstack**.
- **CLI:** `xcodebuild -project Contentstack.xcodeproj -scheme Contentstack -destination 'platform=iOS Simulator,name=<Device>' test`

## References

- `ContentstackTest/*.m` – existing patterns
- Project rule: `.cursor/rules/testing.mdc`
- **AGENTS.md** – test target and command summary
