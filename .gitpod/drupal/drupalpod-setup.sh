#!/usr/bin/env bash
set -eu -o pipefail

# Initialize all variables with '' if they do not exist
: "${DEBUG_SCRIPT:=}"
: "${GITPOD_HEADLESS:=}"
: "${DP_INSTALL_PROFILE:=}"
: "${DP_EXTRA_DEVEL:=}"
: "${DP_EXTRA_ADMIN_TOOLBAR:=}"
: "${DP_PROJECT_TYPE:=}"
: "${DEVEL_NAME:=}"
: "${DEVEL_PACKAGE:=}"
: "${ADMIN_TOOLBAR_NAME:=}"
: "${ADMIN_TOOLBAR_PACKAGE:=}"
: "${COMPOSER_DRUPAL_LENIENT:=}"
: "${DP_CORE_VERSION:=}"
: "${DP_ISSUE_BRANCH:=}"
: "${DP_ISSUE_FORK:=}"
: "${DP_MODULE_VERSION:=}"
: "${DP_PATCH_FILE:=}"

if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

time ddev start

# Measure the time it takes to go through the script
script_start_time=$(date +%s)

# Set the default setup during prebuild process
if [ -n "$GITPOD_HEADLESS" ]; then
    export DP_INSTALL_PROFILE='demo_umami'
    export DP_EXTRA_DEVEL=1
    export DP_EXTRA_ADMIN_TOOLBAR=1
    export DP_PROJECT_TYPE='default_drupalpod'
fi

# Check if additional modules should be installed
export DEVEL_NAME="devel"
export DEVEL_PACKAGE="drupal/devel"

export ADMIN_TOOLBAR_NAME="admin_toolbar_tools"
export ADMIN_TOOLBAR_PACKAGE="drupal/admin_toolbar"

# TODO: once Drupalpod extension supports additional modules - remove these 2 lines
export DP_EXTRA_DEVEL=1
export DP_EXTRA_ADMIN_TOOLBAR=1

# Adding support for composer-drupal-lenient - https://packagist.org/packages/mglaman/composer-drupal-lenient
if [[ "$DP_CORE_VERSION" == 10* ]]; then
    # admin_toolbar not compatible yet with Drupal 10
    # unset DP_EXTRA_ADMIN_TOOLBAR
    if [ "$DP_PROJECT_TYPE" != "project_core" ]; then
        export COMPOSER_DRUPAL_LENIENT=mglaman/composer-drupal-lenient
    else
        export COMPOSER_DRUPAL_LENIENT=''
    fi
fi

# Skip setup if it already ran once and if no special setup is set by DrupalPod extension
if [ ! -f "${GITPOD_REPO_ROOT}"/.drupalpod_initiated ] && [ -n "$DP_PROJECT_TYPE" ]; then

    # Add git.drupal.org to known_hosts
    if [ -z "$GITPOD_HEADLESS" ]; then
        mkdir -p ~/.ssh
        host=git.drupal.org
        SSHKey=$(ssh-keyscan $host 2>/dev/null)
        echo "$SSHKey" >>~/.ssh/known_hosts
    fi

    # Ignore specific directories during Drupal core development
    cp "${GITPOD_REPO_ROOT}"/.gitpod/drupal/templates/git-exclude.template "${GITPOD_REPO_ROOT}"/.git/info/exclude

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

        # Use origin or tags in git checkout command
        cd "${GITPOD_REPO_ROOT}"/repos/drupal &&
            git fetch origin &&
            git fetch --all --tags &&
            git checkout "$checkout_type"/"$DP_CORE_VERSION"

        # Ignore specific directories during Drupal core development
        cp "${GITPOD_REPO_ROOT}"/.gitpod/drupal/templates/git-exclude.template "${GITPOD_REPO_ROOT}"/repos/drupal/.git/info/exclude
    else
        # If not core - clone selected project into /repos and remove drupal core
        rm -rf "${GITPOD_REPO_ROOT}"/repos/drupal
        cd "${GITPOD_REPO_ROOT}"/repos && time git clone https://git.drupalcode.org/project/"$DP_PROJECT_NAME".git
    fi

    # Set WORK_DIR
    export WORK_DIR="${GITPOD_REPO_ROOT}"/repos/$DP_PROJECT_NAME

    # Dynamically generate .gitmodules file
    cat <<GITMODULESEND >"${GITPOD_REPO_ROOT}"/.gitmodules
# This file was dynamically generated by a script
[submodule "$DP_PROJECT_NAME"]
    path = repos/$DP_PROJECT_NAME
    url = https://git.drupalcode.org/project/$DP_PROJECT_NAME.git
    ignore = dirty
