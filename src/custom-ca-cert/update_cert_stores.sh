#!/usr/bin/env bash

if command -v update-ca-certificates >/dev/null; then
    echo "Running update-ca-certificates"
    update-ca-certificates
else
    echo "The update-ca-certificates command is missing, skipping."
fi

FEATURE_DIR=/devcontainer-feature/michalbachowski/custom-ca-cert

CA_ALIAS=$(cat $FEATURE_DIR/keytool-alias.txt)

if ! command -v keytool >/dev/null; then
    echo "The keytool command is missing, skipping."
elif keytool -list -cacerts -alias "$CA_ALIAS" -storepass changeit >/dev/null; then
    echo "The cert with [$CA_ALIAS] exists in the Java CA Certs, skipping."
else
    # determine java version
    java_version_output="$(java -version 2>&1 | head -n 1)"
    echo $java_version_output
    java_version="$(echo $java_version_output | grep -oP '\d+' | head -n 1)"

    echo "Adding cert [$SSL_CERT_FILE] with alias [$CA_ALIAS] JVM certificates"

    if [[ -z "$java_version" ]]; then
        echo "Could not find Java in \$PATH, this is non-recoverable error!"
        exit 1
    fi

    if (( $java_version >= 11 )); then
        echo "Adding using keytool with the [-cacert] arg."

        keytool \
            -import \
            -trustcacerts \
            -cacerts \
            -storepass changeit \
            -noprompt \
            -alias "$CA_ALIAS" \
            -file $SSL_CERT_FILE
    else
        keystore_path=/opt/java/openjdk/jre/lib/security/cacerts
        echo "Adding to the [$keystore_path] keystore using keytool."

        keytool \
            -import \
            -trustcacerts \
            -storepass changeit \
            -keystore "$keystore_path" \
            -noprompt \
            -alias "$CA_ALIAS" \
            -file $SSL_CERT_FILE
    fi
fi
