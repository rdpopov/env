#!/bin/bash
source utils.sh

setup_env(){
  setup_tmux
  setup_quoty
  grep -e "source ~/.config/env/dots/env.sh" ~/.bashrc || echo "source ~/.config/env/dots/env.sh" >> ~/.bashrc
}

nix_setup()
{
  sh <(curl -L https://nixos.org/nix/install) --daemon
  # source nix(only for first time)
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi

  # package
  git_pkg=""

  if [[ -z $(which git) ]]; then
      git_pkg="nixpkgs.git"
  fi

  nix-env -iA \
    $git_pkg \
    nixpkgs.ripgrep \
    nixpkgs.tmux \
    nixpkgs.fuse \
    nixpkgs.ack \
    nixpkgs.ccls \
    nixpkgs.mpv
}

setup_devel(){
  # setup neovim 
  if [[ -d '~/.config/nvim' ]]; then
    git clone https://github.com/rdpopov/nvim.git $HOME/.config/nvim
  fi
  setup_nvim
}

setup_nim(){
  curl https://nim-lang.org/choosenim/init.sh -sSf | sh
  source "$HOME/.bashrc"
  nimble install nimlsp
}

setup_rust(){
  curl https://sh.rustup.rs -sSf | sh
  source "$HOME/.bashrc"
  rustup +nightly component add rust-analyzer-preview
}
