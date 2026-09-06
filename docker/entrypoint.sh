#!/usr/bin/env bash

set -euo pipefail

if [ -v CC_STARTUP_HOOK ] && [ -n "${CC_STARTUP_HOOK}" ]; then
    if [ -f "${CC_STARTUP_HOOK}" ]; then
        source "${CC_STARTUP_HOOK}"
    else
        echo "Warning: CC_STARTUP_HOOK file '${CC_STARTUP_HOOK}' not found" >&2
    fi
fi

exec "$@"