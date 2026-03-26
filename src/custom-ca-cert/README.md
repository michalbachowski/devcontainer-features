
# Configure various tools to use custom CA cert (custom-ca-cert)

Enables several tools to use given custom CA Cert. The cert must be placed to [/usr/local/share/ca-certificates/custom-ca-cert.crt] path!

## Example Usage

```json
"features": {
    "ghcr.io/michalbachowski/devcontainer-features/custom-ca-cert:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| keytool_cert_alias | An alias to be used for a cert when adding to JVM's keytool | string | CustomCA |
| update_cert_stores_during_build | Whether to run the keytool / update-ca-certificates during build or in the onCreatedCommand (the latter allows for mounting the cert after the image is build). | boolean | false |

Sets some environment variables and adds custom configuration for some tools (eg. `keytool`, `pip`, `npm`) to use given custom CA cert.
The cert might be given by `SSL_CERT_FILE` environment variable or as a explicit option to the feature.
The feature **will not** copy or create the cert - it is user's duty to deliver the cert to the container (by adding it to the image or mount).
Note that if you decide to mount the certificate, the effects will be visible after the setup is done and the cert is available to the container processes.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/michalbachowski/devcontainer-features/blob/main/src/custom-ca-cert/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
