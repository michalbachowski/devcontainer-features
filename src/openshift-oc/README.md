
# openshift-oc (via cUrl from openshift.com) (openshift-oc)

Installs the Openshift's oc tool by downloading artifact from openshift.com

## Example Usage

```json
"features": {
    "ghcr.io/michalbachowski/devcontainer-features/openshift-oc:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select the version to install. The version must have artifact for your platform pre-built. You can use both [latest] and [stable] as a value. | string | 4.17.0 |

> [!NOTE]
> Download URLs depend heavily on version, and are a mess.
> If you need to use a version that does not produce proper URL,
> open a PR with changes to support it.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/michalbachowski/devcontainer-features/blob/main/src/openshift-oc/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
