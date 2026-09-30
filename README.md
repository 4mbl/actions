# 4mbl/actions

Reusable GitHub Actions.

## Tips

- Setup Dependabot or similar tool to automatically update GitHub Actions.

  ```yaml
  # .github/dependabot.yml
  version: 2

  updates:
    - package-ecosystem: 'github-actions'
      directory: '/'
      schedule:
        interval: 'weekly'
  ```

- Pin action and workflow versions to specific commit SHAs.

  ```yaml
   - name: Checkout repository
       uses: actions/checkout@08c6903cd8c0fde910a37f88322edcfb5dd907a8 # v5.0.0
  ```

  You can do this easily with [`pinact`](https://github.com/suzuki-shunsuke/pinact). Just set the specifier to a major version like `actions/checkout@v5`, and execute `pinact run` to pin to the version hash. You can then use dependabot to update the action periodically.

## Versioning

Each reusable workflow and action has its own version tags. Workflow component prefixes match their filenames. Actions use their directory paths with `/` replaced by `-`, so `changeset/pr-comment/action.yml` uses `changeset-pr-comment`. New tags are only created when the related workflow or action is changed.

Tags use `<component>/vYY.M.N` format: a two-digit year, an unpadded month, and a release number that starts at `0` each month. For example:

- `ci-node-pnpm/v26.9.0` - first September release
- `ci-node-pnpm/v26.9.1` - second September release
- `ci-node-pnpm/v26.10.0` - first October release

Breaking changes may occur in any release. When possible, changes that require consumers to update their workflows or actions are introduced in the first release of the following year.

## Workflows

### `ci-node-pnpm`

```yaml
# .github/workflows/ci.yml

name: CI

on:
  push:
    branches:
      - '**'
  workflow_dispatch:

jobs:
  ci:
    name: Node.js
    uses: 4mbl/actions/.github/workflows/ci-node-pnpm.yaml@<sha> # ci-node-pnpm/v<version>
```

Additionally, set the runtime and package manager versions in `devEngines` in `package.json`.

```json
{
  "devEngines": {
    "runtime": {
      "name": "node",
      "version": "24.x",
      "onFail": "download"
    },
    "packageManager": {
      "name": "pnpm",
      "version": "11.x",
      "onFail": "download"
    }
  }
}
```

If you need to enforce successful CI runs, you can use the `Node.js / Report results` check in GitHub branch protection rules.

### `changeset-comment`

```yaml
# .github/workflows/changeset-comment.yml

name: Changeset PR Comment

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  check-changesets:
    uses: 4mbl/actions/.github/workflows/changeset-comment.yml@<sha> # changeset-comment/v<version>
```

The underlying action is [`changeset/pr-comment`](#changesetpr-comment).

## Actions

### `changeset/pr-comment`

```yaml
uses: 4mbl/actions/changeset/pr-comment@<sha> # changeset-pr-comment/v<version>
env:
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

This is the underlying action for the [`changeset-comment`](#changeset-comment) workflow. Using the workflow is recommended since it requires less setup and is easier to maintain.
