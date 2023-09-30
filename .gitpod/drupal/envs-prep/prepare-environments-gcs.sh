#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

# Load env vars during prebuild using `gp env` command
if [ -n "$GITPOD_HEADLESS" ]; then
    eval "$(gp env -e | grep DP_GOOGLE_ACCESS_KEY)"
    eval "$(gp env -e | grep DP_GOOGLE_SECRET)"
fi

# Establish connection with Google Cloud through Minio client
mc config host add gcs https://storage.googleapis.com "$DP_GOOGLE_ACCESS_KEY" "$DP_GOOGLE_SECRET"

CURRENT_BRANCH="$(cd "$GITPOD_REPO_ROOT" && git branch --show-current)"
READY_MADE_ENV_SOURCE=''

# Check if ready-made envs file exist
if mc find gcs/drupalpod/"$CURRENT_BRANCH"/ready-made-envs.tar.gz; then
    READY_MADE_ENV_SOURCE=gcs/drupalpod/"$CURRENT_BRANCH"/ready-made-envs.tar.gz
elif mc find gcs/drupalpod/main/ready-made-envs.tar.gz; then
    READY_MADE_ENV_SOURCE=gcs/drupalpod/main/ready-made-envs.tar.gz
fi

# Check if ready-made envs file exist
if [ -n "$READY_MADE_ENV_SOURCE" ]; then
    # Download the ready-made envs file
    echo "*** Downloading all the environments"
    echo "Restoring from $READY_MADE_ENV_SOURCE"
    mc cp "$READY_MADE_ENV_SOURCE" /workspace/ready-made-envs.tar.gz

    # Extact the file
    echo "*** Extracting the environments (less than 1 minute)"
    cd /workspace && time tar zxf ready-made-envs.tar.gz --checkpoint=.10000
fi
