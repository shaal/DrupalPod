# Setting up a new version for DrupalPod

## Build custom Gitpod image

1. Update `.gitpod/images/Dockerfile`:

    1. Update `minio` latest version.
    1. Update `gitui` latest version.

1. Generate new custom docker image:

    1. Run `docker login` to authenticate and push new images to docker hub.
    1. In `/.gitpod/images` run `./push.sh` command to build and push the new custom docker image.
    1. Confirm the process run without errors and that the new custom image gets uploaded to <https://hub.docker.com/r/drupalpod/drupalpod-gitpod-base/tags>.
    1. Update `/.gitpod.yml` with the new image file.

1. Push code, and re-open Gitpod workspace, to use latest custom docker image.

1. Create ready-made environments

    1. Update list of drupal versions that will be in ready-made environments.
`.gitpod/drupal/envs-prep/all-drupal-supported-versions.txt`
    1. Run `.gitpod/drupal/envs-prep/create-environments.sh` to create ready-made environments.
    1. Confirm ready-made environments zip file was uploaded to Google Cloud.

1. Run manual prebuild (to load latest ready-made environments)

1. Confirm latest setup
    1. Open new workspace (it will load ready-made environments with same name as current branch).
    1. Check if there are any updates (ie. ddev's default settings files).
    1. Recreate ready-made environments if needed.

1. Test various scenarios with DrupalPod browser extension
    1. Confirm core issues work as expected.
    1. Confirm contrib issue work as expected.

1. Prepare ready-made environments in 'main' directory
    1. Copy ready-made environments in Google Cloud from branch directory to 'main' directory, so when prebuild runs on 'main', it will pick up the right file <https://console.cloud.google.com/storage/browser/drupalpod>

1. Merge PR into `main` branch

1. Confirm `main` branch work as expected 🎉
