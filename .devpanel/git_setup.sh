#!/usr/bin/env bash
set -eu -o pipefail

# Add git.drupal.org to known_hosts
mkdir -p ~/.ssh
host=git.drupal.org
SSHKey=$(ssh-keyscan $host 2>/dev/null)
echo "$SSHKey" >>~/.ssh/known_hosts

# Ignore specific directories during Drupal core development
cp "${APP_ROOT}"/.gitpod/drupal/templates/git-exclude.template "${APP_ROOT}"/.git/info/exclude

# Get the required repo ready
if [ "$DP_PROJECT_TYPE" == "project_core" ]; then
    # Find if requested core version is dev or stable
    d="$DP_CORE_VERSION"
    case $d in
    *.x)
        # If dev - use git checkout origin/*
        checkout_type=origin
        ;;
    *)
        # stable - use git checkout tags/*
        checkout_type=tags
        ;;
    esac

    # Clone Drupal core repo
    if git submodule status repos/drupal > /dev/null 2>&1; then
        time git submodule update --init --recursive
    else
        time git submodule add -f https://git.drupalcode.org/project/drupal.git repos/drupal
        time git config -f .gitmodules submodule."repos/drupal".ignore dirty
    fi

    # Use origin or tags in git checkout command
    cd "${APP_ROOT}"/repos/drupal &&
        git fetch origin &&
        git fetch --all --tags &&
        git checkout "$checkout_type"/"$DP_CORE_VERSION"

    # Ignore specific directories during Drupal core development
    cp "${APP_ROOT}"/.gitpod/drupal/templates/git-exclude.template "${APP_ROOT}"/.git/modules/repos/drupal/info/exclude
else
    # If not core - clone selected project into /repos and remove existing repos.
    if git submodule status repos/"$DP_PROJECT_NAME" > /dev/null 2>&1; then
        time git submodule update --init --recursive
    else
        git rm -r repos/*/
        time git submodule add -f https://git.drupalcode.org/project/"$DP_PROJECT_NAME".git repos/"$DP_PROJECT_NAME"
        time git config -f .gitmodules submodule."repos/$DP_PROJECT_NAME".ignore dirty
    fi
fi

# Set WORK_DIR
export WORK_DIR="${APP_ROOT}"/repos/$DP_PROJECT_NAME

# Checkout specific branch only if there's issue_branch
if [ -n "$DP_ISSUE_BRANCH" ]; then
    # If branch already exist only run checkout,
    if cd "${WORK_DIR}" && git show-ref -q --heads "$DP_ISSUE_BRANCH"; then
        cd "${WORK_DIR}" && git checkout "$DP_ISSUE_BRANCH"
    else
        cd "${WORK_DIR}" && git remote add "$DP_ISSUE_FORK" https://git.drupalcode.org/issue/"$DP_ISSUE_FORK".git
        cd "${WORK_DIR}" && git fetch "$DP_ISSUE_FORK"
        cd "${WORK_DIR}" && git checkout -b "$DP_ISSUE_BRANCH" --track "$DP_ISSUE_FORK"/"$DP_ISSUE_BRANCH"
    fi
elif [ -n "$DP_MODULE_VERSION" ] && [ "$DP_PROJECT_TYPE" != "project_core" ]; then
    cd "${WORK_DIR}" && git checkout "$DP_MODULE_VERSION"
fi

git add .
