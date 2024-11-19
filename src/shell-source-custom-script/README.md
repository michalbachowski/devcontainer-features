### **IMPORTANT NOTE**
- **Ids used to publish this Feature in the past - 'shell-local'**

# Load local file during shell init (shell-source-custom-script)

Adds a step to load (source) custom shell scrip when initializing Bash or Zsh.

## Example Usage

```json
"features": {
    "ghcr.io/michalbachowski/devcontainer-features/shell-source-custom-script:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| bash_script_path | Path to a script to be loaded when initializing Bash. | string | script.bash |
| zsh_script_path | Path to a script to be loaded when initializing Zsh. | string | script.zsh |

Default values to input arguments were added only to satisfy testing.

Scripts are added to the file, that is later sourced during shell (Bash/Zsh) initialization.

All shell-related scripts in this repo ([bash-prompt](../bash-prompt/), [bash-sensible](../bash-sensible/), [shell-execute-custom-script](../shell-execute-custom-script/), [shell-source-custom-script](../shell-source-custom-script/) and [zsh-prompt-currenttime](../zsh-prompt-currenttime/)) use common rc files `/devcontainer-feature/michalbachowski/bashrc` and `/devcontainer-feature/michalbachowski/zshrc` for Bash and Zsh respectively; this global files are then added (sourced) by container's user `.bashrc` and `.zshrc` respectivey.
If you override any of the user-specific rc files, then it is enough to source one of the aforementioned global rc files to enable all installed Bash-related features from this repo.

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/michalbachowski/devcontainer-features/blob/main/src/shell-source-custom-script/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
