source test_scripts.sh

BIN_DIR="${COMMON_DIR}/cargo-home/bin"
BIN_PATH="${BIN_DIR}/merge-pr"
# Empty version, since merge-pr does not expose version information.
# If the version is missing, the installation will fail anyway.
test_binary_feature "$BIN_PATH" ""
