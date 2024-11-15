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

source _common_tests.sh

function check_env_is_not_duplicated
{
    env_name="$1"

    check "The [$ENV_FILE_PATH] file contains [$env_name] env with the [$CERT_PATH] value ONLY ONCE" bash -c "test \$(cat $ENV_FILE_PATH | grep '$env_name' | grep '$CERT_PATH' | wc -l) -eq '1'"
}

check "test" bash -c "cat $ENV_FILE_PATH"
check_env_is_not_duplicated CURL_CA_BUNDLE
check_env_is_not_duplicated NODE_EXTRA_CA_CERTS
check_env_is_not_duplicated NODE_CONFIG_CAFILE
check_env_is_not_duplicated PIP_CERT
check_env_is_not_duplicated REQUESTS_CA_BUNDLE
check_env_is_not_duplicated SSL_CERT_FILE

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
