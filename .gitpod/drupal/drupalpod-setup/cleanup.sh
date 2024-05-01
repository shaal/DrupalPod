#!/usr/bin/env bash
set -eu -o pipefail

# Remove site that was installed before (for debugging)
rm -rf "${GITPOD_REPO_ROOT}"/web
rm -rf "${GITPOD_REPO_ROOT}"/vendor
rm -f "${GITPOD_REPO_ROOT}"/composer.json
rm -f "${GITPOD_REPO_ROOT}"/composer.lock
