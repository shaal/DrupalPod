#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

cd "${GITPOD_REPO_ROOT}" && ddev composer install
cd "${GITPOD_REPO_ROOT}" && ddev drush si -y --account-pass=admin --site-name="DrupalPod" demo_umami
