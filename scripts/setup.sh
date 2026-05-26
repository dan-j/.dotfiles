#!/bin/bash
#
# Bootstrap a fresh macOS install from this dotfiles repo.
#
# Prerequisites (must be done manually before running):
#   - Install 1Password.app and configure the SSH agent so `git@github.com:`
#     URLs authenticate. Brew taps clone from GitHub via SSH.
#   - If ~/.gitconfig.local has machine-specific overrides (insteadOf etc.),
#     put it in place before running.
#
# Steps:
#   1. Install macOS CLI tools (xcode-select)
#   2. Install Homebrew (default location, or HOMEBREW_PREFIX if set)
#   3. Symlink dotfiles into ~ and ~/.config (must happen before brew taps
#      so .gitconfig is active when git clones from GitHub)
#   4. Install brew formulae and casks
#   5. Point iTerm2 at the prefs in this repo
#   6. Trigger initial neovim plugin install
#
# Re-running is safe; existing files are backed up to <name>.bak.

set -euo pipefail

SCRIPTS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILES_HOME=${DOTFILES_HOME:-${HOME}/.dotfiles}

#
# 1. macOS Command Line Tools
#
if ! xcode-select -p &>/dev/null; then
  echo "==> Installing macOS Command Line Tools"
  xcode-select --install
  echo "Re-run this script once xcode-select finishes."
  exit 0
fi

#
# 2. Homebrew
#
# If HOMEBREW_PREFIX is set by the user before running, install via tarball
# into that prefix (no sudo). Otherwise check the standard locations for an
# existing install; if none is found, run the official installer which picks
# /opt/homebrew on Apple Silicon and /usr/local on Intel.
#
# PATH isn't configured yet at this point, so `command -v brew` is unreliable
# — probe the filesystem instead.
#
detect_brew_prefix() {
  local prefix
  for prefix in /opt/homebrew /usr/local "$HOME/homebrew"; do
    if [[ -x "$prefix/bin/brew" ]]; then
      printf '%s' "$prefix"
      return 0
    fi
  done
  return 1
}

if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
  if [[ ! -x ${HOMEBREW_PREFIX}/bin/brew ]]; then
    echo "==> Installing Homebrew to ${HOMEBREW_PREFIX} (custom prefix)"
    mkdir -p "${HOMEBREW_PREFIX}"
    curl -L https://github.com/Homebrew/brew/tarball/master \
      | tar xz --strip 1 -C "${HOMEBREW_PREFIX}"
  fi
else
  HOMEBREW_PREFIX=$(detect_brew_prefix || true)
  if [[ -z "$HOMEBREW_PREFIX" ]]; then
    echo "==> Installing Homebrew (default location)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    HOMEBREW_PREFIX=$(detect_brew_prefix) || {
      echo "ERROR: brew not found after install" >&2
      exit 1
    }
  fi
fi

# brew shellenv sets PATH, MANPATH, HOMEBREW_PREFIX, HOMEBREW_CELLAR, HOMEBREW_REPOSITORY, FPATH, INFOPATH
eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1

#
# 3. Symlinks (must happen before brew taps so git config is active)
#
echo "==> Symlinking dotfiles"

# Top-level dotfiles
TOP_LEVEL=( .gitconfig .osx .tmux.conf.local .zshrc .zshrc.extras )
for f in "${TOP_LEVEL[@]}"; do
  src="${DOTFILES_HOME}/${f}"
  dst="${HOME}/${f}"
  [[ -e ${dst} && ! -L ${dst} ]] && mv "${dst}" "${dst}.bak"
  ln -sfn "${src}" "${dst}"
done

# ~/.config: symlink whole directories where there's no app-managed state,
# symlink individual files where there is.
mkdir -p "${HOME}/.config"

# Whole-directory symlinks (no app-managed state we want to preserve)
for dir in nvim htop; do
  src="${DOTFILES_HOME}/.config/${dir}"
  dst="${HOME}/.config/${dir}"
  [[ -e ${dst} && ! -L ${dst} ]] && mv "${dst}" "${dst}.bak"
  ln -sfn "${src}" "${dst}"
done

# Single-file symlinks
ln -sfn "${DOTFILES_HOME}/.config/starship.toml" "${HOME}/.config/starship.toml"

mkdir -p "${HOME}/.config/git"
ln -sfn "${DOTFILES_HOME}/.config/git/ignore" "${HOME}/.config/git/ignore"

# k9s — preserve ~/.config/k9s/clusters/ state
mkdir -p "${HOME}/.config/k9s"
ln -sfn "${DOTFILES_HOME}/.config/k9s/aliases.yaml" "${HOME}/.config/k9s/aliases.yaml"
ln -sfn "${DOTFILES_HOME}/.config/k9s/config.yaml" "${HOME}/.config/k9s/config.yaml"
[[ -e ${HOME}/.config/k9s/skins && ! -L ${HOME}/.config/k9s/skins ]] && \
  mv "${HOME}/.config/k9s/skins" "${HOME}/.config/k9s/skins.bak"
ln -sfn "${DOTFILES_HOME}/.config/k9s/skins" "${HOME}/.config/k9s/skins"

#
# 4. Brew packages
#
echo "==> Installing brew formulae"
brew install \
  automake \
  bat \
  cmake \
  coreutils \
  deno \
  expect \
  fnm \
  fzf \
  gh \
  golangci-lint \
  helm \
  htop \
  httpie \
  jq \
  k9s \
  krew \
  kustomize \
  libtool \
  neovim \
  pyenv \
  reattach-to-user-namespace \
  rust \
  rustup \
  starship \
  telnet \
  tldr \
  tmux \
  tree \
  uv \
  wget \
  yq \
  zinit \
  zsh-completions

# Tapped formulae (these clone from GitHub via SSH)
brew install cockroachdb/tap/cockroach kptdev/kpt/kpt

echo "==> Installing brew casks"
brew install --cask \
  alfred \
  font-hack-nerd-font \
  font-jetbrains-mono-nerd-font \
  font-powerline-symbols \
  gcloud-cli \
  iterm2 \
  jetbrains-toolbox

#
# 5. iTerm2 preferences
#
echo "==> Configuring iTerm2 to load prefs from repo"
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${DOTFILES_HOME}/iterm2"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

#
# 6. Neovim plugins (lazy.nvim will bootstrap itself on first run)
#
echo "==> Installing neovim plugins"
nvim --headless "+Lazy! sync" +qa || true

#
# 7. macOS preferences
#
if [[ -x ${DOTFILES_HOME}/.osx ]]; then
  echo "==> Applying macOS preferences (.osx)"
  "${DOTFILES_HOME}/.osx"
fi

#
# 8. Projects directory
#
mkdir -p "${HOME}/projects"

cat <<'EOF'

==> Setup complete.

Manual next steps:
  - Sign in to gcloud:  gcloud auth login
  - Sign in to GitHub CLI:  gh auth login
  - Open a new terminal so zinit can install zsh plugins on first launch.
  - Verify the iTerm2 profile loaded from this repo (Settings → General → Preferences).
EOF
