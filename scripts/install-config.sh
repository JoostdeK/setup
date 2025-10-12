#!/usr/bin/bash

## clone config files
git clone --bare https://github.com/JoostdeK/jb.git $HOME/.jb
function jb {
  /usr/bin/git --git-dir=$HOME/.jb/ --work-tree=$HOME $@
}
rm $HOME/.zshrc
jb checkout
jb config --local status.showUntrackedFiles no
