#!/bin/bash
set -eu -o pipefail
# if [ -n "$DEBUG_DRUPALPOD" ]; then
#     set -x
# fi

DOCKER_REPO=drupalpod/ddev-gitpod-base:20211105-"$(git branch --show-current)"

echo "Pushing ${DOCKER_REPO}"
set -x
# Build only current architecture and load into docker
docker buildx build -t "${DOCKER_REPO}" --push --platform=linux/amd64 .
