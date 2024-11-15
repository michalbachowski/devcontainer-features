#!/usr/bin/env bash
set -e

FEATURE_NAME=custom-ca-cert

. ./library_scripts.sh

title $FEATURE_NAME

copy_feature_files feature_cache_dir $FEATURE_NAME

PIP_CONF_PATH=/etc/pip.conf
if ! cat $PIP_CONF_PATH | grep -q cert; then
    echo "Updating the pip config [$PIP_CONF_PATH] file."

    cat << EOF >> $PIP_CONF_PATH
[global]
cert=${SSL_CERT_FILE}
EOF
else
    echo "The pip config [$PIP_CONF_PATH] file contains the 'cert' entry, skipping"
fi

NPM_CONFIG_PATH=/etc/npmrc
if ! cat $NPM_CONFIG_PATH | grep -q cafile; then
    echo "Updating the NPM config [$NPM_CONFIG_PATH] file."

    cat << EOF >> /etc/npmrc
cafile=${SSL_CERT_FILE}
EOF
else
    echo "The NPM config [$SSL_CERT_FILE] file contains the 'cafile' entry, skipping."
fi

echo "$KEYTOOL_CERT_ALIAS" > ${DCFMB_COMMON_DIR}/${FEATURE_NAME}/keytool-alias.txt

if "$UPDATE_CERT_STORES_DURING_BUILD" = "true"; then
    ./update_cert_stores.sh
else
    touch ${DCFMB_COMMON_DIR}/${FEATURE_NAME}/update_cert_stores_during_build.mark
fi

echo Done
