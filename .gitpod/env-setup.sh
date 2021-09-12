#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Create a phpstorm command
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/phpstorm.template.sh /usr/local/bin/phpstorm

# Create a preview command
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/preview.template.sh /usr/local/bin/preview
