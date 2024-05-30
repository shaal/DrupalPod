# Setting up a new version for DrupalPod

## Build custom Gitpod image

1. Update `.gitpod/images/Dockerfile`:

    1. Update `ddev` latest version.
    1. Update `minio` latest version.
    1. Update `gitui` latest version.
    1. Update `lazygit` latest version.

1. Generate new custom docker image:

    1. Run `docker login` to authenticate and push new images to docker hub.
    1. In `/.gitpod/images` run `./push.sh` command to build and push the new custom docker image.
    1. Confirm the process run without errors and that the new custom image gets uploaded to <https://hub.docker.com/r/drupalpod/drupalpod-gitpod-base/tags>.
    1. Update `/.gitpod.yml` with the new image file.

1. Push code, and re-open Gitpod workspace, to use latest custom docker image.

1. Run manual prebuild (to load ddev's images)

1. Confirm latest setup
    1. Open new workspace.
    1. Check if there are any updates (ie. DDEV's default settings files).

1. Test various scenarios with DrupalPod browser extension
    1. Confirm core issues work as expected.
    1. Confirm contrib issue work as expected.

1. Merge PR into `main` branch

1. Confirm `main` branch work as expected 🎉
