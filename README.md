# .dotfiles

Personal macOS dev environment: zsh + zinit + starship, tmux (oh-my-tmux), neovim with lazy.nvim, iTerm2.

## Bootstrap a new machine

```sh
git clone git@github.com:dan-j/.dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/setup.sh
```

The script:
- Installs Homebrew at `~/homebrew` (custom prefix)
- Installs all brew formulae and casks listed in `scripts/setup.sh`
- Symlinks every tracked dotfile into `~` and `~/.config`
- Points iTerm2 at the prefs in `iterm2/`
- Triggers initial `nvim --headless +Lazy! sync` to install plugins
- Applies macOS defaults from `.osx`

Manual follow-ups: sign in to 1Password (for SSH keys), `gcloud auth login`, `gh auth login`.

## What's tracked

| Path | Notes |
|---|---|
| `.gitconfig` | git user, aliases, push defaults |
| `.osx` | macOS `defaults write` tweaks |
| `.tmux.conf.local` | overrides for [gpakosz/.tmux](https://github.com/gpakosz/.tmux) |
| `.zshrc` | tiny — sets PATH and sources `.zshrc.extras` |
| `.zshrc.extras` | the real zsh config (zinit, starship, completions, history, plugins) |
| `.config/nvim/` | neovim config (lazy.nvim, LSP, treesitter, etc. — see [nvim README](.config/nvim/README.md)) |
| `.config/starship.toml` | starship prompt config |
| `.config/k9s/` | k9s aliases, config, skins (cluster state in `clusters/` is not tracked) |
| `.config/htop/htoprc` | htop UI config |
| `.config/git/ignore` | global gitignore |
| `iterm2/` | iTerm2 preferences (PrefsCustomFolder target) |

## Tmux

The `.tmux.conf.local` is the override file for [oh-my-tmux](https://github.com/gpakosz/.tmux). Install that framework separately if needed — it expects `~/.tmux/.tmux.conf` to be symlinked to `~/.tmux.conf`. The status line uses `starship module kubernetes/gcloud/aws` for context display.

## Neovim

Config under `.config/nvim/`. See [.config/nvim/README.md](.config/nvim/README.md) for the full keybinding reference. Plugin versions are pinned via `lazy-lock.json`.
