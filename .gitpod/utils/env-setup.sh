#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Create a phpstorm command
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/utils/phpstorm.template.sh /usr/local/bin/phpstorm

# Create a preview command
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/utils/preview.template.sh /usr/local/bin/preview

# Create a protect-my-git command
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/utils/protect-my-git.template.sh /usr/local/bin/protect-my-git
