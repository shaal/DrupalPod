#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Check the status of ready-made envs file
# https://stackoverflow.com/a/53358157/5754049
url_status=$(wget --server-response --spider --quiet "${DP_READY_MADE_ENVS_URL}" 2>&1 | awk 'NR==1{print $2}')

if [ "$url_status" = 200 ]; then
    # If ready-made environments file is ready - download and extract it
    echo "*** Downloading ready-made environments"
    cd "$GITPOD_REPO_ROOT" && time .gitpod/drupal/download-environment.sh
else
    # If it's not ready - rebuild environment from scratch
    echo "*** Rebuilding ready-made environments from scratch, this will take 25 minutes..."
    cd "$GITPOD_REPO_ROOT" && time .gitpod/drupal/create-environment.sh
fi
