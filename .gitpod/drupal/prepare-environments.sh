#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Load env vars during prebuild using `gp env` command
if [ -z "$DP_READY_MADE_ENVS_URL" ]; then
    eval "$(gp env -e | grep DP_READY_MADE_ENVS_URL)"
fi

# Check the status of ready-made envs file
# https://stackoverflow.com/a/53358157/5754049
url_status=$(wget --server-response --spider --quiet "${DP_READY_MADE_ENVS_URL}" 2>&1 | awk 'NR==1{print $2}')

if [ "$url_status" = 200 ]; then
    # If ready-made environments file is ready - download and extract it

    # Download the ready-made envs file
    echo "*** Downloading all the environments"
    cd /workspace && wget "$DP_READY_MADE_ENVS_URL" > /dev/null

    # Extact the file
    echo "*** Extracting the environments (less than 1 minute)"
    cd /workspace && tar xzvf ready-made-envs.tar.gz > /dev/null

else
    # If it's not ready - rebuild environment from scratch
    cd "$GITPOD_REPO_ROOT" && time .gitpod/drupal/create-environments.sh
fi
