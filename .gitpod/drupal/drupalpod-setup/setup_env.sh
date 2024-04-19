#!/usr/bin/env bash

# Set the default setup during prebuild process
if [ -z "$DP_PROJECT_TYPE" ]; then
    export DP_INSTALL_PROFILE='demo_umami'
    export DP_EXTRA_DEVEL=1
    export DP_EXTRA_ADMIN_TOOLBAR=1
fi
