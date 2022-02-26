#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

git apply --directory=web -v src/composer-drupal-core-setup/scaffold-patch-index-and-update-php.patch

# Run patch for Drush only once
if [ ! -f ./vendor/drush/drush/src/Commands/core/.drush-patched.status ]; then
    git apply -v src/composer-drupal-core-setup/drush-cr-when-core-is-symlinked.patch
    touch ./vendor/drush/drush/src/Commands/core/.drush-patched.status
fi
