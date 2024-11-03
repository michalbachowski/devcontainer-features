source test_scripts.bash

SCRIPT_PATH=/usr/local/bin/scalafmt-native
VERSION="${VERSION:-3.8.3}"

test_binary_feature "$SCRIPT_PATH" "$VERSION"