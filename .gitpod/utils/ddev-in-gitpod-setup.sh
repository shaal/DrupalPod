#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# If this is an issue fork of Drupal core - set the drupal core version based on that issue fork
if [ "$DP_PROJECT_TYPE" == "project_core" ] && [ -n "$DP_ISSUE_FORK" ]; then
    export VERSION_FROM_GIT=$(grep 'const VERSION' repos/drupal/core/lib/Drupal.php | awk -F "'" '{print $2}')
fi

# set PHP version, based on https://www.drupal.org/docs/getting-started/system-requirements/php-requirements#versions
major_version=$(echo $VERSION_FROM_GIT | cut -d '.' -f 1)
minor_version=$(echo $VERSION_FROM_GIT | cut -d '.' -f 2)

# Before Drupal 10.2, we should use php 8.2, otherwise use php 8.3
if (( major_version < 10 )) || { (( major_version == 10 )) && (( minor_version < 2 )); }; then
    php_version="8.2"
else
    php_version="8.3"
fi

cat <<CONFIGEND > .ddev/config.gitpod.yaml
#ddev-gitpod-generated
php_version: "$php_version"
CONFIGEND

# Misc housekeeping before start
ddev config global --instrumentation-opt-in=true
