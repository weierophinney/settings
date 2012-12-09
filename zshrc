HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch notify CD_ABLE_VARS CORRECT MULTIOS
unsetopt beep
bindkey -e

# Performance optimizations
# See http://www.webupd8.org/2010/11/alternative-to-200-lines-kernel-patch.html
# Maybe no longer needed as of ubuntu 11.04?
# if [ "$PS1" ];then
#     mkdir -m 0700 /dev/cgroup/cpu/user/$$ > /dev/null 2>&1
#     echo $$ > /dev/cgroup/cpu/user/$$/tasks
#     echo "1" > /dev/cgroup/cpu/user/$$/notify_on_release
# fi

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/matthew/.zshrc'

fpath=($fpath $HOME/.zsh/zsh-git)
typeset -U fpath

autoload -Uz compinit
compinit

for s in ~/.zsh/*.zsh;do
    source $s
done

# source $HOME/.zsh/git_prompt
