#!/usr/bin/env bash
set -x

if [ -z "$project_type" ]; then 
    project_type='core'
fi

# Set to Drupal core if not project_name is empty
if [ -z "$project_name" ]; then 
    project_type='core'
    project_name='drupal'
fi

if [ -z "$branch_name" ]; then
    branch_name='3042417-accessible-dropdown-for'
fi

# Set issue_fork
if [ -z "$issue_fork" ]; then
    issue_fork=drupal-3042417
fi

# Set WORK_DIR
if [ $project_type == "core" ]; then
    WORK_DIR="${GITPOD_REPO_ROOT}"/repos
elif [ $project_type == "module" ]; then
    WORK_DIR="${GITPOD_REPO_ROOT}"/web/modules/contrib
    mkdir -p "${WORK_DIR}"
elif [ $project_type == "theme" ]; then
    WORK_DIR="${GITPOD_REPO_ROOT}"/web/themes/contrib
    mkdir -p "${WORK_DIR}"
fi

# Clone project
if [ ! -d "${WORK_DIR}"/$project_name ]; then
    cd "$WORK_DIR" && git clone https://git.drupalcode.org/project/$project_name
fi
WORK_DIR=$WORK_DIR/$project_name

# If branch already exist only run checkout,
if cd "${WORK_DIR}" && git show-ref -q --heads $branch_name; then
    cd "${WORK_DIR}" && git checkout $branch_name
else
    cd "${WORK_DIR}" && git remote add $issue_fork git@git.drupal.org:issue/$issue_fork.git
    cd "${WORK_DIR}" && git fetch $issue_fork
    cd "${WORK_DIR}" && git checkout -b $branch_name --track $issue_fork/$branch_name
fi

# If project type is NOT core, change Drupal core version
if [ $project_type != "core" ]; then
    # If no Drupal core version set, use version 9.2.x by default 
    if [ -z "$core_version" ]; then
        core_version=9.2.x
    fi
    cd "${GITPOD_REPO_ROOT}"/repos/drupal && git checkout "${core_version}"
fi

# Ignore specific directories during Drupal core development
cp .gitpod/drupal/git-exclude.template repos/drupal/.git/info/exclude

# Run composer update to prevent errors when Drupal core major version changed since last composer install
ddev composer update

# Run site install using a Drupal profile if one was defined
if [ -n "$install_profile" ] && [ "$install_profile" != "(none)" ]; then
    ddev drush si "$install_profile"
fi
