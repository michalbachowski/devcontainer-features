Default values to input arguments were added only to satisfy testing.

Scripts are added to the file, that is later sourced during shell (Bash/Zsh) initialization.

All shell-related scripts in this repo ([bash-prompt](../bash-prompt/), [bash-sensible](../bash-sensible/), [shell-execute-custom-script](../shell-execute-custom-script/), [shell-source-custom-script](../shell-source-custom-script/) and [zsh-prompt-currenttime](../zsh-prompt-currenttime/)) use common rc files `/devcontainer-feature/michalbachowski/bashrc` and `/devcontainer-feature/michalbachowski/zshrc` for Bash and Zsh respectively; this global files are then added (sourced) by container's user `.bashrc` and `.zshrc` respectivey.
If you override any of the user-specific rc files, then it is enough to source one of the aforementioned global rc files to enable all installed Bash-related features from this repo.