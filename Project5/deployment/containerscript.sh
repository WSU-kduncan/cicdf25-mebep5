#!/bin/bash

set -euo pipefail

DOCKER_USER="mebep5"
REPO_NAME="mywebsite2"
TAG="latest"
IMAGE="${DOCKER_USER}/${REPO_NAME}:${TAG}"
CONTAINER_NAME="mywebsitetest"
PORT_MAP="80:80"

echo "Stopping old container"
docker stop "${CONTAINER_NAME}"
docker rm "${CONTAINER_NAME}"

echo " Pulling ${IMAGE}"
docker pull "${IMAGE}"

echo "Starting new container"
docker run -d --restart always --name "${CONTAINER_NAME}" -p "${PORT_MAP}" "${IMAGE}"

echo "Yippe '${CONTAINER_NAME}' is running!"
