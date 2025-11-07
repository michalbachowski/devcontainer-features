source test_scripts.sh

BIN_DIR="${COMMON_DIR}/openshift-oc"
BIN_PATH="${BIN_DIR}/oc"
VERSION="${VERSION:-4.17.0}"

test_binary_feature "$BIN_PATH" "${VERSION}" "version -s unused 2>/dev/null"
