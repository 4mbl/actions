# 4mbl/actions

Reusable GitHub Actions.

## Tips

- Setup dependabot or similar tool to automatically update GitHub Actions.

  ```yaml
  # .github/dependabot.yml
  version: 2

  updates:
  - package-ecosystem: 'github-actions'
      directory: '/'
      schedule:
      interval: 'weekly'
  ```

- Pin action versions to specific commit SHAs.

  ```yaml
   - name: Checkout repository
       uses: actions/checkout@08c6903cd8c0fde910a37f88322edcfb5dd907a8 # v5.0.0
  ```

  You can do this easily with [`pinact`](https://github.com/suzuki-shunsuke/pinact). Just set the specifier to a major version like `actions/checkout@v5`, and execute `pinact run` to pin to the version hash. You can then use dependabot to update the action periodically.

## Workflows

### `4mbl/actions/workflows/ci-node-pnpm`

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
    uses: 4mbl/actions/.github/workflows/ci-node-pnpm.yaml@v1
```

If you need to enforce successful CI runs, you can use the `Node.js / Report results` check in GitHub branch protection rules.

### `4mbl/actions/workflows/changeset-comment`

```yaml
# .github/workflows/changeset-comment.yml

name: Changeset Comment

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  check-changesets:
    uses: 4mbl/actions/.github/workflows/changeset-comment.yml@v1
```

The underlying action is [`4mbl/actions/changeset/pr-comment`](#4mblactionschangesetpr-comment).

## Actions

### `4mbl/actions/changeset/pr-comment`

```yaml
uses: 4mbl/actions/changeset/pr-comment@v1
env:
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

This is the underlying action for the [`changeset-comment`](#4mblactionsworkflowschangeset-comment) workflow. Using the workflow is recommended since it requires less setup and is easier to maintain.
