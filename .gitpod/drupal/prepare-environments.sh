#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Download the ready-made envs file
file=$(<"$GITPOD_REPO_ROOT"/.gitpod/drupal/ready-made-envs-url.txt)
echo "*** Downloading all the environments"
cd /workspace && wget "$file" > /dev/null

# Extact the file
echo "*** Extracting the environments (less than 1 minute)"
cd /workspace && tar xzvf ready-made-envs.tar.gz > /dev/null
