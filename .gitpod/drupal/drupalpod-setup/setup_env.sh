#!/usr/bin/env bash

# Load default envs
export "$(grep -v '^#' "$GITPOD_REPO_ROOT"/.env | xargs -d '\n')"

# Set the default setup during prebuild process
if [ -n "$GITPOD_HEADLESS" ]; then
    export DP_INSTALL_PROFILE='demo_umami'
    export DP_EXTRA_DEVEL=1
    export DP_EXTRA_ADMIN_TOOLBAR=1
    export DP_PROJECT_TYPE='default_drupalpod'
fi
