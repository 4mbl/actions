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

## Examples

### `4mbl/actions/changeset/pr-comment`

```yaml
name: Changeset PR Comment

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  check-changesets:
    if: github.actor != 'dependabot[bot]'
    runs-on: ubuntu-latest
    steps:
      - name: Changeset reminder comment
        uses: 4mbl/actions/changeset/pr-comment
```
