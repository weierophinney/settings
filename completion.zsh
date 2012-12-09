zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

source ~/.zsh/completion/git-completion.zsh
source ~/.zsh/completion/git-flow-completion.zsh

# source ~/.zsh/zf.zsh
