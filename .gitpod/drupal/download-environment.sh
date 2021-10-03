#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Download the ready-made envs file
echo "*** Downloading all the environments"
cd /workspace && wget "$DP_READY_MADE_ENVS_URL" > /dev/null

# Extact the file
echo "*** Extracting the environments (less than 1 minute)"
cd /workspace && tar xzvf ready-made-envs.tar.gz > /dev/null
