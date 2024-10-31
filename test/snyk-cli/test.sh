#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'snyk-cli' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "snyk-cli": {}
#    },
#    "remoteUser": "root"
# }
#
# Thus, the value of all options will fall back to the default value in 
# the Feature's 'devcontainer-feature.json'.
#
# These scripts are run as 'root' by default. Although that can be changed
# with the '--remote-user' flag.
# 
# This test can be run with the following command:
#
#    devcontainer features test \ 
#                   --features snyk-cli   \
#                   --remote-user root \
#                   --skip-scenarios   \
#                   --base-image mcr.microsoft.com/devcontainers/baseubuntu \
#                   /workspaces/devcontainer-features

set -e

# Optional: Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

script_name=snyk
default_version=1.1294.0
script_path=/usr/local/bin/$script_name

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib. Syntax is...
# check <LABEL> <cmd> [args...]

check "binary exists" bash -c "test -x $script_path && echo exists"
check "binary is owned by root:root" bash -c "ls -l $script_path | grep -q 'root root'"
check "binary is available on PATH" bash -c "command -v $script_name >/dev/null || exit 1"
check "binary is in correct version" bash -c "$script_name --version | grep -q $default_version"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
