#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

git apply --directory=web -v src/composer-drupal-core-setup/scaffold-patch-index-and-update-php.patch
