# Neutral Linux convenience image. Pin the base image by digest in a provider
# snapshot when exact reproducibility is required.
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-24.04

USER root

RUN apt-get update \
    && apt-get install --no-install-recommends --yes \
      ca-certificates \
      cargo \
      git \
      jq \
      nodejs \
      npm \
      python3 \
      python3-venv \
      rustc \
      shellcheck \
    && rm -rf /var/lib/apt/lists/*

USER vscode

# uv and pnpm remain explicit bootstrap requirements. Hosts may install and pin
# them in the image or snapshot policy appropriate to their provider.
WORKDIR /workspaces/cabin-dev-environment
