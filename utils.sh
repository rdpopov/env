setup_nvim(){
  cd '~/.config/nvim'; bash setup.sh --nvim
}

update_plug(){
  if command -v curl; then
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  else
    if command -v wget; then
      wget --quiet https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim --output-document ~/.config/nvim/autoload/plug.vim
    else
      echo "> neither wget or curl exist."
      echo "what do?"
      exit -1
    fi
  fi
}

setup_tmux(){
    [ -e "$HOME/.tmux.conf" ] && mv $HOME/.tmux.conf $HOME/.tmux.conf.bak
    cp ./dots/tmux/.tmux.conf $HOME/.tmux.conf
    [ -d "$HOME/.tmux/plugins/tpm" ] || git clone https://www.github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm #tmux package manager
    [[ $(grep ~/.bashrc -e env\.sh -c) == "0" ]] && echo "source ~/.config/env/dots/env.sh" >> ~/.bashrc || echo "already in .bashrc"
}

setup_quoty(){
    [ -d "$HOME/.config/quoty" ] && cd $HOME/.config/quoty/; git stash; git pull || cd $HOME/.config/;git clone https://www.github.com/rdpopov/quoty
}
