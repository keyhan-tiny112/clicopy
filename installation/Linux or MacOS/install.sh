#!/usr/bin/env bash

set -e

# Install Git
if ! command -v git >/dev/null; then
    echo "install git..."
    if command -v apt >/dev/null; then
        sudo apt update
        sudo apt install -y git curl build-essential \
            libwebkit2gtk-4.1-dev \
            libgtk-3-dev \
            libayatana-appindicator3-dev \
            librsvg2-dev
    elif command -v pacman >/dev/null; then
        sudo pacman -Sy --noconfirm git curl base-devel webkit2gtk gtk3 libappindicator-gtk3 librsvg
    elif command -v dnf >/dev/null; then
        sudo dnf install -y git curl gcc gcc-c++ webkit2gtk4.1-devel gtk3-devel libappindicator-gtk3 librsvg2-devel
    else
        echo "Unsupported distro"
        exit 1
    fi
    echo "installed!!"
fi

read -p "Install path: " PATH_INSTALL

echo "Clone of repositories..."
git clone https://github.com/erfan114/clicopy.git "$PATH_INSTALL"
echo "ok!"

cd "$PATH_INSTALL"

echo "install rust..."
# Install Rust
if ! command -v cargo >/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    echo "installed!!"
fi

echo "install bun..."
# Install Bun
if ! command -v bun >/dev/null; then
    curl -fsSL https://bun.sh/install | bash
    export PATH="$HOME/.bun/bin:$PATH"
    echo "installed!!"
fi

echo "install dependencies..."
# Install dependencies
bun install

echo "running..."
# Run
bun tauri dev
