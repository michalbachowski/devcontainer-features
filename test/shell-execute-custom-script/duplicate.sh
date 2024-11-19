#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'shell-source-custom-script' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "shell-source-custom-script": {}
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
#                   --features shell-source-custom-script   \
#                   --remote-user root \
#                   --skip-scenarios   \
#                   --base-image mcr.microsoft.com/devcontainers/baseubuntu \
#                   /workspaces/devcontainer-features

HAS_BASH="1"
HAS_ZSH="1"
HAS_COMMON="1"

source _common_tests.sh

check "The feature's [$BASH_SCRIPT_PATH] file contains ONLY ONE reference to the [$BASH_SCRIPT] script" bash -c "test \$(cat $BASH_SCRIPT_PATH | grep -F \"$BASH_SCRIPT\" | wc -l) -eq '1'"
check "The feature's [$ZSH_SCRIPT_PATH] file contains ONLY ONE reference to the [$ZSH_SCRIPT] script" bash -c "test \$(cat $ZSH_SCRIPT_PATH | grep -F \"$ZSH_SCRIPT\" | wc -l) -eq '1'"

check "The feature's [$BASH_SCRIPT_PATH] file contains ONLY ONE reference to the [$COMMON_SCRIPT] script" bash -c "test \$(cat $BASH_SCRIPT_PATH | grep -F \"$COMMON_SCRIPT\" | wc -l) -eq '1'"
check "The feature's [$ZSH_SCRIPT_PATH] file contains ONLY ONE reference to the [$COMMON_SCRIPT] script" bash -c "test \$(cat $ZSH_SCRIPT_PATH | grep -F \"$COMMON_SCRIPT\" | wc -l) -eq '1'"

check "The common [$BASHRC_FILE_PATH] file contains ONLY ONE reference to the feature's [$BASH_SCRIPT_PATH] file" bash -c "test \$(cat $BASHRC_FILE_PATH | grep '$BASH_SCRIPT_PATH' | grep source | wc -l) -eq '1'"
check "The common [$ZSHRC_FILE_PATH] file contains ONLY ONE reference to the feature's [$ZSH_SCRIPT_PATH] file" bash -c "test \$(cat $ZSHRC_FILE_PATH | grep '$ZSH_SCRIPT_PATH' | grep source | wc -l) -eq '1'"

check "The user's [$BASH_USER_RC_FILE_PATH] file contains ONLY ONE reference to the feature's [$BASHRC_FILE_PATH] file" bash -c "test \$(cat $BASH_USER_RC_FILE_PATH | grep '$BASHRC_FILE_PATH' | grep source | wc -l) -eq '1'"
check "The user's [$ZSH_USER_RC_FILE_PATH] file contains ONLY ONE reference to the feature's [$ZSHRC_FILE_PATH] file" bash -c "test \$(cat $ZSH_USER_RC_FILE_PATH | grep '$ZSH_FILE_PATH' | grep source | wc -l) -eq '1'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
