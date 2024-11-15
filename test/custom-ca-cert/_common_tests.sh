source test_scripts.sh


PIP_CONF_PATH=/etc/pip.conf
NPM_CONFIG_PATH=/etc/npmrc
CERT_PATH="${CERT_PATH:-/usr/local/share/ca-certificates/custom-ca-cert.crt}"
CA_ALIAS="${CA_ALIAS:-CustomCA}"

ALIAS_FILE_PATH=${COMMON_DIR}/custom-ca-cert/keytool-alias.txt
MARK_FILE_PATH=${COMMON_DIR}/custom-ca-cert/update_cert_stores_during_build.mark

check "The keytool alias file [$ALIAS_FILE_PATH] exists" bash -c "test -f \"$ALIAS_FILE_PATH\""
check "The keytool alias file [$ALIAS_FILE_PATH] contains the expected [$CA_ALIAS] alias" bash -c "cat \"$ALIAS_FILE_PATH\" | grep -q \"$CA_ALIAS\""
check "cert was added to JVM's CACert store" bash -c "keytool -list -cacerts -alias \"$CA_ALIAS\" -storepass changeit || exit 1"

if [ -z "$NO_MARK_FILE" ]; then
    check "The mark file [$MARK_FILE_PATH] exists" bash -c "test -f \"$MARK_FILE_PATH\""
else
    check "The mark file [$MARK_FILE_PATH] DOES NOT exist" bash -c "test ! -f \"$MARK_FILE_PATH\""
fi

check_env_is_set CURL_CA_BUNDLE "$CERT_PATH"
check_env_is_set NODE_EXTRA_CA_CERTS "$CERT_PATH"
check_env_is_set NODE_CONFIG_CAFILE "$CERT_PATH"
check "The [NODE_OPTIONS] prop is effectively set to [--use-openssl-ca]" bash -c "[ \"\$NODE_OPTIONS\" = \"--use-openssl-ca\" ] || exit 1"
check_env_is_set NODE_OPTIONS '--use-openssl-ca'
check_env_is_set PIP_CERT "$CERT_PATH"
check_env_is_set REQUESTS_CA_BUNDLE "$CERT_PATH"
# got "both" test case effective cert is different!
check_env_is_set SSL_CERT_FILE "$CERT_PATH"

check_file_contains "cert=$CERT_PATH" $PIP_CONF_PATH
check_file_contains "cafile=$CERT_PATH" $NPM_CONFIG_PATH
