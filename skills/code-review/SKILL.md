---
name: code-review
description: Use when reviewing PRs or before opening a PR – API design, errors, memory/threading, backward compatibility, dependencies, security, XCTest quality
---

# Code Review – Contentstack iOS CDA SDK

Use this skill when performing or preparing a pull request review for the iOS CDA SDK.

## When to use

- Reviewing someone else’s PR.
- Self-reviewing your own PR before submission.
- Checking that changes meet project standards (API, errors, compatibility, tests, security).

## Instructions

Work through the checklist below. Optionally tag items with severity: **Blocker**, **Major**, **Minor**. The canonical short checklist lives in `.cursor/rules/code-review.mdc` (aligned with **contentstack-java** and other CDA SDKs).

### 1. API design and stability

- [ ] **Public API:** New or changed public headers are necessary and documented (header comments / usage examples consistent with the repo).
- [ ] **Backward compatibility:** No breaking changes to public Objective-C / Swift-visible API without agreement (major version or explicit migration).
- [ ] **Naming:** Consistent with existing SDK and CDA terminology (`Stack`, `Entry`, `Query`, `Config`, etc.).

**Severity:** Breaking public API without approval = **Blocker**. Missing docs on new public API = **Major**.

### 2. Error handling and robustness

- [ ] **Errors:** Failures use `NSError`, failure blocks, or delegates as appropriate for the module.
- [ ] **Nullability:** Annotations remain correct; no ignored errors in new code paths.
- [ ] **Memory / concurrency:** No obvious retain cycles; threading matches existing networking patterns.

**Severity:** Wrong or missing error handling in new code = **Major**.

### 3. Dependencies and security

- [ ] **Dependencies:** Podspec / vendored code changes are justified; versions do not introduce known critical issues.
- [ ] **SCA:** Security findings (Snyk, Dependabot, etc.) are addressed or tracked.

**Severity:** New critical/high vulnerability = **Blocker**.

### 4. Testing

- [ ] **Coverage:** New or modified behavior has XCTest coverage where feasible.
- [ ] **Conventions:** Test classes follow `*Test` naming; async tests use expectations and sane timeouts.
- [ ] **Quality:** Tests are deterministic and readable.

**Severity:** No tests for new behavior = **Blocker** (unless explicitly out of scope). Flaky tests = **Major**.

### 5. Optional severity summary

- **Blocker:** Must fix before merge (e.g. breaking API without approval, security issue, no tests for new code).
- **Major:** Should fix (e.g. inconsistent error handling, missing public API docs, flaky tests).
- **Minor:** Nice to fix (e.g. style, minor docs).

## References

- Project rule: `.cursor/rules/code-review.mdc`
- Testing skill: `skills/testing/SKILL.md`
