#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Prerequisite:
# Manually delete or rename default envs backup file from Google cloud:
#   https://console.cloud.google.com/storage/browser
echo "*** Rebuilding ready-made environments from scratch, this will take 25 minutes..."

# Stop and unlist current ddev project
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
# Create a ddev snapshot

for d in "${allDrupalSupportedVersions[@]}"; do
  # Create ddev config
  mkdir -p "$WORK_DIR"/"$d"
  cd "$WORK_DIR"/"$d" && ddev config --docroot=web --create-docroot --project-type=drupal9 --project-name=drupalpod

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

  echo "*** composer install"
  cd "$WORK_DIR"/"$d" && ddev composer create -y --no-install drupal/recommended-project:"$install_version"

  # Composer 2.2 - programmatically set allow-plugins
  ddev composer config allow-plugins.composer/installers true
  ddev composer config allow-plugins.drupal/core-composer-scaffold  true
  ddev composer config allow-plugins.drupal/core-project-message true

  # Install Drush
  cd "$WORK_DIR"/"$d" && \
    ddev composer require \
      drupal/admin_toolbar \
      drush/drush \
      drupal/coder \
      drupal/devel

  for p in "${allProfiles[@]}"; do
    echo Building drupal-"$d"-"$p"

    echo "*** Drush Site Install"
    cd "$WORK_DIR"/"$d" && \

    ddev drush si -y --account-pass=admin --site-name="DrupalPod" "$p"

    echo "*** Adding extra modules"
    cd "$WORK_DIR"/"$d"  && \
      ddev drush en -y admin_toolbar devel

    # Enable Claro as default admin theme
    echo "*** Enable Claro theme"
    cd "$WORK_DIR"/"$d" && \
      ddev drush then claro && \
      ddev drush config-set -y system.theme admin claro

    echo "*** Save a ddev snapshot"
    cd "$WORK_DIR"/"$d" && ddev snapshot -n "$p"
  done

  #  Stop any existing 'drupalpod' ddev project
  cd "$WORK_DIR"/"$d" && ddev stop --unlist drupalpod

done


# compress all environments into a file
echo "*** Compress all environments into a file"
cd /workspace &&
  tar czf ready-made-envs.tar.gz ready-made-envs

# Check if environments file exist in Google Cloud

# Establish connection with Google Cloud through Minio client
mc config host add gcs https://storage.googleapis.com "$DP_GOOGLE_ACCESS_KEY" "$DP_GOOGLE_SECRET"

if ! mc find gcs/drupalpod/ready-made-envs.tar.gz; then
  # Upload files if it doesn't exist yet
  echo "*** Upload environments file to Google Cloud"
  mc cp /workspace/ready-made-envs.tar.gz gcs/drupalpod/ready-made-envs.tar.gz
else
  # File already exist, send a message to manually delete and then upload the file
  echo "*** File already exist, uploading a copy of the file with branch and date info"
  TODAY=$(date +"%Y-%m-%d")
  CURRENT_BRANCH=branch---"$(cd "$GITPOD_REPO_ROOT" && git branch --show-current)"
  mc cp /workspace/ready-made-envs.tar.gz gcs/drupalpod/"$CURRENT_BRANCH"/"$TODAY"/ready-made-envs.tar.gz
fi
