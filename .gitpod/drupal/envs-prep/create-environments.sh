#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Prerequisite:
# Manually delete or rename default envs backup file from Google cloud:
#   https://console.cloud.google.com/storage/browser
echo "*** Rebuilding ready-made environments from scratch, this will take 8 minutes... (2 minutes per drupal version)"

# Stop and unlist current DDEV project
ddev stop --unlist drupalpod

# Empty existing ready-made-envs directory
rm -rf /workspace/ready-made-envs

WORK_DIR="/workspace/ready-made-envs"
mkdir -p "$WORK_DIR"

# Read all Drupal supported versions from a file into an array
readarray -t allDrupalSupportedVersions < "${GITPOD_REPO_ROOT}"/.gitpod/drupal/envs-prep/all-drupal-supported-versions.txt

# Array of all possible install profiles to be prepared during ready_made_envs
allProfiles=(minimal standard demo_umami)

# Run through each Drupal Supported Versions - a
# Install minimal, standard and umami profiles
# Create a DDEV snapshot

for d in "${allDrupalSupportedVersions[@]}"; do
  # Create DDEV config
  mkdir -p "$WORK_DIR"/"$d"
  cd "$WORK_DIR"/"$d" && ddev config --docroot=web --create-docroot --project-type=drupal9 --php-version=8.1 --project-name=drupalpod --database=mariadb:10.3

  # For versions end with x - add `-dev` suffix (ie. 9.3.x-dev)
  # For versions without x - add `~` prefix (ie. ~9.2.0)
  case $d in
    *.x)
    install_version="$d"-dev
    ;;
    *)
    install_version=~"$d"
    ;;
  esac

  # @todo: update when admin_toolbar becomes compatible with Drupal 10
  if [[ "$d" == 10* ]]; then
      unset ADMIN_TOOLBAR_PACKAGE
  else
      export ADMIN_TOOLBAR_NAME="admin_toolbar_tools"
      export ADMIN_TOOLBAR_PACKAGE="drupal/admin_toolbar"
  fi

  echo "*** composer install"
  cd "$WORK_DIR"/"$d" && ddev composer create -y --no-install drupal/recommended-project:"$install_version"

  # Programmatically fix Composer 2.2 allow-plugins to avoid errors
  ddev composer config --no-plugins allow-plugins.composer/installers true
  ddev composer config --no-plugins allow-plugins.drupal/core-project-message true
  ddev composer config --no-plugins allow-plugins.drupal/core-vendor-hardening true
  ddev composer config --no-plugins allow-plugins.drupal/core-composer-scaffold true

  ddev composer config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
  ddev composer config --no-plugins allow-plugins.phpstan/extension-installer true

  ddev composer config --no-plugins allow-plugins.mglaman/composer-drupal-lenient true

  # Install additional packages

  rm "$WORK_DIR"/"$d"/composer.lock

  # Install phpunit and its dependency - core-dev
  cd "$WORK_DIR"/"$d" && ddev composer require --dev phpspec/prophecy-phpunit:^2 drupal/core-dev:* -W --no-install

  cd "$WORK_DIR"/"$d" && \
    time ddev . composer require drush/drush drupal/coder drupal/devel "$ADMIN_TOOLBAR_PACKAGE"

  for p in "${allProfiles[@]}"; do
    echo Building drupal-"$d"-"$p"

    echo "*** Drush Site Install"
    cd "$WORK_DIR"/"$d" && \

    ddev drush si -y --account-pass=admin --site-name="DrupalPod" "$p"

    echo "*** Adding extra modules"

    # Enable extra modules
    if [ -n "$ADMIN_TOOLBAR_NAME" ]; then
        cd "$WORK_DIR"/"$d"  && \
        ddev drush en -y \
        "$ADMIN_TOOLBAR_NAME"
    fi

    cd "$WORK_DIR"/"$d"  && ddev drush en -y devel

    # Enable Claro as default admin theme
    echo "*** Enable Claro theme"
    cd "$WORK_DIR"/"$d" && \
      ddev drush then claro && \
      ddev drush config-set -y system.theme admin claro

    echo "*** Save a DDEV snapshot"
    cd "$WORK_DIR"/"$d" && ddev snapshot -n "$p"
  done

  #  Stop any existing 'drupalpod' DDEV project
  cd "$WORK_DIR"/"$d" && ddev stop --unlist drupalpod

done


# compress all environments into a file
echo "*** Compress all environments into a file"
cd /workspace &&
  tar czf ready-made-envs.tar.gz ready-made-envs

# Check if environments file exist in Google Cloud

# Establish connection with Google Cloud through Minio client
mc config host add gcs https://storage.googleapis.com "$DP_GOOGLE_ACCESS_KEY" "$DP_GOOGLE_SECRET"

CURRENT_BRANCH="$(cd "$GITPOD_REPO_ROOT" && git branch --show-current)"
DATE_TIME=$(date +"%Y-%m-%d___%H-%M-%p")

if ! mc find gcs/drupalpod/"$CURRENT_BRANCH"/ready-made-envs.tar.gz; then
  # Upload files if it doesn't exist yet
  echo "*** Upload environments file to Google Cloud"
  echo "drupalpod/$CURRENT_BRANCH/ready-made-envs.tar.gz"
  mc cp /workspace/ready-made-envs.tar.gz gcs/drupalpod/"$CURRENT_BRANCH"/ready-made-envs.tar.gz
else
  # File already exist, send a message to manually delete and then upload the file
  echo "*** File already exist, uploading a copy of the file with branch and date info"
  echo "drupalpod/$CURRENT_BRANCH/$DATE_TIME/ready-made-envs.tar.gz"
  mc cp /workspace/ready-made-envs.tar.gz gcs/drupalpod/"$CURRENT_BRANCH"/"$DATE_TIME"/ready-made-envs.tar.gz
fi
