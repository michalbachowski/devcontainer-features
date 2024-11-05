source test_scripts.sh


export ENV_FILE_PATH="/etc/environment"
PIP_CONF_PATH=/etc/pip.conf
NPM_CONFIG_PATH=/etc/npmrc

function check_env_is_set
{
    env_name="$1"
    path="${2:-$ENV_FILE_PATH}"
    cert="${3:-${CERT_PATH:-/test/cert}}"
    check "The [$env_name] prop is set in the [$path] and contains [$cert] as a value" bash -c "cat $path | grep $env_name | grep -q '$cert'"

    # for environment variables, check effective values
    if [ "$path" = "$ENV_FILE_PATH" ]; then
        check "The [$env_name] prop is effectively set to [$cert]" bash -i -c "set -a; source /etc/environment; [ \"\$$env_name\" = \"$cert\" ] || exit 1"
    fi
}

check "test" bash -c "cat /etc/environment"

check_env_is_set CURL_CA_BUNDLE
check_env_is_set NODE_EXTRA_CA_CERTS
check_env_is_set NODE_CONFIG_CAFILE
check_env_is_set PIP_CERT
check_env_is_set REQUESTS_CA_BUNDLE
# got "both" test case effective cert is different!
check_env_is_set SSL_CERT_FILE 

check_env_is_set cert $PIP_CONF_PATH
check_env_is_set cafile $NPM_CONFIG_PATH
