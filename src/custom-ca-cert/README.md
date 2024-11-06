
# Configure various tools to use custom CA cert (custom-ca-cert)

Enables several tools to use given custom CA Cert.

## Example Usage

```json
"features": {
    "ghcr.io/michalbachowski/devcontainer-features/custom-ca-cert:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| cert_path | Path to CA Cert (must be available within container). By default value from SSL_CERT_PATH will be used. | string | - |
| update_cert_stores_during_build | Whether to run the keytool / update-ca-certificates during build or in the onCreatedCommand (the latter allows for mounting the cert after the image is build). | boolean | false |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/michalbachowski/devcontainer-features/blob/main/src/custom-ca-cert/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._