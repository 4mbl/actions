#!/usr/bin/env bash
set -euo pipefail

git fetch origin refs/heads/main:refs/remotes/origin/main --tags
target=$(git rev-parse refs/remotes/origin/main)
git switch --detach "$target"

year=$(date -u +%y)
month=$(date -u +%-m)

for entry in \
  'ci-node-pnpm:.github/workflows/ci-node-pnpm.yaml' \
  'ci-bun-bun:.github/workflows/ci-bun-bun.yml' \
  'changeset-comment:.github/workflows/changeset-comment.yml' \
  'changeset-pr-comment:changeset/pr-comment'; do
  component=${entry%%:*}
  path=${entry#*:}
  latest_tag=
  latest_sequence=-1

  while IFS= read -r candidate; do
    if [[ ! $candidate =~ ^${component}/v([0-9]{2})\.([1-9]|1[0-2])\.([0-9]+)$ ]]; then
      continue
    fi

    if [[ -z $latest_tag ]]; then
      latest_tag=$candidate
    fi

    if [[ ${BASH_REMATCH[1]} == "$year" && ${BASH_REMATCH[2]} == "$month" ]]; then
      sequence=${BASH_REMATCH[3]}
      if (( 10#$sequence > latest_sequence )); then
        latest_sequence=$((10#$sequence))
      fi
    fi
  done < <(git tag --list --sort=-version:refname "${component}/v*")

  if [[ -n $latest_tag ]] && git diff --quiet "$latest_tag" "$target" -- "$path"; then
    echo "$component: no changes since $latest_tag"
    continue
  fi

  tag="${component}/v${year}.${month}.$((latest_sequence + 1))"
  git tag "$tag" "$target"
  git push origin "refs/tags/$tag"
  echo "$component: released $tag at $target"
  if [[ -n ${GITHUB_STEP_SUMMARY:-} ]]; then
    echo "- \`$tag\` → \`$target\`" >> "$GITHUB_STEP_SUMMARY"
  fi
done
