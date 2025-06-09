#!/usr/bin/env bash
set -e

BIN_NAME=merge-pr
BIN_PATH="${CARGO_HOME}/bin/${BIN_NAME}"
FEATURE_NAME="$BIN_NAME"

. ./library_scripts.sh

title "${FEATURE_NAME}"

if command -v "$BIN_NAME" >/dev/null; then
    echo "Script exists, skipping"
    exit 0
fi

if ! command -v xz >/dev/null; then
    echo "The [xz] command is missing. Please install [xz-utils]."
    echo "You can use [ghcr.io/devcontainers-extra/features/apt-get-packages] feature to install it."
    exit 1
fi

ensure_common_dir
create_dir "$CARGO_HOME";

download_url_prefix="https://github.com/wireapp/merge-pr/releases"
download_url_suffix="merge-pr-installer.sh"

if [ "${VERSION}" == "latest" ]; then
    download_url="${download_url_prefix}/${VERSION}/download/${download_url_suffix}"
else
    download_url="${download_url_prefix}/download/${VERSION}/${download_url_suffix}"
fi

curl \
    --proto '=https' \
    --tlsv1.2 \
    -LsSf \
    "$download_url" \
    --output merge-pr-installer.sh;

export MERGE_PR_UNMANAGED_INSTALL="${CARGO_HOME}"
bash ./merge-pr-installer.sh -v;

set_common_ownership "${BIN_PATH}"

echo 'Done!'
