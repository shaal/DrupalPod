#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Run initial setup for special Drupal core structure (clone Drupal core repo during prebuild)
ddev composer run-script post-root-package-install

# Create a phpstorm command
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/phpstorm.template.sh /usr/local/bin/phpstorm
