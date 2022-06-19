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

if [[ $# == "0" ]]; then 
  echo -e "Usage:";
  echo -e "   --rust,-r\t setup alacritty ";
  echo -e "   --quoty,-q\t setup alacritty ";
  echo -e "   --tmux,-t\t sets up tmux and which requires quoty(optionally)"
  echo -e "   --nix,-n\t sets up quoty"
  echo -e "   --nim,-N\t sets up neovim latest appimage"
  echo -e "   --dev,-d\t sets up dependacies for neovim"
  echo -e "   --env,-e\t sets up dependacies for neovim"
  echo -e "   --all,-A\t sets up all of the above for neovim"
  exit 0;
else
  for arg in "$@";do
    case "$arg" in
      "--quoty" | "-q" )
        setup_quoty
        ;;
      "--tmux" | "-t" )
        setup_tmux
        ;;
      "--rust" | "-r" )
        setup_rust
        ;;
      "--dev" | "-d" )
        setup_dev
        ;;
      "--nim" | "-N" )
        setup_nim
        ;;
      "--nix" | "-n" )
        setup_nix
        ;;
      "--env" | "-e" )
        setup_env
        ;;
      "--all" | "-A" )
        setup_nix
        setup_env
        setup_quoty
        setup_dev
        setup_rust
        setup_nim
        ;;
      *)
        echo -e "Usage:";
        echo -e "   --alac,-a\t Setup alacritty.";
        echo -e "   --tmux,-t\t Sets up tmux and which requires quoty(optionally)."
        echo -e "   --quoty,-q\t Sets up quoty."
        echo -e "   --nvim,-n\t Sets up neovim latest appimage."
        echo -e "   --deps,-d\t Sets up dependacies for neovim."
        echo -e "   --plug,-p\t Gets new version of vim-plug."
        echo -e "   --all,-A\t Sets up all of the above for neovim."
        exit 0
        ;;
    esac
  done
fi

