#!/usr/bin/bash

## clone config files
git init --bare $HOME/.jb

echo "alias jb='/usr/bin/git --git-dir=\$HOME/.jb/ --work-tree=\$HOME'" >>"$HOME/.zshrc"
source $HOME/.zshrc

jb config --local status.showUntrackedFiles no
