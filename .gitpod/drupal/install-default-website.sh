#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Check if additional modules should be installed
if [ -z "$DP_EXTRA_DEVEL" ]; then
    DEVEL_NAME="devel"
    DEVEL_PACKAGE="drupal/devel"
    EXTRA_MODULES=1
fi

if [ -z "$DP_EXTRA_ADMIN_TOOLBAR" ]; then
    ADMIN_TOOLBAR_NAME="admin_toolbar_tools"
    ADMIN_TOOLBAR_PACKAGE="drupal/admin_toolbar"
    EXTRA_MODULES=1
fi

# Run this in recommended mode
if [ -z "$DP_SETUP_MODE" ] || [ "$DP_SETUP_MODE" == 'recommended' ]; then
    cd "${GITPOD_REPO_ROOT}" && cp .gitpod/drupal/templates/drupal-recommended-project-composer.json composer.json
    # Check if a specific Drupal core version should be installed
    if [ -n "$DP_CORE_VERSION" ]; then
        cd "${GITPOD_REPO_ROOT}" && ddev composer require --no-update "drupal/core-composer-scaffold:""$DP_CORE_VERSION" "drupal/core-project-message:""$DP_CORE_VERSION" "drupal/core-recommended:""$DP_CORE_VERSION"
    fi

    # Install Drush
    cd "${GITPOD_REPO_ROOT}" && ddev composer require --no-update drush/drush:^10

    # Check if any additional modules should be installed
    if [ -n "$EXTRA_MODULES" ]; then
        cd "${GITPOD_REPO_ROOT}" && \
        ddev composer require --no-update \
        "$DEVEL_PACKAGE" \
        "$ADMIN_TOOLBAR_PACKAGE"
    fi
else
    cd "${GITPOD_REPO_ROOT}" && cp .gitpod/drupal/templates/drupal-core-development-composer.json composer.json
    ddev composer run post-root-package-install
fi

cd "${GITPOD_REPO_ROOT}" && ddev composer install
cd "${GITPOD_REPO_ROOT}" && ddev drush si -y --account-pass=admin --site-name="DrupalPod" demo_umami

# Enabale extra modules
if [ -n "$EXTRA_MODULES" ]; then
    cd "${GITPOD_REPO_ROOT}" && \
    ddev drush en -y \
    "$DEVEL_NAME" \
    "$ADMIN_TOOLBAR_NAME"
fi

# Enable Claro as default admin theme
cd "${GITPOD_REPO_ROOT}" && ddev drush then claro
cd "${GITPOD_REPO_ROOT}" && ddev drush config-set -y system.theme admin claro