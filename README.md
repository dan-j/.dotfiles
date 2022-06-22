# .dotfiles

This repository holds my personal dotfiles targeting MacOS on ZSH. This repository should be cloned and then the 
appropriate dotfiles symlinked to your home directory.

There's also two manual steps:

1. Include `.tmux.conf.local` from your proper `.tmux.conf` file. This allows you to use standard configurations 
   shared online and then customise them appropriately.
2. Source `.zshrc.extras` from your proper `.zshrc` file. Again, this allows you to have custom zsh libraries like 
   oh-my-zsh which configure a default `.zshrc` without having to deal with many complications.