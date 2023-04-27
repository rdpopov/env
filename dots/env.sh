#!/usr/bin/bash
# this is an environment lile that has some importatnt things that are used in
# tmux status script

fay() {
  yay -Slq | fzf -m --preview 'yay -Si {1}' | xargs -ro yay -S
}

facman() {
  pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -ro pacman -S
}

faru() {
  paru -Slq | fzf -m --preview 'paru -Si {1}' | xargs -ro paru -S
}

fapt() {
  apt-cache search '' | sort | cut --delimiter ' ' --fields 1 | fzf --multi --cycle --reverse --preview 'apt-cache show {1}' | xargs -r sudo apt install -y
}

fzf_install(){
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
  [ -f $HOME/.fzf.bash ] && source ~/.fzf.bash
}

# nix package manager setup
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi


export HAS_BATTERY=$(upower -d 2>/dev/null |grep BAT -c)
# source QUOTY
[[ -e ~/.config/quoty/ ]] && source $HOME/.config/quoty/quoty.sh  || echo "No quotes today sir"

[[ -f ~/.fzf.bash ]] || fzf_install
[[ -f ~/.fzf.bash ]] && source $HOME/.fzf.bash
[[ -d "$HOME/.cargo/" ]] && source $HOME/.cargo/env || echo "No cargo/rust"

export TMUX_VER=$(tmux -V|cut -f2 -d" ") # need this to automatically pick clors for editor
export PATH="$HOME/.nimble/bin:$PATH"
export PATH="$HOME/.local/lib/python3.10/site-packages/:$PATH"
export PATH="$HOME/bin/:$PATH"
export BATTERIES=$(upower -e|grep BAT)

alias recharge='tlp fullcharge'
alias workstart='$HOME/.config/env/dots/tmux/timer.sh -s'
alias workfinish='$HOME/.config/env/dots/tmux/timer.sh -f'
alias workpause='$HOME/.config/env/dots/tmux/timer.sh -p'
alias v='nvim'

[[ -z $(command -v fzf) ]] && fzf_install # auto install fzf if fzf does not exist

[[ -x "$(command -v apt)" ]] && alias pac="fapt"
[[ -x "$(command -v pacman)" ]] && alias pac="facman"
[[ -x "$(command -v yay)" ]] && alias pac="fay"

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

set keymap vi-command "diw": "bde"
set keymap vi-command "ciw": "bdei"
set keymap vi-command "dw": "de"
set keymap vi-command "cw": "dei"
set -o vi

bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string \1\e[34;1m\2(I)\1\e[0m\2'
bind 'set vi-cmd-mode-string \1\e[33;1m\2(C)\1\e[0m\2'
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

PS1='[\[\033[01;32m\]\u \[\033[01;31m\]@\H \[\033[01;34m\]\W\[\033[00m\]]\[\e[93m\]$(parse_git_branch)\[\e[00m\] \$ '
