#!/bin/bash
source utils.sh

# setup nix package manager
sh <(curl -L https://nixos.org/nix/install) --daemon
# source nix(only for first time)
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# package
nix-env -iA \
  nixos.git \
  nixos.ripgrep \
  nixos.tmux \
  nixos.fuse \
  nixos.ack \
  nixos.ccls \
  nixos.mpv \
  nixos.xfce.xfce4-terminal

# setup neovim 
if [[ -d '~/.config/nvim' ]]; then
  cd $HOME/.config/
  git clone https://github.com/rdpopov/nvim.git
  cd -
else 
  cd $HOME/.config/nvim
  # might need rework
  cd -
fi
setup_nvim
update_plug

# setup tmux
setup_tmux

#setup quoty
setup_quoty

# setup rust and cargo

curl https://sh.rustup.rs -sSf | sh
source "$HOME/.bashrc"
rustup +nightly component add rust-analyzer-preview

# setup nim

curl https://nim-lang.org/choosenim/init.sh -sSf | sh
source "$HOME/.bashrc"
nimble install nimlsp

# setup environment
grep -e "source ~/.config/env/dots/env.sh" ~/.bashrc || echo "source ~/.config/env/dots/env.sh" >> ~/.bashrc
