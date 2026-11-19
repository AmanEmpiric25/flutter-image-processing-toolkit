# Contributing

## Workflow

The repository owner maintains the roadmap, creates issues, reviews changes, merges pull requests, and manages releases. Collaborators investigate issues, implement focused changes, add regression tests, and improve documentation through pull requests.

1. Choose or discuss a GitHub issue before starting work.
2. Create a branch from `main` using `feature/<short-description>`, `fix/<short-description>`, or `docs/<short-description>`.
3. Keep one purpose per pull request. Use an imperative commit subject such as `feat: add JPEG compression options`.
4. Run formatting, analysis, and relevant tests locally.
5. Complete the pull request template and request review from the repository owner.

## Quality bar

Do not expose plugin-specific types through the package API. Preserve the original image, cover observable failures with tests, update documentation when behavior changes, and avoid adding unimplemented future features. CI runs formatting, analysis, package and example tests, and an Android debug build; all checks must pass before merge.

## Reporting issues

Include Flutter and OS versions, input format, expected and actual behavior, and a minimal reproduction. Never attach private images or credentials.
