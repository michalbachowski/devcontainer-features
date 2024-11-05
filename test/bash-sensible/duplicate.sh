#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'bash-sensible' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "bash-sensible": {}
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
#                   --features bash-sensible   \
#                   --remote-user root \
#                   --skip-scenarios   \
#                   --base-image mcr.microsoft.com/devcontainers/baseubuntu \
#                   /workspaces/devcontainer-features
source _common_tests.sh

check "The user's [$user_rc_file_path] file contains ONLY ONE reference to the feature's [$rc_file_path] file" bash -c "test \$(cat $user_rc_file_path | grep '$rc_file_path' | grep source | wc -l) -eq '1'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
