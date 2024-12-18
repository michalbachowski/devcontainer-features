fpath+=$ZSH_AUTOCOMPLETE_PATH
zstyle ':completion:*:descriptions' format "%U%B%d%b%u"
zstyle ':completion:*:messages' format "%F{green}%d%f"
autoload -Uz compinit
compinit -u