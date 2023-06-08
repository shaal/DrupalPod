#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Drupal v11 requires a different patch than v9 and v10.
if [ "$DP_CORE_VERSION" = "11.x" ]; then
    PATCH_FILE="scaffold-patch-index-and-update-php-drupal-11.patch"
else
    PATCH_FILE="scaffold-patch-index-and-update-php.patch"
fi

# Apply patch to core index.php and update.php
# This is needed to make the core index.php and update.php work with the
# composer-drupal-core-setup project.

git apply --directory=web -v src/composer-drupal-core-setup/$PATCH_FILE
