#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Read all Drupal supported versions from a file into an array
readarray -t allDrupalSupportedVersions < "${GITPOD_REPO_ROOT}"/.gitpod/drupal/envs-prep/all-drupal-supported-versions.txt

# Array of all possible install profiles to be prepared during ready_made_envs
allProfiles=(minimal standard demo_umami)

# Run through each Drupal Supported Versions - a
# Install minimal, standard and umami profiles
# Create a ddev snapshot

for d in "${allDrupalSupportedVersions[@]}"; do
  # Create ddev config
  # mkdir -p "$WORK_DIR"/"$d"
  # cd "$WORK_DIR"/"$d" && ddev config --docroot=web --create-docroot --project-type=drupal9 --project-name=drupalpod

  install_version=

  # Check that if version ends with 'x'
  case $d in
    *.x)
    # echo "Yes $d"
    install_version="$d"-dev
    ;;
    *)
    # echo "No $d"
    install_version=~"$d"
    ;;
  esac

  echo "installing:"
  echo "$install_version"
done
