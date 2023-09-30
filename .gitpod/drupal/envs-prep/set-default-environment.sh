#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

# Load default envs
export "$(grep -v '^#' "$GITPOD_REPO_ROOT"/.env | xargs -d '\n')"

# Copying environment of default Drupal core version ($DP_DEFAULT_CORE from .env file)
cd "$GITPOD_REPO_ROOT" && cp -rT ../ready-made-envs/"$DP_DEFAULT_CORE"/. .

# Restoring Umami installation
cd "$GITPOD_REPO_ROOT" && ddev snapshot restore demo_umami

# Clear ready-made-envs directory
cd "$GITPOD_REPO_ROOT" && rm -rf ../ready-made-envs

# Clone Drupal core repo
mkdir -p "${GITPOD_REPO_ROOT}"/repos
cd "${GITPOD_REPO_ROOT}"/repos && time git clone https://git.drupalcode.org/project/drupal.git
