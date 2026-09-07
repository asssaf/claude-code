#!/usr/bin/env bash

set -euo pipefail

VERSION=$(curl -s https://downloads.claude.ai/claude-code-releases/latest)

if [[ -z "$VERSION" ]]; then
  echo "Error: Failed to fetch Claude Code version" >&2
  exit 1
fi

# Write to GitHub Actions output if GITHUB_OUTPUT environment variable is set
if [[ -v GITHUB_OUTPUT ]]; then
  echo "version=${VERSION}" >> "$GITHUB_OUTPUT"
else
  # Otherwise just print it
  echo "version=${VERSION}"
fi
