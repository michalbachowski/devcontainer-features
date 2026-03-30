#!/usr/bin/env bash
set -e

BIN_NAME=just-lsp
BIN_DIR="${CARGO_HOME}/bin"
BIN_PATH="${BIN_DIR}/${BIN_NAME}"
FEATURE_NAME="${BIN_NAME}"

. ./library_scripts.sh

title "${FEATURE_NAME}"

if command -v "${BIN_NAME}" >/dev/null; then
    echo "Script exists, skipping"
    exit 0
fi

if ! command -v cargo >/dev/null; then
    echo "The [cargo] command is missing. Please install it first." 
    echo "You can use [ghcr.io/devcontainers/features/rust] feature to install it."
    exit 1
fi

ensure_common_dir
create_dir "${BIN_DIR}";

cargo install --version "${VERSION}" "${BIN_NAME}"
set_common_ownership "${BIN_PATH}"

echo 'Done!'
