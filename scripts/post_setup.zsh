#!/usr/local/bin/zsh

source ~/.zshrc

mkdir -p $ZSH_CUSTOM/themes
wget -O $ZSH_CUSTOM/themes/hyperzsh.zsh-theme \
  https://raw.githubusercontent.com/tylerreckart/hyperzsh/master/hyperzsh.zsh-theme

sed -i '' 's/theme=.*/theme="hyperzsh"/' ~/.zshrc.extras
