#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

allProfiles=(minimal standard demo_umami)

WORK_DIR="$GITPOD_REPO_ROOT"/ready-made-envs
mkdir -p "$WORK_DIR"

# Read all Drupal supported versions from a file into an array
readarray -t allDrupalSupportedVersions < "${GITPOD_REPO_ROOT}"/.gitpod/drupal/all-drupal-supported-versions.txt

# Run through each Drupal Supported Versions - a
# Install minimal, standard and umami profiles
# Create a ddev snapshot

for d in "${allDrupalSupportedVersions[@]}"; do
  echo *** composer install
  composer create-project drupal/recommended-project:"$d" "$WORK_DIR"/"$d"

  # Install Drush
  cd "$WORK_DIR"/"$d" && \
    composer require \
      drupal/admin_toolbar \
      drush/drush:^10 \
      drupal/coder \
      drupal/devel

  # Create ddev project name without the tilde character ~
  cd "$WORK_DIR"/"$d" && ddev config --project-name latest-"${d/\~/}"

  for p in "${allProfiles[@]}"; do
    echo Building drupal-"$d"-"$p"

    echo *** Drush Site Install
    cd "$WORK_DIR"/"$d" && \

    ddev drush si -y --account-pass=admin --site-name="DrupalPod" "$p"

    echo *** Adding extra modules
    cd "$WORK_DIR"/"$d"  && \
      ddev drush en -y admin_toolbar coder devel

    # Enable Claro as default admin theme
    echo *** Enable Claro theme
    cd "$WORK_DIR"/"$d" && \
      ddev drush then claro && \
      ddev drush config-set -y system.theme admin claro

    echo *** Save a ddev snapshot
    cd "$WORK_DIR"/"$d" && ddev snapshot -n drupal-"$d"-"$p"
  done
done
