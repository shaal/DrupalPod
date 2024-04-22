#!/usr/bin/env bash
set -eu -o pipefail

# set PHP version, based on https://www.drupal.org/docs/getting-started/system-requirements/php-requirements#versions
major_version=$(echo "$DP_CORE_VERSION" | cut -d '.' -f 1)
minor_version=$(echo "$DP_CORE_VERSION" | cut -d '.' -f 2)

# Before Drupal 10.2, we should use php 8.2, otherwise use php 8.3
if (( major_version < 10 )) || { (( major_version == 10 )) && (( minor_version < 2 )); }; then
    php_version="8.2"
else
    php_version="8.3"
fi

cat <<CONFIGEND > "${GITPOD_REPO_ROOT}"/.ddev/config.gitpod.yaml
#ddev-gitpod-generated
php_version: "$php_version"
CONFIGEND

time ddev start
