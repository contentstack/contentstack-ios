# Cursor Rules – Contentstack iOS CDA SDK

This directory contains Cursor AI rules that apply when working in this repository. Rules provide persistent context so the AI follows project conventions and Contentstack CDA patterns.

## How rules are applied

- **File-specific rules** use the `globs` frontmatter: they apply when you open or edit files matching that pattern.
- **Always-on rules** use `alwaysApply: true`: they are included in every conversation in this project.

## Rule index

| File | Applies when | Purpose |
|------|--------------|---------|
| **dev-workflow.md** | (Reference only; no glob) | Development workflow: branches, running tests, PR expectations. Read for process guidance. |
| **ios.mdc** | `Contentstack/`, `ContentstackInternal/`, `ThirdPartyExtension/` `*.h` / `*.m` | Objective-C standards: naming, module layout, headers vs implementation, nullability, consistency with existing SDK style. |
| **contentstack-ios-cda.mdc** | `Contentstack/`, `ContentstackInternal/` `*.h` / `*.m` | CDA-specific patterns: Stack/Config, host/version/region/branch, HTTP entry points, retry behavior, blocks/callbacks, alignment with Content Delivery API. |
| **testing.mdc** | `ContentstackTest/**/*.h`, `ContentstackTest/**/*.m` | XCTest patterns: test class naming, unit vs network/integration-style tests, fixtures (`config.json`), stability. |
| **code-review.mdc** | Always | PR/review checklist: API stability, error handling, backward compatibility, dependencies and security (e.g. SCA). |

## Related

- **AGENTS.md** (repo root) – Main entry point for AI agents: project overview, entry points, commands, pointers to rules and skills.
- **skills/** – Reusable skill docs (Contentstack iOS CDA, testing, code review, framework) for deeper guidance on specific tasks.
