source test_scripts.sh


export ENV_FILE_PATH="/etc/environment"
PIP_CONF_PATH=/etc/pip.conf
NPM_CONFIG_PATH=/etc/npmrc
CERT_PATH="${CERT_PATH:-/optcert.pem}"

function check_env_is_set_
{
    env_name="$1"
    path="${2:-$ENV_FILE_PATH}"

    check_env_is_set "$env_name" "$CERT_PATH" "$path"
}

check "test" bash -c "cat /etc/environment"

check_env_is_set_ CURL_CA_BUNDLE
check_env_is_set_ NODE_EXTRA_CA_CERTS
check_env_is_set_ NODE_CONFIG_CAFILE
check_env_is_set_ PIP_CERT
check_env_is_set_ REQUESTS_CA_BUNDLE
# got "both" test case effective cert is different!
check_env_is_set_ SSL_CERT_FILE 

check_env_is_set_ cert $PIP_CONF_PATH
check_env_is_set_ cafile $NPM_CONFIG_PATH
