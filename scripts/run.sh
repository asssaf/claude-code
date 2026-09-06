#!/usr/bin/env bash

set -euo pipefail

: ${IMAGE:="ghcr.io/asssaf/claude-code:latest"}
API_URL="${ANTHROPIC_BASE_URL:-http://127.0.0.1:8082}"
API_KEY="${ANTHROPIC_API_KEY:-sk-ant-api03-****************************}"
: ${CLAUDE_CONFIG:="${HOME}/.claude"}
: ${CLAUDE_JSON:="${HOME}/.claude.json"}
: ${CC_HOST_CACHE:=""}
: ${CC_STARTUP_HOOK:=""}
: ${PROJECT:="$(basename $PWD)"}
: ${GUEST_USER:=user}
: ${WORKSPACE_DIR:="${PWD}"}
: ${DOCKER_OPTS:=""}

mkdir -p "${CLAUDE_CONFIG}"
[ -e "${CLAUDE_JSON}" ] || echo "{}" >> "${CLAUDE_JSON}"

# Validate CC_HOST_CACHE if set
if [ -n "$CC_HOST_CACHE" ]
then
	mkdir -p $CC_HOST_CACHE || { echo "Failed to create $CC_HOST_CACHE. Create it or set CC_HOST_CACHE=\"\" to disable." >&2 ; exit 1; }
fi

docker run -it --rm --name "cc-${PROJECT}" \
	--net host \
	-v "${WORKSPACE_DIR}":/home/${GUEST_USER}/work \
	-v "${CLAUDE_CONFIG}":/home/${GUEST_USER}/.claude \
	-v "${CLAUDE_JSON}":/home/${GUEST_USER}/.claude.json \
	${CC_HOST_CACHE:+-v "${CC_HOST_CACHE}:/home/${GUEST_USER}/host-cache"} \
	-e ANTHROPIC_BASE_URL="${API_URL}" \
	-e ANTHROPIC_API_KEY="${API_KEY}" \
	-e CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY="1" \
	-e CC_STARTUP_HOOK="${CC_STARTUP_HOOK}" \
	${DOCKER_OPTS} \
	"${IMAGE}" \
	"$@"
