#!/usr/bin/env zsh

# Can't assume readlink -f, realpath, etc exist yet.
# DOTFILES="$(dirname $0)"
DOTFILES="$(echo $(cd $(dirname "$0") && pwd -P))"
ZDOTDIR="${ZDOTDIR:-$HOME}"
NVIM="$HOME/.config/nvim"

function ensure_dir() {
    for dirname in "$@" ; do
        [[ -d "$dirname" ]] || mkdir -p "$dirname"
    done
}


# Can't assume install exists yet.
function install_dotfile() { 
    ensure_dir "$(dirname "$2")"
    if [[ -f "$2" ]] ; then
        echo TODO: ln -s "$DOTFILES/$1" "$2"
    else
        ln -s "$DOTFILES/$1" "$2"
    fi
}



git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR}/.zprezto"
install_dotfile init.vim "$NVIM/init.vim"
install_dotfile zshrc "$ZDOTDIR/.zshrc"
install_dotfile zprofilerc "$ZDOTDIR/.zprofilerc"
install_dotfile zpretzorc "$ZDOTDIR/.zpretzorc"


