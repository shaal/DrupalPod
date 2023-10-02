#!/usr/bin/env bash
set -eu -o pipefail

# Add a special path when working on core contributions
# (Without it, /web/modules/contrib is not found by website)
cd "${GITPOD_REPO_ROOT}" &&
    ddev composer config \
        repositories.drupal-core2 \
        '{"type": "path", "url": "repos/drupal/core"}'

cd "${GITPOD_REPO_ROOT}" &&
    ddev composer config \
        repositories.drupal-core3 \
        '{"type": "path", "url": "repos/drupal/composer/Metapackage/CoreRecommended"}'

cd "${GITPOD_REPO_ROOT}" &&
    ddev composer config \
        repositories.drupal-core4 \
        '{"type": "path", "url": "repos/drupal/composer/Metapackage/DevDependencies"}'

cd "${GITPOD_REPO_ROOT}" &&
    ddev composer config \
        repositories.drupal-core5 \
        '{"type": "path", "url": "repos/drupal/composer/Plugin/ProjectMessage"}'

cd "${GITPOD_REPO_ROOT}" &&
    ddev composer config \
        repositories.drupal-core6 \
        '{"type": "path", "url": "repos/drupal/composer/Plugin/VendorHardening"}'

# Removing the conflict part of composer
echo "$(cat composer.json | jq 'del(.conflict)' --indent 4)" >composer.json

# repos/drupal/vendor -> ../../vendor
if [ ! -L "$GITPOD_REPO_ROOT"/repos/drupal/vendor ]; then
    cd "$GITPOD_REPO_ROOT"/repos/drupal &&
        ln -s ../../vendor .
fi

# Create folders for running tests
mkdir -p "$GITPOD_REPO_ROOT"/web/sites/simpletest
mkdir -p "$GITPOD_REPO_ROOT"/web/sites/simpletest/browser_output

# Symlink the simpletest folder into the Drupal core git repo.
# repos/drupal/sites/simpletest -> ../../../web/sites/simpletest
if [ ! -L "$GITPOD_REPO_ROOT"/repos/drupal/sites/simpletest ]; then
    cd "$GITPOD_REPO_ROOT"/repos/drupal/sites &&
        ln -s ../../../web/sites/simpletest .
fi
