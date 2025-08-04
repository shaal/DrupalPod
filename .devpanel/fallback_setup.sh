#!/usr/bin/env bash
set -eu -o pipefail

# Set a default setup (when project type is not specified)
export DP_INSTALL_PROFILE='demo_umami'
export DP_PROJECT_TYPE='project_core'
export DP_PROJECT_NAME="drupal"
export DP_CORE_VERSION=${DP_CORE_VERSION:='11.2.2'}
export DP_EXTRA_DEVEL=1
export DP_EXTRA_ADMIN_TOOLBAR=1
