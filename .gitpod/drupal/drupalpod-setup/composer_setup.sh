#!/usr/bin/env bash
set -eu -o pipefail

# For versions end with x - add `-dev` suffix (ie. 9.3.x-dev)
# For versions without x - add `~` prefix (ie. ~9.2.0)
d="$DP_CORE_VERSION"
case $d in
*.x)
    install_version="$d"-dev
    ;;
*)
    install_version=~"$d"
    ;;
esac

# Create required composer.json and composer.lock files
cd "$GITPOD_REPO_ROOT" && time ddev . composer create -n --no-install drupal/recommended-project:"$install_version" temp-composer-files
cp "$GITPOD_REPO_ROOT"/temp-composer-files/* "$GITPOD_REPO_ROOT"/.
rm -rf "$GITPOD_REPO_ROOT"/temp-composer-files

# Programmatically fix Composer 2.2 allow-plugins to avoid errors
ddev composer config --no-plugins allow-plugins.composer/installers true
ddev composer config --no-plugins allow-plugins.drupal/core-project-message true
ddev composer config --no-plugins allow-plugins.drupal/core-vendor-hardening true
ddev composer config --no-plugins allow-plugins.drupal/core-composer-scaffold true

ddev composer config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
ddev composer config --no-plugins allow-plugins.phpstan/extension-installer true

ddev composer config --no-plugins allow-plugins.mglaman/composer-drupal-lenient true

ddev composer config --no-plugins allow-plugins.php-http/discovery true

# Add project source code as symlink (to repos/name_of_project)
# double quotes explained - https://stackoverflow.com/a/1250279/5754049
if [ -n "$DP_PROJECT_NAME" ]; then
    cd "${GITPOD_REPO_ROOT}" &&
        ddev composer config \
            repositories.core1 \
            '{"type": "path", "url": "repos/'"$DP_PROJECT_NAME"'", "options": {"symlink": true}}'

    cd "$GITPOD_REPO_ROOT" &&
        ddev composer config minimum-stability dev
fi
