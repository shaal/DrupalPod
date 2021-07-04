#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Set WORK_DIR
if [ "$DP_PROJECT_TYPE" == "project_core" ]; then
    RELATIVE_WORK_DIR=repos
    WORK_DIR="${GITPOD_REPO_ROOT}"/"$RELATIVE_WORK_DIR"
    mkdir -p "${WORK_DIR}"
elif [ "$DP_PROJECT_TYPE" == "project_module" ]; then
    RELATIVE_WORK_DIR=web/modules/contrib
    WORK_DIR="${GITPOD_REPO_ROOT}"/"$RELATIVE_WORK_DIR"
    mkdir -p "${WORK_DIR}"
elif [ "$DP_PROJECT_TYPE" == "project_theme" ]; then
    RELATIVE_WORK_DIR=web/themes/contrib
    WORK_DIR="${GITPOD_REPO_ROOT}"/"$RELATIVE_WORK_DIR"
    mkdir -p "${WORK_DIR}"
fi

RELATIVE_WORK_DIR=$RELATIVE_WORK_DIR/$DP_PROJECT_NAME
WORK_DIR="${GITPOD_REPO_ROOT}"/$RELATIVE_WORK_DIR

# Set a specific branch if there's issue_fork
if [ -n "$DP_ISSUE_FORK" ]; then
    cd "${WORK_DIR}" && git remote set-url "$DP_ISSUE_FORK" git@git.drupal.org:issue/"$DP_ISSUE_FORK".git
fi