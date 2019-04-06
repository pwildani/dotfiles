# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' substitute 1
zstyle :compinstall filename '/home/pabw00/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory extendedglob notify
unsetopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install

source ~/.cargo/env
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
prompt sorin git async
