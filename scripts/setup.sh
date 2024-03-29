#!/bin/bash

set -e

if [ -f /etc/profile ]; then source /etc/profile; fi

### VARIABLES ###

SCRIPTS_DIR=$(dirname ${BASH_SOURCE[0]})
DOTFILES_HOME=${DOTFILES_HOME:-${HOME}/.dotfiles}
OHMYZSH_URL=https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh
BREW_URL=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

DOTFILES_CLONE_URL=git@github.com:dan-j/.dotfiles.git

### PREREQUISTITES ###
cli_tools_path=$(xcode-select -p)

if [[ -z $cli_tools_path ]] || [[ -f $cli_tools_path ]]; then
  echo "Installing MacOS Command Line Tools"
  xcode-select --install
fi

### INSTALL ###

/bin/bash -c "$(curl -fsSL $BREW_URL)"

BREW_TAPS="caskroom/cask caskroom/versions caskroom/fonts"

CASK_PACKAGES="java8 iterm2 font-hack 1password 1password-cli alfred"
BREW_PACKAGES="coreutils git zsh tmux wget jq nvm python2 python3 pyenv httpie htop reattach-to-user-namespace yarn vim mongodb mysql kubernetes-helm kubernetes-cli jwt-cli"

### SETUP ###

# echo $BREW_TAPS | xargs -n1 brew tap
brew install --cask $CASK_PACKAGES
brew install $BREW_PACKAGES

sh -c "$(wget ${OHMYZSH_URL} -O -)"

# insert "source ~/.zshrc.extras" before sourcing oh-my-zsh
sed -i '' '/source $ZSH\/oh-my-zsh.sh/i\
source ~/.zshrc.extras\
' ~/.zshrc

# we always want a projects directory
mkdir -p ${HOME}/projects

# setup 1password-cli
echo -n "1Password Address: "; read one_password_addr

echo -n "1Password Email: "; read one_password_email

echo -n "1Password Secret Key: ";
# suppress password being displayed on screen and re-enable afterwards
stty -echo; read one_password_secret; stty echo; echo

token_1password=$(
  op signin --output=raw \
    $one_password_addr $one_password_email $one_password_secret
)

if [ -d "${HOME}/.ssh" ]; then
  mv ${HOME}/.ssh ${HOME}/.ssh_bak
fi

OP_SESSION_danandches=${token_1password} \
  op get document ssh_keys.tar.gz | tar x -C ${HOME}

if [[ ! -d ${DOTFILES_HOME} ]]; then
  git clone ${DOTFILES_CLONE_URL} ${DOTFILES_HOME}
fi

# Setup vim Plug and install plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

dotfiles=$(
  find ${DOTFILES_HOME} -name ".*" -maxdepth 1 -exec basename {} \; \
    | tail +2 \
    | grep -vE ".git(modules)?$"
)

for dotfile in $dotfiles; do
  if [[ -a ${HOME}/$dotfile ]]; then
    mv ${HOME}/$dotfile ${HOME}/${dotfile}.bak
  fi
  ln -s ${DOTFILES_HOME}/$dotfile $HOME
done

# don't forget tmux.conf
ln -s ${HOME}/.tmux/.tmux.conf ${HOME}

# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${DOTFILES_HOME}/iterm2"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

exec "${DOTFILES_HOME}/scripts/post_setup.zsh"
