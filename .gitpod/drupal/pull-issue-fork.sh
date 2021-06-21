#!/usr/bin/env bash
set -x

if [ -z "$DP_PROJECT_TYPE" ]; then 
    DP_PROJECT_TYPE='core'
fi

# Set to Drupal core if not DP_PROJECT_NAME is empty
if [ -z "$DP_PROJECT_NAME" ]; then 
    DP_PROJECT_TYPE='core'
    DP_PROJECT_NAME='drupal'
fi

if [ -z "$DP_BRANCH_NAME" ]; then
    DP_BRANCH_NAME='3042417-accessible-dropdown-for'
fi

# Set DP_ISSUE_FORK
if [ -z "$DP_ISSUE_FORK" ]; then
    DP_ISSUE_FORK=drupal-3042417
fi

# Set WORK_DIR
if [ $DP_PROJECT_TYPE == "core" ]; then
    WORK_DIR="${GITPOD_REPO_ROOT}"/repos
elif [ $DP_PROJECT_TYPE == "module" ]; then
    WORK_DIR="${GITPOD_REPO_ROOT}"/web/modules/contrib
    mkdir -p "${WORK_DIR}"
elif [ $DP_PROJECT_TYPE == "theme" ]; then
    WORK_DIR="${GITPOD_REPO_ROOT}"/web/themes/contrib
    mkdir -p "${WORK_DIR}"
fi

# Clone project
if [ ! -d "${WORK_DIR}"/$DP_PROJECT_NAME ]; then
    cd "$WORK_DIR" && git clone https://git.drupalcode.org/project/$DP_PROJECT_NAME
fi
WORK_DIR=$WORK_DIR/$DP_PROJECT_NAME

# If branch already exist only run checkout,
if cd "${WORK_DIR}" && git show-ref -q --heads $DP_BRANCH_NAME; then
    cd "${WORK_DIR}" && git checkout $DP_BRANCH_NAME
else
    cd "${WORK_DIR}" && git remote add $DP_ISSUE_FORK git@git.drupal.org:issue/$DP_ISSUE_FORK.git
    cd "${WORK_DIR}" && git fetch $DP_ISSUE_FORK
    cd "${WORK_DIR}" && git checkout -b $DP_BRANCH_NAME --track $DP_ISSUE_FORK/$DP_BRANCH_NAME
fi

# If project type is NOT core, change Drupal core version
if [ $DP_PROJECT_TYPE != "core" ]; then
    # If no Drupal core version set, use version 9.2.x by default 
    if [ -z "$DP_CORE_VERSION" ]; then
        DP_CORE_VERSION=9.2.x
    fi
    cd "${GITPOD_REPO_ROOT}"/repos/drupal && git checkout "${DP_CORE_VERSION}"
fi

# Ignore specific directories during Drupal core development
cp .gitpod/drupal/git-exclude.template .git/modules/drupal/info/exclude

# Run composer update to prevent errors when Drupal core major version changed since last composer install
ddev composer update

# Run site install using a Drupal profile if one was defined
if [ -n "$DP_INSTALL_PROFILE" ] && [ "$DP_INSTALL_PROFILE" != "(none)" ]; then
    ddev drush si "$DP_INSTALL_PROFILE" -y
fi
