#!/usr/bin/env bash

# Get current user and current branch
branch_user="$GITPOD_GIT_USER_NAME, $(git branch --show-current)"

# Load env vars during prebuild using `gp env` command
if [ -z "$IFTTT_TOKEN" ]; then
    eval "$(gp env -e | grep IFTTT_TOKEN)"
fi

# Load env vars during prebuild using `gp env` command
if [ -z "$DP_GOOGLE_ACCESS_KEY" ]; then
    eval "$(gp env -e | grep DP_GOOGLE_ACCESS_KEY)"
fi

# Load env vars during prebuild using `gp env` command
if [ -z "$DP_GOOGLE_SECRET" ]; then
    eval "$(gp env -e | grep DP_GOOGLE_SECRET)"
fi

# Establish connection with Google Cloud through Minio client
mc config host add gcs https://storage.googleapis.com "$DP_GOOGLE_ACCESS_KEY" "$DP_GOOGLE_SECRET"

# If there's a problem send the error code
if mc find gcs/drupalpod/ready-made-envs.tar.gz; then
    message="Success: Google Cloud is ready"
else
    message="Error: Envs file wasn't found, it will be recreated"
fi

# Send a message through IFTTT
curl -X POST -H "Content-Type: application/json" -d "{\"value1\":\"$branch_user\",\"value2\":\"$message\"}" https://maker.ifttt.com/trigger/drupalpod_prebuild_initiated/with/key/"$IFTTT_TOKEN"
