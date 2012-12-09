#!/usr/bin/zsh
# Functions
put_key() {
    if [ ! -s ~/.ssh/id_dsa.pub ];then
        ssh-keygen -t dsa
    fi
    cat ~/.ssh/id_dsa.pub | ssh $1 'sh -c "cat - >> ~/.ssh/authorized_keys"'
}

# These are used to fix an issue in unity:
# https://bugs.launchpad.net/ubuntu/+source/vim/+bug/776499
# When that is resolved, we can remove it.
gvim() {
    /usr/bin/gvim -f $* &
}

gview() {
    /usr/bin/gview -f $* &
}
