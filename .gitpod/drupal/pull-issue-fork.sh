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

if [ -z "$issue_number" ]; then
    issue_number='3042417'
fi

if [ -z "$branch_name" ]; then
    branch_name='3042417-accessible-dropdown-for'
fi

# Set issue_fork
issue_fork=$project_name-$issue_number

# Clone project and set WORK_DIR
if [ $project_type == "core" ]; then
    WORK_DIR="${GITPOD_REPO_ROOT}"/repos
elif [ $project_type == "module" ]; then
    WORK_DIR="${GITPOD_REPO_ROOT}"/web/modules/contrib
    mkdir -p "${WORK_DIR}"
elif [ $project_type == "theme" ]; then
    WORK_DIR="${GITPOD_REPO_ROOT}"/web/themes/contrib
    mkdir -p "${WORK_DIR}"
fi

[ ! -d "${WORK_DIR}"/$project_name ] && cd "$WORK_DIR" && git clone https://git.drupalcode.org/project/$project_name
WORK_DIR=$WORK_DIR/$project_name

if cd "${WORK_DIR}" && git show-ref -q --heads $branch_name; then
    cd "${WORK_DIR}" && git checkout $branch_name
else
    cd "${WORK_DIR}" && git remote add $issue_fork git@git.drupal.org:issue/$issue_fork.git
    cd "${WORK_DIR}" && git fetch $issue_fork
    cd "${WORK_DIR}" && git checkout -b $branch_name --track $issue_fork/$branch_name
fi

if [ $project_type == "core" ]; then
    ddev composer update
fi