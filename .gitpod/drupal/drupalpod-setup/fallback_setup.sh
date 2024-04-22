#!/usr/bin/env bash

# Set a default setup if project type wasn't specified
if [ -z "$DP_PROJECT_TYPE" ]; then
    export DP_INSTALL_PROFILE='demo_umami'
    export DP_PROJECT_TYPE='project_core'
    export DP_PROJECT_NAME="drupal"
    export DP_CORE_VERSION='10.2.5'
    export DP_EXTRA_DEVEL=1
    export DP_EXTRA_ADMIN_TOOLBAR=1
fi
