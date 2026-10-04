#!/bin/bash
echo """
set colorcolumn=80

set nu
if \$TABSTOP==''
        let TABSTOP=4
else
        let TABSTOP=\$TABSTOP
endif
let &softtabstop=TABSTOP
let &tabstop=TABSTOP
let &shiftwidth=TABSTOP
set nobackup
set mouse=a
set hlsearch
set ruler
set expandtab

filetype plugin indent on
syntax enable

colors koehler
""" >~/.vimrc

echo '''
bind c new-window -c "#{pane_current_path}"
bind \" split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
''' >~/.tmux.conf

cp ~/.bashrc bashrc-orig
cat <(echo '''
if [ $TERM = tmux-256color ] && [ .$opwd = . ]
then
    export opwd=$PWD
fi
''') bashrc-orig <(echo 'cd $opwd') >bashrc

cp bashrc ~/.bashrc
sudo apt update
sudo apt -y install silversearcher-ag vim tmux

sshport=$(ps aux | grep sshd | head -n 1 | tr " " "\n" | grep "\-p" -A 1 | tail -n 1)
sshaddr=$(ip addr show ${ifn:-bond0} | grep global | tr "/" " " | awk '{print $2}')

echo """Below is the command to connect to this server via jumper

ssh -tt jumper ssh -p $sshport tiger@$sshaddr

Set a password to access this server"""
sudo passwd tiger
