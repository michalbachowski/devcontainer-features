source test_scripts.sh

SCRIPT_PATH=/usr/local/bin/adr-tools/adr

# version is NOT validated, since the adr-tool CLI does not expose version information
VERSION="${VERSION:-3.0.0}"

test_binary_feature "$SCRIPT_PATH"
