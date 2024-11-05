#!/bin/bash

# The 'test/_global' folder is a special test folder that is not tied to a single feature.
#
# This test file is executed against a running container constructed
# from the value of 'color_and_hello' in the tests/_global/scenarios.json file.
#
# The value of a scenarios element is any properties available in the 'devcontainer.json'.
# Scenarios are useful for testing specific options in a feature, or to test a combination of features.
# 
# This test can be run with the following command (from the root of this repo)
#    devcontainer features test --global-scenarios-only .

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

DEST_DIR=/devcontainer-feature/michalbachowski
USER=root
HOMEDIR=/root
PROMPT_FILE_NAME=prompt.bash
PROMPT_FILE_PATH=$DEST_DIR/$PROMPT_FILE_NAME
SENSIBLE_FILE_NAME=sensible.bash
SENSIBLE_FILE_PATH=$DEST_DIR/$SENSIBLE_FILE_NAME
RC_FILE_NAME=bashrc
RC_FILE_PATH=$DEST_DIR/$RC_FILE_NAME
USER_RC_FILE_PATH=$HOMEDIR/.$RC_FILE_NAME

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib. Syntax is...
# check <LABEL> <cmd> [args...]
check "The $PROMPT_FILE_NAME [$PROMPT_FILE_PATH] file exists" bash -c "test -f $PROMPT_FILE_PATH"
check "The $PROMPT_FILE_NAME [$PROMPT_FILE_PATH] file is owned by the [$USER] user" bash -c "stat -c "%U" $PROMPT_FILE_PATH | grep -q -E '^$USER$'"
check "The $RC_FILE_NAME [$RC_FILE_PATH] file exists" bash -c "test -f $RC_FILE_PATH"
check "The $RC_FILE_NAME [$RC_FILE_PATH] file exists is owned by the [$USER] user" bash -c "stat -c "%U" $RC_FILE_PATH | grep -q -E '^$USER$'"
check "The $RC_FILE_NAME [$RC_FILE_PATH] file contains a reference to the $PROMPT_FILE_NAME [$PROMPT_FILE_PATH] file" bash -c "cat $RC_FILE_PATH | grep '$PROMPT_FILE_PATH' | grep -q source"
check "The user's [$USER] $RC_FILE_NAME [$USER_RC_FILE_PATH] file exists" bash -c "test -f $USER_RC_FILE_PATH"
check "The user's [$USER] $RC_FILE_NAME [$USER_RC_FILE_PATH] file exists is owned by the [$USER] user" bash -c "stat -c "%U" $USER_RC_FILE_PATH | grep -q -E '^$USER$'"
check "The user's [$USER] $RC_FILE_NAME [$USER_RC_FILE_PATH] file contains a reference to the feature's $RC_FILE_NAME [$RC_FILE_PATH] file" bash -c "cat '$USER_RC_FILE_PATH' | grep '$RC_FILE_PATH' | grep -q source"

check "The $SENSIBLE_FILE_NAME [$SENSIBLE_FILE_PATH] file exists" bash -c "test -f $SENSIBLE_FILE_PATH"
check "The $SENSIBLE_FILE_NAME [$SENSIBLE_FILE_PATH] file is owned by the [$USER] user" bash -c "stat -c "%U" $SENSIBLE_FILE_PATH | grep -q -E '^$USER$'"
check "The $RC_FILE_NAME [$RC_FILE_PATH] file exists" bash -c "test -f $RC_FILE_PATH"
check "The $RC_FILE_NAME [$RC_FILE_PATH] file exists is owned by the [$USER] user" bash -c "stat -c "%U" $RC_FILE_PATH | grep -q -E '^$USER$'"
check "The $RC_FILE_NAME [$RC_FILE_PATH] file contains a reference to the $SENSIBLE_FILE_NAME [$SENSIBLE_FILE_PATH] file" bash -c "cat $RC_FILE_PATH | grep '$SENSIBLE_FILE_PATH' | grep -q source"
check "The user's [$USER] $RC_FILE_NAME [$USER_RC_FILE_PATH] file exists" bash -c "test -f $USER_RC_FILE_PATH"
check "The user's [$USER] $RC_FILE_NAME [$USER_RC_FILE_PATH] file exists is owned by the [$USER] user" bash -c "stat -c "%U" $USER_RC_FILE_PATH | grep -q -E '^$USER$'"
check "The user's [$USER] $RC_FILE_NAME [$USER_RC_FILE_PATH] file contains a reference to the feature's $RC_FILE_NAME [$RC_FILE_PATH] file" bash -c "cat '$USER_RC_FILE_PATH' | grep '$RC_FILE_PATH' | grep -q source"

check "The user's [$USER] $RC_FILE_NAME [$USER_RC_FILE_PATH] file contains ONLY ONE reference to the feature's $RC_FILE_NAME [$RC_FILE_PATH] file" bash -c "test \$(cat $USER_RC_FILE_PATH | grep '$RC_FILE_PATH' | grep source | wc -l) -eq '1'"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
