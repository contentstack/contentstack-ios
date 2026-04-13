# Development Workflow – Contentstack iOS CDA SDK

Use this as the standard workflow when contributing to the iOS CDA SDK.

## Branches

- Use feature branches for changes (e.g. `feat/...`, `fix/...`).
- Base work off the appropriate long-lived branch (e.g. `staging`, `development`) per team norms.

## Running tests

- **From Xcode:** Select scheme **Contentstack**, then **Product → Test** (`⌘U`).
- **Command line:**  
  `xcodebuild -project Contentstack.xcodeproj -scheme Contentstack -destination 'platform=iOS Simulator,name=<Device>' test`  
  Replace `<Device>` with an installed simulator (list with `xcrun simctl list devices available`).

Run tests before opening a PR. Tests that call the live CDA may require **`ContentstackTest/config.json`** (API key, delivery token, environment, host, etc.)—keep secrets out of git; follow existing test setup patterns.

## Pull requests

- Ensure the project builds and tests pass locally.
- Follow the **code-review** rule (see `.cursor/rules/code-review.mdc`) for the PR checklist.
- Keep changes backward-compatible for public API; call out any breaking changes clearly in the PR description.

## Optional: TDD

If the team uses TDD, follow RED–GREEN–REFACTOR when adding behavior: write a failing test first, then implement to pass, then refactor. The **testing** rule and **skills/testing** skill describe test structure and naming.
