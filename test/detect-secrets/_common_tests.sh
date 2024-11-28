source test_scripts.sh

SCRIPT_PATH=/usr/local/py-utils/bin/detect-secrets
VERSION="${VERSION:-1.5.0}"

check "test" bash -c "ls -la $SCRIPT_PATH"
test_binary_feature "$SCRIPT_PATH" "$VERSION"