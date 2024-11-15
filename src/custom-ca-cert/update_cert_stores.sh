#!/usr/bin/env bash

FEATURE_DIR=/devcontainer-feature/michalbachowski/custom-ca-cert
CERT_PATH=/usr/local/share/ca-certificates/custom-ca-cert.crt

if [ ! -f "$CERT_PATH" ]; then
    echo "The [$CERT_PATH] certificate does not exist. Please provide it first either by adding COPY command inside the Dockerfile or mounting the file to the container."
    exit 1
fi

if command -v update-ca-certificates >/dev/null; then
    echo "Running update-ca-certificates"
    update-ca-certificates
else
    echo "The update-ca-certificates command is missing, skipping."
fi

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

    echo "Adding cert [$CERT_PATH] with alias [$CA_ALIAS] JVM certificates"

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
            -file $CERT_PATH
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
            -file $CERT_PATH
    fi
fi
