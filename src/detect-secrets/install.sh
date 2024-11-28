#!/usr/bin/env bash
set -e

echo "Activating feature [detect-secrets]"

if command -v detect-secrets >/dev/null; then
    echo "Executable exists, skipping"
    exit 0
fi

. ./ensure_nanolayer.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-extra/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
ensure_nanolayer nanolayer_location "v0.5.0"


$nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-extra/features/pipx-package:1.1.8" \
    --option package='detect-secrets' --option version="$VERSION"

echo 'Done!'
