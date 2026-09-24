# Contentstack iOS (Objective-C) CDA SDK – Agent guide

**Universal entry point** for contributors and AI agents. Detailed conventions live in **`skills/*/SKILL.md`**.

## What this repo is

| Field | Detail |
|--------|--------|
| **Name:** | [contentstack-ios](https://github.com/contentstack/contentstack-ios) (CocoaPods **`Contentstack`**) |
| **Purpose:** | Legacy **Objective-C** Content Delivery SDK for iOS; CocoaPods distribution. |
| **Out of scope:** | **New** apps should use the **[Swift CDA SDK](https://github.com/contentstack/contentstack-swift)** (see `README.md` / `DEPRECATION.md`). This repo maintains existing integrations. |

## Tech stack (at a glance)

| Area | Details |
|------|---------|
| Language | Objective-C (and supporting headers); Xcode project **`Contentstack.xcodeproj`** |
| Build | Xcode; CocoaPods **`Contentstack.podspec`** |
| Tests | XCTest targets in the Xcode project (see schemes) |
| Lint / coverage | Follow Xcode warnings and team standards—no separate SwiftLint for primary Obj-C sources |
| CI | `.github/workflows/check-branch.yml`, `policy-scan.yml`, `issues-jira.yml`, `release-package.yml` |

## Commands (quick reference)

| Command type | Command |
|--------------|---------|
| Xcode | Open **`Contentstack.xcodeproj`**, select scheme, **Cmd+B** / **Cmd+U** |
| CocoaPods | `pod install` in consuming apps; podspec defines SDK surface |

## Where the documentation lives: skills

| Skill | Path | What it covers |
|-------|------|----------------|
| **Development workflow** | [`skills/dev-workflow/SKILL.md`](skills/dev-workflow/SKILL.md) | Xcode project, CI, deprecation context |
| **iOS CDA SDK (Obj-C)** | [`skills/contentstack-ios-cda/SKILL.md`](skills/contentstack-ios-cda/SKILL.md) | Classes, headers, CocoaPods API |
| **Objective-C & layout** | [`skills/objective-c/SKILL.md`](skills/objective-c/SKILL.md) | Project structure, naming, modules |
| **Testing** | [`skills/testing/SKILL.md`](skills/testing/SKILL.md) | XCTest in this repo |
| **Build & platform** | [`skills/framework/SKILL.md`](skills/framework/SKILL.md) | Xcode settings, pods, iOS baselines |
| **Code review** | [`skills/code-review/SKILL.md`](skills/code-review/SKILL.md) | PR checklist, migration messaging |

## Using Cursor (optional)

If you use **Cursor**, [`.cursor/rules/README.md`](.cursor/rules/README.md) only points to **`AGENTS.md`**—same docs as everyone else.
