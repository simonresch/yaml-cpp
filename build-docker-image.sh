#!/bin/bash

set -euo pipefail

PROJECT_NAME="yaml-cpp"
DIR="$(dirname "$(readlink -f "$0")")"
REPOSITORY="cifuzz/builder-${PROJECT_NAME}"

print_usage() {
  cat << EOF
usage: $0 [OPTIONS] IMAGE

Options:
--tag
    The tag to be applied to the image. Defaults to the current git commit hash.
--push
    Push the image after building it.
-h, --help
    Print this usage message.
EOF
}

# Parse arguments
while [ "$#" -gt 0 ]; do
case "$1" in
    -h|--help)
    print_usage
    exit 0
    ;;
    --tag)
    TAG="$2"
    shift # past argument
    shift # past value
    ;;
    --push)
    PUSH=1
    shift # past argument
    ;;
    *) # unknown option
    echo >&2 "unknown option: $1"
    print_usage
    exit 1
    ;;
esac
done

# Prepend the tag with the repository name, to have the format that
# Docker expects for the --tag flag.
# If no tag was provided, we default to "latest".
TAG="${REPOSITORY}:${TAG:-"latest"}"

# We also always create a tag from the current commit hash, to allow
# referencing the exact image version.
# In case that we're running in GitLab CI, we already have the current
# commit hash in the CI_COMMIT_SHA environment variable.
CI_COMMIT_SHA="${CI_COMMIT_SHA:-$(git rev-parse HEAD)}"
COMMIT_SHA_TAG="${REPOSITORY}:${CI_COMMIT_SHA}"

DOCKER_BUILDKIT=1 docker build \
	--cache-from "${REPOSITORY}" \
	--build-arg BUILDKIT_INLINE_CACHE=1 \
	-t "${TAG}" \
	-t "${COMMIT_SHA_TAG}" \
	"${DIR}"

# Push the image if the --push option was set
if [ -n "${PUSH:-}" ]; then
  docker push "${TAG}"
  docker push "${COMMIT_SHA_TAG}"
fi
