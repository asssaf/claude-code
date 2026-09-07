# Claude Code Docker Container

A Docker container for [Claude Code](https://claude.ai/code) built on `debian:trixie-slim` using Anthropic's official native installer (without Node.js).

## Features

- **Base Image:** `debian:trixie-slim`
- **Native Installation:** Installs standalone Claude Code binary via `https://claude.ai/install.sh` (no Node.js / npm)
- **Non-Root User:** Runs as user `user` (UID/GID 1000) with passwordless `sudo` (customizable via `GUEST_USER`)
- **Essential Tools:** Pre-installed with `git`, `ripgrep`, `curl`, `jq`, `ca-certificates`, `procps`, and `zstd`
- **Auto-updater Disabled:** `DISABLE_AUTOUPDATER=1` prevents container file conflicts
- **Host Cache Support:** Persistent cache directory via `CC_HOST_CACHE` environment variable
- **Startup Hooks:** Run initialization scripts via `CC_STARTUP_HOOK` environment variable

## Build

```bash
docker build -t claude-code:latest docker/
```

## Usage

```bash
scripts/run.sh
```

### Environment Variables

The helper script `scripts/run.sh` can be customized using environment variables:

| Environment Variable | Description | Default |
|----------------------|-------------|---------|
| `IMAGE_NAME` | The Docker image to execute. | `claude-code:latest` |
| `ANTHROPIC_BASE_URL` | API URL for Claude Code gateway | `http://127.0.0.1:8082` |
| `ANTHROPIC_API_KEY` | API key for Claude Code | `sk-ant-api03-...` |
| `CLAUDE_CONFIG` | Path to Claude config directory | `${HOME}/.claude` |
| `CLAUDE_JSON` | Path to Claude JSON settings file | `${HOME}/.claude.json` |
| `WORKSPACE_DIR` | Workspace directory to mount into container | Current directory |
| `CC_HOST_CACHE` | Path to a directory on the host to mount as a persistent cache (`/home/<user>/host-cache` inside container). | *(Disabled if empty)* |
| `CC_STARTUP_HOOK` | Path to an executable script (e.g. `scripts/dev-setup.sh`) to run prior to launching Claude Code. | *(None)* |
| `GUEST_USER` | The username of the non-root user running inside the container (UID is fixed at 1000 for compatibility). | `user` |

### Cache Example

To run the container with a host cache directory mapped to `/home/user/host-cache` inside the container:

```bash
CC_HOST_CACHE="/var/cache/cc" ./scripts/run.sh
```

### Startup Hook Example

To run a configuration or initialization script (e.g., setting environment variables, configuring tools) on startup:

```bash
CC_STARTUP_HOOK="scripts/dev-setup.sh" ./scripts/run.sh
```

> [!NOTE]
> The `CC_STARTUP_HOOK` script is sourced directly in the container entrypoint, which means any environment changes (such as modifying `PATH` or setting environment variables) will persist into the Claude Code process.

### Custom User Example

To run the container with a different username inside the container (while maintaining UID 1000 for file permission compatibility):

```bash
GUEST_USER="developer" ./scripts/run.sh
```
