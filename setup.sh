#!/bin/bash

### TODO ###

Separate script to install brew, git, clone .dotfiles, and run remaining
installs. This separate script will be documented in README.md and executed
similar to brew with a URL to the raw script in GitHub.

### VARIABLES ###

BREW_URL=https://raw.githubusercontent.com/Homebrew/install/master/install
BREW_INSTALL="/usr/bin/ruby -e \"$(curl -fsSL $BREW_URL)\""

BREW_TAPS="caskroom/versions caskroom/fonts"

CASK_PACKAGES="java8 atom iterm2 font-hack"
BREW_PACKAGES="maven git zsh tmux wget"

### PRECONDITIONS ###

# ssh keys extracted incl. known_hosts (1password)

### SETUP ###

mkdir ~/Projects

brew tap $BREW_TAPS
brew cask install $CASK_PACKAGES
brew install $BREW_PACKAGES
