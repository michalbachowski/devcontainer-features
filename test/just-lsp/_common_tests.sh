source test_scripts.sh

BIN_DIR="/usr/local/cargo/bin"
BIN_PATH="${BIN_DIR}/just-lsp"
VERSION="${VERSION:-0.4.0}"

test_binary_feature "$BIN_PATH" "${VERSION}"
