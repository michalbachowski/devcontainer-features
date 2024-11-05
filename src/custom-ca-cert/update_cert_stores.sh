#!/usr/bin/env bash

if command -v update-ca-certificates; then
    echo "Running update-ca-certificates"
    update-ca-certificates
else
    echo "The update-ca-certificates command is missing, skipping."
fi

if command -v keytool; then
    paths=(
        /opt/java/openjdk/lib/security/cacerts
        /opt/java/openjdk/jre/lib/security/cacerts
    )
    for keystore_path in ${paths[@]}; do
        if [ ! -f "$keystore_path" ]; then
            echo "The keystore [$keystore_path] does not exists, skipping."
            continue
        fi

        echo "Adding cert [$SSL_CERT_FILE] to the [$keystore_path] keystore."

        keytool \
            -import \
            -trustcacerts \
            -storepass changeit \
            -keystore "$keystore_path" \
            -noprompt \
            -alias CustomCA \
            -file ${CERT_PATH}
    done
else
    echo "The keytool command is missing, skipping."
fi
