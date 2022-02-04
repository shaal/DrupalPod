#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Load default envs
export "$(grep -v '^#' "$GITPOD_REPO_ROOT"/.env | xargs -d '\n')"

# Copying environment of default Drupal core version ($DP_DEFAULT_CORE from .env file)
cd "$GITPOD_REPO_ROOT" && cp -rT ../ready-made-envs/"$DP_DEFAULT_CORE"/. .

# Restoring Umami installation
# @todo: remove `mmariadb_10.3.gz` when https://github.com/drud/ddev/issues/3570 is resolved.
# cd "$GITPOD_REPO_ROOT" && ddev snapshot restore demo_umami
cd "$GITPOD_REPO_ROOT" && ddev snapshot restore demo_umami-mariadb_10.3.gz

# Clear ready-made-envs directory
cd "$GITPOD_REPO_ROOT" && rm -rf ../ready-made-envs

# Clone Drupal core repo
mkdir -p "${GITPOD_REPO_ROOT}"/repos
cd "${GITPOD_REPO_ROOT}"/repos && time git clone https://git.drupalcode.org/project/drupal
