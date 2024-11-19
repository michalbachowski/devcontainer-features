### **IMPORTANT NOTE**
- **Ids used to publish this Feature in the past - 'shell-local'**

# Execute given script during shell init (shell-execute-custom-script)

Adds a step to execute custom shell scrip when initializing Bash or Zsh.

## Example Usage

```json
"features": {
    "ghcr.io/michalbachowski/devcontainer-features/shell-execute-custom-script:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| bash_script | Script to execute when initializing Bash | string | echo Bash > /dev/null |
| common_script | Script to execute when initializing either Bash or Zsh. By default will add the git-uncommit-all-changes alias, usefull to uncommit all changes made on the branch since creation. You can use the BRANCH_NAME env var to change the main branch. | string | alias git-uncommit-all-changes='git reset --soft \$(git merge-base HEAD \${BASE_BRANCH:-main})' |
| zsh_script | Script to execute when initializing Zsh. | string | echo Zsh > /dev/null |

Default values to input arguments were added only to satisfy testing.

Scripts are added to the file, that is later sourced during shell (Bash/Zsh) initialization.

All shell-related scripts in this repo ([bash-prompt](../bash-prompt/), [bash-sensible](../bash-sensible/), [shell-execute-custom-script](../shell-execute-custom-script/), [shell-source-custom-script](../shell-source-custom-script/) and [zsh-prompt-currenttime](../zsh-prompt-currenttime/)) use common rc files `/devcontainer-feature/michalbachowski/bashrc` and `/devcontainer-feature/michalbachowski/zshrc` for Bash and Zsh respectively; this global files are then added (sourced) by container's user `.bashrc` and `.zshrc` respectivey.
If you override any of the user-specific rc files, then it is enough to source one of the aforementioned global rc files to enable all installed Bash-related features from this repo.

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/michalbachowski/devcontainer-features/blob/main/src/shell-execute-custom-script/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
