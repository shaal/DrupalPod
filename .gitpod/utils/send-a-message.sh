#!/usr/bin/env bash

# Get current user and current branch
branch_user="$GITPOD_GIT_USER_NAME, $(git branch --show-current)"

# Load env vars during prebuild using `gp env` command
if [ -z "$DP_READY_MADE_ENVS_URL" ]; then
    eval "$(gp env -e | grep DP_READY_MADE_ENVS_URL)"
fi

# Load env vars during prebuild using `gp env` command
if [ -z "$IFTTT_TOKEN" ]; then
    eval "$(gp env -e | grep IFTTT_TOKEN)"
fi

# Check the status of ready-made envs file
# https://stackoverflow.com/a/53358157/5754049
url_status=$(wget --server-response --spider --quiet "${DP_READY_MADE_ENVS_URL}" 2>&1 | awk 'NR==1{print $2}')

# If there's a problem send the error code
if [ "$url_status" = '200' ]; then
    message="100%"
else
    message="Error: $url_status - $DP_READY_MADE_ENVS_URL"
fi

# Send a message through IFTTT
curl -X POST -H "Content-Type: application/json" -d "{\"value1\":\"$branch_user\",\"value2\":\"$message\"}" https://maker.ifttt.com/trigger/drupalpod_prebuild_initiated/with/key/"$IFTTT_TOKEN"