GITMODULESEND

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

    # Remove site that was installed before (for debugging)
    rm -rf "${GITPOD_REPO_ROOT}"/web
    rm -rf "${GITPOD_REPO_ROOT}"/vendor
    rm -f "${GITPOD_REPO_ROOT}"/composer.json
    rm -f "${GITPOD_REPO_ROOT}"/composer.lock

    # For versions end with x - add `-dev` suffix (ie. 9.3.x-dev)
    # For versions without x - add `~` prefix (ie. ~9.2.0)
    d="$DP_CORE_VERSION"
    case $d in
    *.x)
        install_version="$d"-dev
        ;;
    *)
        install_version=~"$d"
        ;;
    esac

    # Create required composer.json and composer.lock files
    cd "$GITPOD_REPO_ROOT" && time ddev . composer create -n --no-install drupal/recommended-project:"$install_version" temp-composer-files
    cp "$GITPOD_REPO_ROOT"/temp-composer-files/* "$GITPOD_REPO_ROOT"/.
    rm -rf "$GITPOD_REPO_ROOT"/temp-composer-files

    if [ -n "$DP_PATCH_FILE" ]; then
    echo found patch file
        echo Applying selected patch "$DP_PATCH_FILE"
        cd "${WORK_DIR}" && curl "$DP_PATCH_FILE" | patch -p1
    else
        echo did not find
    fi

    # Programmatically fix Composer 2.2 allow-plugins to avoid errors
    ddev composer config --no-plugins allow-plugins.composer/installers true
    ddev composer config --no-plugins allow-plugins.drupal/core-project-message true
    ddev composer config --no-plugins allow-plugins.drupal/core-vendor-hardening true
    ddev composer config --no-plugins allow-plugins.drupal/core-composer-scaffold true

    ddev composer config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
    ddev composer config --no-plugins allow-plugins.phpstan/extension-installer true

    ddev composer config --no-plugins allow-plugins.mglaman/composer-drupal-lenient true

    ddev composer config --no-plugins allow-plugins.php-http/discovery true

    # Add project source code as symlink (to repos/name_of_project)
    # double quotes explained - https://stackoverflow.com/a/1250279/5754049
    if [ -n "$DP_PROJECT_NAME" ]; then
        cd "${GITPOD_REPO_ROOT}" &&
            ddev composer config \
                repositories.core1 \
                '{"type": "path", "url": "repos/'"$DP_PROJECT_NAME"'", "options": {"symlink": true}}'

        cd "$GITPOD_REPO_ROOT" &&
            ddev composer config minimum-stability dev
    fi

    # Prepare special setup to work with Drupal core
    if [ "$DP_PROJECT_TYPE" == "project_core" ]; then
        # Add a special path when working on core contributions
        # (Without it, /web/modules/contrib is not found by website)
        cd "${GITPOD_REPO_ROOT}" &&
            ddev composer config \
                repositories.drupal-core2 \
                '{"type": "path", "url": "repos/drupal/core"}'

        cd "${GITPOD_REPO_ROOT}" &&
            ddev composer config \
                repositories.drupal-core3 \
                '{"type": "path", "url": "repos/drupal/composer/Metapackage/CoreRecommended"}'

        cd "${GITPOD_REPO_ROOT}" &&
            ddev composer config \
                repositories.drupal-core4 \
                '{"type": "path", "url": "repos/drupal/composer/Metapackage/DevDependencies"}'

        cd "${GITPOD_REPO_ROOT}" &&
            ddev composer config \
                repositories.drupal-core5 \
                '{"type": "path", "url": "repos/drupal/composer/Plugin/ProjectMessage"}'

        cd "${GITPOD_REPO_ROOT}" &&
            ddev composer config \
                repositories.drupal-core6 \
                '{"type": "path", "url": "repos/drupal/composer/Plugin/VendorHardening"}'

        # Removing the conflict part of composer
        echo "$(cat composer.json | jq 'del(.conflict)' --indent 4)" >composer.json

        # repos/drupal/vendor -> ../../vendor
        if [ ! -L "$GITPOD_REPO_ROOT"/repos/drupal/vendor ]; then
            cd "$GITPOD_REPO_ROOT"/repos/drupal &&
                ln -s ../../vendor .
        fi

        # Create folders for running tests
        mkdir -p "$GITPOD_REPO_ROOT"/web/sites/simpletest
        mkdir -p "$GITPOD_REPO_ROOT"/web/sites/simpletest/browser_output

        # Symlink the simpletest folder into the Drupal core git repo.
        # repos/drupal/sites/simpletest -> ../../../web/sites/simpletest
        if [ ! -L "$GITPOD_REPO_ROOT"/repos/drupal/sites/simpletest ]; then
            cd "$GITPOD_REPO_ROOT"/repos/drupal/sites &&
                ln -s ../../../web/sites/simpletest .
        fi
    elif [ -n "$DP_PROJECT_NAME" ]; then
        # Drupal projects with no composer.json, bypass the symlink config, symlink has to be created manually.

        if [ "$DP_PROJECT_TYPE" == "project_module" ]; then
            PROJECT_TYPE=modules
        elif [ "$DP_PROJECT_TYPE" == "project_theme" ]; then
            PROJECT_TYPE=themes
        fi

        cat <<PROJECTASYMLINK >"${GITPOD_REPO_ROOT}"/repos/add-project-as-symlink.sh
#!/usr/bin/env bash
# This file was dynamically generated by a script
echo "Replace project with a symlink"
rm -rf web/$PROJECT_TYPE/contrib/$DP_PROJECT_NAME
cd web/$PROJECT_TYPE/contrib && ln -s ../../../repos/$DP_PROJECT_NAME .
PROJECTASYMLINK

        chmod +x "${GITPOD_REPO_ROOT}"/repos/add-project-as-symlink.sh

        echo "$(cat composer.json | jq '.scripts."post-install-cmd" |= . + ["repos/add-project-as-symlink.sh"]')" >composer.json
        echo "$(cat composer.json | jq '.scripts."post-update-cmd" |= . + ["repos/add-project-as-symlink.sh"]')" >composer.json

        if [ -n "$COMPOSER_DRUPAL_LENIENT" ]; then
            # Add composer_drupal_lenient for modules on Drupal 10
            cd "${GITPOD_REPO_ROOT}" && ddev composer config --merge --json extra.drupal-lenient.allowed-list '["drupal/'"$DP_PROJECT_NAME"'"]'
            cd "${GITPOD_REPO_ROOT}" && time ddev . composer require "$COMPOSER_DRUPAL_LENIENT" --no-install
        fi
        # Add the project to composer (it will get the version according to the branch under `/repo/name_of_project`)
        cd "${GITPOD_REPO_ROOT}" && time ddev . composer require drupal/"$DP_PROJECT_NAME" --no-install
    fi

    time "${GITPOD_REPO_ROOT}"/.gitpod/drupal/install-essential-packages.sh
    # Configure phpcs for drupal.
    cd "$GITPOD_REPO_ROOT" &&
        vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer

    # New site install
    ddev drush si -y --account-pass=admin --site-name="DrupalPod" "$DP_INSTALL_PROFILE"

    # Install devel and admin_toolbar modules
    if [ "$DP_EXTRA_DEVEL" != '1' ]; then
        unset DEVEL_NAME
    fi
    if [ "$DP_EXTRA_ADMIN_TOOLBAR" != '1' ]; then
        unset ADMIN_TOOLBAR_NAME
    fi

    # Enable extra modules
    cd "${GITPOD_REPO_ROOT}" &&
        ddev drush en -y \
            "$ADMIN_TOOLBAR_NAME" \
            "$DEVEL_NAME"

    # Enable the requested module
    if [ "$DP_PROJECT_TYPE" == "project_module" ]; then
        cd "${GITPOD_REPO_ROOT}" && ddev drush en -y "$DP_PROJECT_NAME"
    fi

    # Enable the requested theme
    if [ "$DP_PROJECT_TYPE" == "project_theme" ]; then
        cd "${GITPOD_REPO_ROOT}" && ddev drush then -y "$DP_PROJECT_NAME"
        cd "${GITPOD_REPO_ROOT}" && ddev drush config-set -y system.theme default "$DP_PROJECT_NAME"
    fi

    # Take a snapshot
    cd "${GITPOD_REPO_ROOT}" && ddev snapshot
    echo "Your database state was locally saved, you can revert to it by typing:"
    echo "ddev snapshot restore --latest"

    # Only for Drupal core - apply special patch
    if [ "$DP_PROJECT_TYPE" == "project_core" ]; then
        # Patch the scaffold index.php and update.php files
        # See https://www.drupal.org/project/drupal/issues/3188703
        # See https://www.drupal.org/project/drupal/issues/1792310
        echo "$(cat composer.json | jq '.scripts."post-install-cmd" |= . + ["src/composer-drupal-core-setup/patch-core-index-and-update.sh"]')" >composer.json
        echo "$(cat composer.json | jq '.scripts."post-update-cmd" |= . + ["src/composer-drupal-core-setup/patch-core-index-and-update.sh"]')" >composer.json

        # Run the patch once
        time src/composer-drupal-core-setup/patch-core-index-and-update.sh
    fi

    # Save a file to mark workspace already initiated
    touch "${GITPOD_REPO_ROOT}"/.drupalpod_initiated

    # Finish measuring script time
    script_end_time=$(date +%s)
    runtime=$((script_end_time - script_start_time))
    echo "drupalpod-setup.sh script ran for" $runtime "seconds"
else
    cd "${GITPOD_REPO_ROOT}" && ddev start
fi

# Open internal preview browser with current website
preview
