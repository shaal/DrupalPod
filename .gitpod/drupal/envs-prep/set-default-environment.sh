#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Copying environment of latest stable Drupal version
cd "$GITPOD_REPO_ROOT" && cp -rT ../ready-made-envs/~9.2.0/. .

# Restoring Umami installation
cd "$GITPOD_REPO_ROOT" && ddev snapshot restore demo_umami

# Clone Drupal core repo
mkdir -p "${GITPOD_REPO_ROOT}"/repos
cd "${GITPOD_REPO_ROOT}"/repos && time git clone https://git.drupalcode.org/project/drupal
