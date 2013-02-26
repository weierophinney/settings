#!/usr/bin/zsh
alias ack=ack-grep
alias docblox="/usr/local/zend/bin/docblox"
# alias gview="gview -f"
# alias gvim="gvim -f"
# alias git="$HOME/bin/hub"
alias ls="ls --color=auto"
alias man="TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man"
alias mutt="/usr/bin/mutt -F ~/.muttrc -f ="
alias nerdtree="/usr/bin/vim -c NERDTree"
alias scp="rsync -vPe ssh"
alias tmux="/usr/local/tmux-1.6/bin/tmux"
alias vagrant="/opt/vagrant/bin/vagrant"
# alias vim="/usr/bin/vim -X"
alias zf="$HOME/bin/php $HOME/bin/zf.php"

# Per https://github.com/robbyrussell/oh-my-zsh/issues/766#issuecomment-4267841
git() {
    if ! (( $+_has_working_hub  ))
    then
        hub --version &> /dev/null
        _has_working_hub=$(($? == 0)) 
    fi
    if (( $_has_working_hub ))
    then
        hub "$@"
    else
        command git "$@"
    fi
}
