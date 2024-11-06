#!/usr/bin/env bash

echo "Running onCreateCommand for [custom-ca-cert] feature"

ENV_FILE_PATH=/etc/environment

set -a

source $ENV_FILE_PATH

set +a

cat $ENV_FILE_PATH

if [ "$SSL_CERT_FILE" != "${DEVCONTAINER_CUSTOM_CA_CERT_VALUE}" ]; then
    echo "SSL_CERT_FILE=\"${DEVCONTAINER_CUSTOM_CA_CERT_VALUE}\"" >> /etc/environment;
fi

if [ "$UPDATE_CERT_STORES_DURING_BUILD" = 'false' ]; then
    /devcontainer-feature/michalbachowski/custom-ca-cert/update_cert_stores.sh
fi

echo "Done"
