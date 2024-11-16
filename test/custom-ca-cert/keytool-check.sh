#!/usr/bin/env bash

CA_ALIAS="$1"

if ! command -v keytool >/dev/null; then
    echo "The keytool command is missing, aborting."
    exit 1
fi

# determine java version
java_version_output="$(java -version 2>&1 | head -n 1)"
echo $java_version_output
java_version="$(echo $java_version_output | grep -oP '\d+' | head -n 1)"

if [[ -z "$java_version" ]]; then
    echo "Could not find Java in \$PATH, this is non-recoverable error!"
    exit 1
fi

if (( $java_version >= 11 )); then
    echo "Java 11+ found. Will call [keytool] using keytool the [-cacert] arg."
    keytool_args="-cacerts"
else
    keystore_path=$JAVA_HOME/jre/lib/security/cacerts

    echo "Java <11 found. Will call [keytool] using the [-keystore $keystore_path] arg."
    keytool_args="-keystore $keystore_path"
fi

keytool -list $keytool_args -alias "$CA_ALIAS" -storepass changeit || exit 1
