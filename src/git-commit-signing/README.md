
# git-commit-signing (git-commit-signing)

Sets up container's git to sign & verify commits (will use --system not to interfere with local- or user-config).

## Example Usage

```json
"features": {
    "ghcr.io/michalbachowski/devcontainer-features/git-commit-signing:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| allowed_signers_file | Path to file containing list of allowed signers. Leave blank if you don't have one. Will be put as-is to git configuration. Learn how to create one: https://docs.gitlab.com/user/project/repository/signed_commits/ssh/#verify-commits-locally | string | - |
| force_verification_on_merge | Enables signature verification when merging changes. In order to work, the feature requires to also configure 'gpg.ssh.allowedSignersFile', but it will NOT be verified by the feature (you either set 'allowed_signers_file' option for this feature or setup git on your own). | boolean | true |
| key_format | Format o signing key. | string | ssh |
| signing_key | Path to signing key (SSH, GPG) or ID of the x509 key kept in smimesign. Will be put as-is to git configuration. See: https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-x509-key-1 | string | ~/.ssh/id_ed25519.pub |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/michalbachowski/devcontainer-features/blob/main/src/git-commit-signing/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
