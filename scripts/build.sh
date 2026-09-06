#!/usr/bin/env bash

set -euxo pipefail

: ${IMAGE:="ghcr.io/asssaf/claude-code:latest"}

docker build -t $IMAGE docker/
