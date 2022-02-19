#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

# Set a specific branch if there's issue_fork
if [ -n "$DP_ISSUE_FORK" ]; then
    cd "${GITPOD_REPO_ROOT}"/repos/"$DP_PROJECT_NAME" && git remote set-url "$DP_ISSUE_FORK" git@git.drupal.org:issue/"$DP_ISSUE_FORK".git
fi
