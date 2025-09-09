#!/usr/bin/env bash
set -euo pipefail

# --- config ---
GIT_REPO="https://github.com/weberam2/SimpleDotFiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
FILES=(.zshrc .vimrc .tmux.conf .p10k.zsh .config)

# --- functions ---
install_pkg() {
    local pkgs=("$@")
    echo "Installing packages: ${pkgs[*]}"

    if command -v apt-get >/dev/null; then
        if command -v sudo >/dev/null; then
            sudo apt-get update && sudo apt-get install -y "${pkgs[@]}"
        else
            apt-get update && apt-get install -y "${pkgs[@]}"
        fi
    elif command -v dnf >/dev/null; then
        sudo dnf install -y "${pkgs[@]}"
    elif command -v yum >/dev/null; then
        sudo yum install -y "${pkgs[@]}"
    elif command -v pacman >/dev/null; then
        sudo pacman -Sy --noconfirm "${pkgs[@]}"
    elif command -v brew >/dev/null; then
        brew install "${pkgs[@]}"
    else
        echo "⚠️ Could not detect package manager. Please install: ${pkgs[*]}"
    fi
}

ensure_cmd() {
    local cmd="$1"
    local pkg="$2"
    if ! command -v "$cmd" >/dev/null; then
        install_pkg "$pkg"
    fi
}

# --- macOS specific ---
setup_macos() {
    if ! command -v brew >/dev/null; then
        echo "🍺 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)" || true
    fi
    install_pkg coreutils
}

# --- detect OS ---
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍏 macOS detected"
    setup_macos
else
    echo "🐧 Linux detected"
fi

# --- ensure dependencies ---
ensure_cmd git git
ensure_cmd zsh zsh
# ensure_cmd vim vim
### vim alternative
ensure_cmd vim-nox vim-nox

ensure_cmd tmux tmux
ensure_cmd curl curl
ensure_cmd tree tree
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
ensure_cmd ripgrep ripgrep
ensure_cmd fd-find fd-find
ensure_cmd bat bat
ensure_cmd vifm vifm
# install Rust (for macOS and Linux)
curl https://sh.rustup.rs -sSf | sh
. "$HOME/.cargo/env"
cargo install eza

# --- clone repo ---
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "📦 Cloning dotfiles repo into $DOTFILES_DIR..."
    git clone "$GIT_REPO" "$DOTFILES_DIR"
else
    echo "📥 Updating dotfiles repo..."
    git -C "$DOTFILES_DIR" pull --ff-only
fi

# --- symlinks ---
for file in "${FILES[@]}"; do
    src="$DOTFILES_DIR/$file"
    dest="$HOME/$file"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "Backing up existing $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    echo "Linking $src -> $dest"
    ln -sfn "$src" "$dest"
done

# Vim plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# --- set zsh as default ---
if command -v zsh >/dev/null && [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "Changing default shell to zsh..."
    echo "May require user password"
    chsh -s "$(command -v zsh)"
fi

echo "✅ Dotfiles installed and environment ready!"

echo "Note: you will have to type zsh to enter the shell"
echo "And when you first run vim, type: :PlugInstall"
