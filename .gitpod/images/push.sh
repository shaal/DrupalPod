#!/bin/bash
set -eu -o pipefail
# if [ -n "$DEBUG_SCRIPT" ]; then
#     set -x
# fi

# Run `docker login` to authenticate and push new images to docker hub
# Update /.gitpod.yml with the new image file

# "%Y-%m-%d"
TODAY=$(date +"%Y%m%d")
REPO_NAME=drupalpod/drupalpod-gitpod-base
DOCKER_REPO="$REPO_NAME":"$TODAY"
DOCKER_REPO_LATEST="$REPO_NAME":latest

echo "Pushing ${DOCKER_REPO}"
set -x
# Build only current architecture and load into docker
# docker buildx build -t "${DOCKER_REPO}" --push --target=drupalpod-gitpod-base --platform=linux/amd64 .
docker build --target drupalpod-gitpod-base -t "${DOCKER_REPO}" -t "${DOCKER_REPO_LATEST}" .
docker image push "${DOCKER_REPO}"
docker image push "${DOCKER_REPO_LATEST}"

# docker run -it --rm <full_docker_image_tag> bash
# docker image inspect <full_docker_image_tag>
