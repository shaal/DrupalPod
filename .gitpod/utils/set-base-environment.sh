#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

# Load default envs
# export "$(grep -v '^#' "$GITPOD_REPO_ROOT"/.env | xargs -d '\n')"

# Clone Drupal core repo
mkdir -p "${GITPOD_REPO_ROOT}"/repos
cd "${GITPOD_REPO_ROOT}"/repos && time git clone https://git.drupalcode.org/project/drupal.git
