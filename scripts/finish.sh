#!/usr/bin/bash

# Desired shell path (check with `which zsh`)
NEW_SHELL="$(which zsh)"

# Change default shell for current user
chsh -s "$NEW_SHELL"
