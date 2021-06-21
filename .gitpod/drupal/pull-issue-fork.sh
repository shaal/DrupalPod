#!/usr/bin/env bash
set -x

# Set WORK_DIR
if [ "$DP_PROJECT_TYPE" == "project_core" ]; then
    WORK_DIR="${GITPOD_REPO_ROOT}"/repos
elif [ "$DP_PROJECT_TYPE" == "project_module" ]; then
    WORK_DIR="${GITPOD_REPO_ROOT}"/web/modules/contrib
    mkdir -p "${WORK_DIR}"
elif [ "$DP_PROJECT_TYPE" == "project_theme" ]; then
    WORK_DIR="${GITPOD_REPO_ROOT}"/web/themes/contrib
    mkdir -p "${WORK_DIR}"
fi

# Clone project
if [ ! -d "${WORK_DIR}"/"$DP_PROJECT_NAME" ]; then
    cd "$WORK_DIR" && git clone https://git.drupalcode.org/project/"$DP_PROJECT_NAME"
fi
WORK_DIR=$WORK_DIR/$DP_PROJECT_NAME

# If branch already exist only run checkout,
if cd "${WORK_DIR}" && git show-ref -q --heads "$DP_BRANCH_NAME"; then
    cd "${WORK_DIR}" && git checkout "$DP_BRANCH_NAME"
else
    cd "${WORK_DIR}" && git remote add "$DP_ISSUE_FORK" git@git.drupal.org:issue/"$DP_ISSUE_FORK".git
    cd "${WORK_DIR}" && git fetch "$DP_ISSUE_FORK"
    cd "${WORK_DIR}" && git checkout -b "$DP_BRANCH_NAME" --track "$DP_ISSUE_FORK"/"$DP_BRANCH_NAME"
fi

# If project type is NOT core, change Drupal core version
if [ "$DP_PROJECT_TYPE" != "project_core" ]; then
    cd "${GITPOD_REPO_ROOT}"/repos/drupal && git checkout "${DP_CORE_VERSION}"
fi

# Ignore specific directories during Drupal core development
cp "${GITPOD_REPO_ROOT}"/.gitpod/drupal/git-exclude.template "${GITPOD_REPO_ROOT}"/.git/info/exclude

# Run composer update to prevent errors when Drupal core major version changed since last composer install
ddev composer update

# Run site install using a Drupal profile if one was defined
if [ -n "$DP_INSTALL_PROFILE" ] && [ "$DP_INSTALL_PROFILE" != "''" ]; then
    ddev drush si "$DP_INSTALL_PROFILE" -y
fi
