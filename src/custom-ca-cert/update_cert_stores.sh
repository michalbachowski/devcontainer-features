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

function update-keytool
{
    if ! command -v java >/dev/null; then
        echo "Could not find Java in \$PATH, skipping!"
        return
    fi

    CA_ALIAS=$(cat $FEATURE_DIR/keytool-alias.txt)

    # determine java version
    java_version_output="$(java -version 2>&1 | head -n 1)"
    echo $java_version_output
    java_version="$(echo $java_version_output | grep -oP '\d+' | head -n 1)"

    if [[ -z "$java_version" ]]; then
        echo "Could not determine Java version, skipping!"
        return
    fi

    if (( $java_version >= 11 )); then
        echo "Java 11+ found. Will call [keytool] using keytool the [-cacert] arg."
        keytool_args="-cacerts"
    else
        keystore_path=$JAVA_HOME/jre/lib/security/cacerts

        echo "Java <11 found. Will call [keytool] using the [-keystore $keystore_path] arg."
        keytool_args="-keystore $keystore_path"
    fi

    if ! command -v keytool >/dev/null; then
        echo "The keytool command is missing, skipping."
        return
    fi

    if keytool -list $keytool_args -alias "$CA_ALIAS" -storepass changeit >/dev/null; then
        echo "The cert with [$CA_ALIAS] exists in the Java CA Certs, skipping."
        return
    fi

    echo "Adding cert [$CERT_PATH] with alias [$CA_ALIAS] JVM certificates"

    keytool \
        -import \
        -trustcacerts \
        $keytool_args \
        -storepass changeit \
        -noprompt \
        -alias "$CA_ALIAS" \
        -file $CERT_PATH
}

update-keytool
