source test_scripts.sh

SCRIPT_PATH=/usr/local/bin/snyk
VERSION="${VERSION:-1.1294.0}"

test_binary_feature "$SCRIPT_PATH" "$VERSION"