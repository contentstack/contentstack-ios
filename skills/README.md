# Skills – Contentstack iOS CDA SDK

This directory contains **skills**: reusable guidance for AI agents (and developers) on specific tasks. Each skill is a folder with a `SKILL.md` file.

## When to use which skill

| Skill | Use when |
|-------|----------|
| **contentstack-ios-cda** | Implementing or changing CDA features: Stack/Config, entries, assets, content types, sync, taxonomy, query results, alignment with the Content Delivery API, and public callback patterns. |
| **testing** | Writing or refactoring **ContentstackTest** tests: XCTest, fixtures (`config.json`), async expectations, unit vs integration-style coverage. |
| **code-review** | Reviewing a PR or preparing your own: API design, errors, backward compatibility, dependencies/security, test coverage (see shared checklist with other CDA SDKs). |
| **framework** | Changing **Config**, URL/session configuration, **`CSIOCoreHTTPNetworking`**, **`CSURLSessionManager`**, retry behavior, or internal request/response flow. |

## How agents should use skills

- **contentstack-ios-cda:** Apply when editing SDK production code under `Contentstack/` or `ContentstackInternal/` for CDA behavior. Follow Stack/Config entry points and existing block/delegate error patterns.
- **testing:** Apply when creating or modifying `ContentstackTest/*`. Match existing `*Test` class naming and resource loading patterns.
- **code-review:** Apply when performing or simulating a PR review. Use the checklist in `.cursor/rules/code-review.mdc` and optional severity levels.
- **framework:** Apply when touching networking internals or Config-related behavior. Keep session, retry, and error propagation consistent.

Each skill’s `SKILL.md` contains more detailed instructions and file references.

For parity with sibling SDKs, compare with **contentstack-java** `skills/` (same intent; Java-specific commands and types differ).
