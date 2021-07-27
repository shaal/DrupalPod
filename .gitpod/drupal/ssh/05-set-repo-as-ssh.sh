#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Default settings (latest stable Drupal core)
if [ -z "$DP_PROJECT_TYPE" ]; then
    DP_PROJECT_TYPE=project_core
fi

# Set WORK_DIR
if [ "$DP_PROJECT_TYPE" == "project_core" ]; then
    BASE_PROJECT_DIR=web/core
    WORK_DIR="${GITPOD_REPO_ROOT}"/"$BASE_PROJECT_DIR"
elif [ "$DP_PROJECT_TYPE" == "project_module" ]; then
    BASE_PROJECT_DIR=web/modules/contrib
    WORK_DIR="${GITPOD_REPO_ROOT}"/"$BASE_PROJECT_DIR"
elif [ "$DP_PROJECT_TYPE" == "project_theme" ]; then
    BASE_PROJECT_DIR=web/themes/contrib
    WORK_DIR="${GITPOD_REPO_ROOT}"/"$BASE_PROJECT_DIR"
fi

RELATIVE_WORK_DIR=$BASE_PROJECT_DIR/$DP_PROJECT_NAME
WORK_DIR="${GITPOD_REPO_ROOT}"/$RELATIVE_WORK_DIR

# Set a specific branch if there's issue_fork
if [ -n "$DP_ISSUE_FORK" ]; then
    cd "${WORK_DIR}" && git remote set-url "$DP_ISSUE_FORK" git@git.drupal.org:issue/"$DP_ISSUE_FORK".git
fi