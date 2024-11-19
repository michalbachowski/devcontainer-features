
# Add sensible bash defaults (bash-sensible)

Copies the bash-sensible (static copy of https://github.com/mrzool/bash-sensible) over to container and augments .bashrc with a code to load the config

## Example Usage

```json
"features": {
    "ghcr.io/michalbachowski/devcontainer-features/bash-sensible:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|


Config is copied to container and is later sourced during shell (Bash/Zsh) initialization.

All shell-related scripts in this repo ([bash-prompt](../bash-prompt/), [bash-sensible](../bash-sensible/), [shell-execute-custom-script](../shell-execute-custom-script/), [shell-source-custom-script](../shell-source-custom-script/) and [zsh-prompt-currenttime](../zsh-prompt-currenttime/)) use common rc files `/devcontainer-feature/michalbachowski/bashrc` and `/devcontainer-feature/michalbachowski/zshrc` for Bash and Zsh respectively; this global files are then added (sourced) by container's user `.bashrc` and `.zshrc` respectivey.
If you override any of the user-specific rc files, then it is enough to source one of the aforementioned global rc files to enable all installed Bash-related features from this repo.

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/michalbachowski/devcontainer-features/blob/main/src/bash-sensible/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
