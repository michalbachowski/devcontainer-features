#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'bash-prompt' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "bash-prompt": {}
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
#                   --features bash-prompt   \
#                   --remote-user root \
#                   --skip-scenarios   \
#                   --base-image mcr.microsoft.com/devcontainers/baseubuntu \
#                   /workspaces/devcontainer-features

set -e

# Optional: Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

DEST_DIR=/devcontainer-feature/michalbachowski
USER=root
HOMEDIR=/root
PROMPT_FILE_NAME=prompt.bash
PROMPT_FILE_PATH=$DEST_DIR/$PROMPT_FILE_NAME
RC_FILE_NAME=bashrc
RC_FILE_PATH=$DEST_DIR/$RC_FILE_NAME
USER_RC_FILE_PATH=$HOMEDIR/.$RC_FILE_NAME

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib. Syntax is...
# check <LABEL> <cmd> [args...]

check "The $PROMPT_FILE_NAME [$PROMPT_FILE_PATH] file exists" bash -c "sudo test -f $PROMPT_FILE_PATH"
check "The $PROMPT_FILE_NAME [$PROMPT_FILE_PATH] file is owned by the [$USER] user" bash -c "sudo stat -c "%U" $PROMPT_FILE_PATH | grep -q -E '^$USER$'"
check "The $RC_FILE_NAME [$RC_FILE_PATH] file exists" bash -c "sudo test -f $RC_FILE_PATH"
check "The $RC_FILE_NAME [$RC_FILE_PATH] file exists is owned by the [$USER] user" bash -c "sudo stat -c "%U" $RC_FILE_PATH | grep -q -E '^$USER$'"
check "The $RC_FILE_NAME [$RC_FILE_PATH] file contains a reference to the $PROMPT_FILE_NAME [$PROMPT_FILE_PATH] file" bash -c "sudo cat $RC_FILE_PATH | grep '$PROMPT_FILE_PATH' | grep -q source"
check "The $RC_FILE_NAME [$RC_FILE_PATH] file contains ONLY ONE reference to the $PROMPT_FILE_NAME [$PROMPT_FILE_PATH] file" bash -c "test \$(sudo cat $RC_FILE_PATH | grep 'source $PROMOPT_FILE_PATH' | grep source | wc -l) -eq '1'"
check "The user's [$USER] $RC_FILE_NAME [$USER_RC_FILE_PATH] file exists" bash -c "sudo test -f $USER_RC_FILE_PATH"
check "The user's [$USER] $RC_FILE_NAME [$USER_RC_FILE_PATH] file exists is owned by the [$USER] user" bash -c "sudo stat -c "%U" $USER_RC_FILE_PATH | grep -q -E '^$USER$'"
check "The user's [$USER] $RC_FILE_NAME [$USER_RC_FILE_PATH] file contains a reference to the feature's $RC_FILE_NAME [$RC_FILE_PATH] file" bash -c "sudo cat $USER_RC_FILE_PATH | grep '$RC_FILE_NAME' | grep -q source"
check "The user's [$USER] $RC_FILE_NAME [$USER_RC_FILE_PATH] file contains ONLY ONE reference to the feature's $RC_FILE_NAME [$RC_FILE_PATH] file" bash -c "test \$(sudo cat $USER_RC_FILE_PATH | grep '$RC_FILE_PATH' | grep source | wc -l) -eq '1'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
