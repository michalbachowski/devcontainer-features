#!/usr/bin/env bash
set -e

ENV_FILE_PATH=/etc/environment

echo "Activating the [custom-ca-cert] feature."

if [ -z "$CERT_PATH" ]; then
    if [ -z "$SSL_CERT_FILE" ]; then
        echo "Neither CERT_PATH nor SSL_CERT_FILE are given, skipping"
        exit 1
    fi
    CERT_PATH=$SSL_CERT_FILE
fi

function set_env
{
    env_name="$1"
    value="${2:-$CERT_PATH}"

    if ! cat $ENV_FILE_PATH | grep $env_name | grep "$value"; then
        echo "Setting environment variable [$env_name]"
        echo "${env_name}=\"$value\"" >> $ENV_FILE_PATH
    fi
}

set_env CURL_CA_BUNDLE
set_env DEVCONTAINER_CUSTOM_CA_CERT_VALUE
set_env NODE_EXTRA_CA_CERTS
set_env NODE_CONFIG_CAFILE
set_env PIP_CERT
set_env REQUESTS_CA_BUNDLE
# do not re-add SSL_CERT_FILE if the value does not change
if [ "$SSL_CERT_FILE" != "$CERT_PATH" ]; then
    set_env SSL_CERT_FILE
fi
set_env UPDATE_CERT_STORES_DURING_BUILD "$UPDATE_CERT_STORES_DURING_BUILD"

PIP_CONF_PATH=/etc/pip.conf
if ! cat $PIP_CONF_PATH | grep -q cert; then
    echo "Updating the pip config [$PIP_CONF_PATH] file."

    cat << EOF >> $PIP_CONF_PATH
[global]
cert=${CERT_PATH}
EOF
else
    echo "The pip config [$PIP_CONF_PATH] file contains the 'cert' entry, skipping"
fi

NPM_CONFIG_PATH=/etc/npmrc
if ! cat $NPM_CONFIG_PATH | grep -q cafile; then
    echo "Updating the NPM config [$NPM_CONFIG_PATH] file."

    cat << EOF >> /etc/npmrc
cafile=${CERT_PATH}
EOF
else
    echo "The NPM config [$NPM_CONFIG_PATH] file contains the 'cafile' entry, skipping."
fi

if "$UPDATE_CERT_STORES_DURING_BUILD" = "true"; then
    ./update_cert_stores.sh
fi

echo Done
