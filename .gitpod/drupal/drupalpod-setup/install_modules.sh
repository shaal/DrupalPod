#!/usr/bin/env bash

# Check if additional modules should be installed
export DEVEL_NAME="devel"
export DEVEL_PACKAGE="drupal/devel:^5"

export ADMIN_TOOLBAR_NAME="admin_toolbar_tools"
export ADMIN_TOOLBAR_PACKAGE="drupal/admin_toolbar:^3.1"

# TODO: once Drupalpod extension supports additional modules - remove these 2 lines
export DP_EXTRA_DEVEL=1
export DP_EXTRA_ADMIN_TOOLBAR=1
