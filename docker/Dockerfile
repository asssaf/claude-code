# syntax=docker/dockerfile:1
FROM debian:trixie-slim

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential system dependencies and common development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    jq \
    less \
    libatomic1 \
    procps \
    ripgrep \
    sudo \
    zstd \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user with customizable username (fixed UID 1000 for compatibility)
ARG GUEST_USER=user
RUN groupadd --gid 1000 ${GUEST_USER} \
    && useradd --uid 1000 --gid 1000 -m -s /bin/bash ${GUEST_USER} \
    && echo "${GUEST_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${GUEST_USER} \
    && chmod 0440 /etc/sudoers.d/${GUEST_USER}

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to non-root user
USER ${GUEST_USER}
WORKDIR /home/$GUEST_USER/work

# Set environment variables:
# - Add ~/.local/bin to PATH where Claude native binary is installed
# - Disable auto-updater inside container for stability
ENV PATH="/home/${GUEST_USER}/.local/bin:${PATH}" \
    DISABLE_AUTOUPDATER=1

ARG CLAUDE_VERSION=latest
RUN curl -fsSL https://downloads.claude.ai/claude-code-releases/bootstrap.sh | bash -s -- ${CLAUDE_VERSION}

# Entrypoint handles startup hooks
ENTRYPOINT ["/entrypoint.sh"]
# Default command (can be overridden)
CMD ["claude"]
