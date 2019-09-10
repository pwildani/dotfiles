# The following lines were added by compinstall
#set -x

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' substitute 1
zstyle :compinstall filename "$HOME/.zshrc"

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

autoload -Uz compinit
compinit
# End of lines added by compinstall


bindkey -e
export HISTFILE="$HOME/.zsh_history_$ZSH_VERSION"
setopt appendhistory extendedglob notify
setopt hist_expire_dups_first
setopt hist_reduce_blanks
setopt hist_find_no_dups
setopt hist_save_no_dups
setopt hist_verify
unsetopt autocd
#setopt ksharrays # 0-based, require ${} to do indexing.
setopt auto_list auto_menu no_list_beep no_hist_beep no_beep
setopt append_history
setopt hist_nostore
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_verify
setopt inc_append_history
setopt hist_find_no_dups
setopt no_bgnice
setopt complete_in_word
setopt always_last_prompt
setopt extended_glob
setopt nobadpattern
setopt prompt_subst
setopt chase_links
setopt no_equals no_magic_equal_subst

# Manually manage a history file too: shell log
SHELL_LOG=$HOME/.shell.log

if [ "$USER" != "root" ]; then
  preexec_functions+=('_save_global_history')
  function _save_global_history() {
    # <as-typed> <alias-expanded, abbreviated> <alias-expanded, full>
    local cmd entry
    cmd="$1"
    if [[ -z "$cmd" ]] ; then
      # shell history is off.
      cmd="$3"
    fi

    # cmd can have newlines in it, represent them as literal \n's
    # (like ${cmd//\n/\\n}, but actually handles the \n's (the (p) flag on s))
    cmd="${(j:\n:)${(ps:\n:)cmd}}"

   # TODO: figure out ways to do this without the tail processeses

   entry="$(tail -1 $SHELL_LOG)"
   entry="${entry#*:}"
   if [[ "$entry" != "$PWD:$cmd" ]]; then
     # use print -r so \'s in $cmd don't get destroyed
     print -r "$(print -P '%D{%Y-%m-%d %H-%M-%S}'):$PWD:$cmd" >> $SHELL_LOG
   fi
  }
fi


function hist_load_search () {
   (if [[ -s ~/.shelldiff.log ]]; then tail -100 ~/.shelldiff.log; fi;
    tail -1000 $SHELL_LOG | cut -d: -f3- | uniq | sed 's/\\n/\\\n/g;'
   ) | fc -R
}
hist_load_search

autoload zmv
autoload zcalc
autoload zed

IN_XTERM=
if [[ "${TERM/%xterm*/xterm}" == xterm || ( -n "$DISPLAY" && -n "$WINDOWID" )]] ; then
  IN_XTERM=1
fi

if [[ ! -z "$ITERM_SESSION_ID" ]] ; then
  IN_ITERM=1
fi

if [[ $IN_ITERM == 1  || $IN_XTERM == 1 ]] ; then
  # tput tsl
  START_XTITLE="$(print "\033]2;")"
  # tput fsl
  END_XTITLE="$(print "\007")"
fi

# lookup table key
# table is file like: KEY <whitespace> VALUE <newline>
# prints matching line from file.
lookup ()
{
        awk "\$1 == \"$2\" { print \$0 ; FND=1}
	     END{ if(FND) {exit 0}
	          else    {exit 1} }" $1
}
# Like lookup, but key is awk regex.
rlookup ()
{
        awk "\$1 ~ /$2/ { print \$0 ; FND=1}
	     END{ if(FND) {exit 0}
	          else    {exit 1} }" $1
}


function cdup () {
  setopt local_options ksh_arrays
  local IFS
  local -a splitpath
  IFS=$'\0' splitpath=($(updir "$1" $'\0'))
  if [[ $? == 0 ]] ; then
    cd "${splitpath[0]}"
    echo "${splitpath[0]}" "${splitpath[1]}"
  else
    return 1
  fi
}

# $(updir "$1" "$2") is basically
# "${PWD%%/$1}/$1$2${PWD##*/$1/}", but it handles edge cases
# better.
function updir() {
  local suffix target sep dir
  target="$1"
  sep="${2:-$(print \\0)}"
  dir="$PWD"
  case "$dir" in
    */"$target"/* )
      prefix="${dir%%/$target/*}/$target"
      suffix="${dir##$prefix/}"
      print -rN "$prefix$sep$suffix"
      return 0
      ;;
    */"$target" )
      print -rN "$dir$sep"
      return 0
      ;;
  esac
  echo "$0: No match for $target" 1>&2
  return 1
}



function pcdup() {
  pushd .
  cdup "$@"
}


# Frequency based directory record
#source ~/lib/zsh/z-zsh/z.sh
source ~/lib/y.sh
preexec_functions+=('preexec_record_z')
function preexec_record_z() {
  # Ignore boring commands
  case "$1" in
    # Ignore changing directories
    ( cd\ * | z\ * | y\ *) return ;;
    (cdup\ *) return ;;
    ( cdoz | cdlocal | cdg3 | cdg3\ *) return ;;
    ( cdjt | cdjt\ * | cdj | cdj\ *) return ;;
    # Note: not ignoring pushd, that's a sign that I care about
    # this directory.
    ( popd\ * ) return ;;

    # Ignore ls. I run it habitually, just to figure out what
    # directory I'm looking at.
    ( ls | ls\ * ) return ;;
    (pwd) return ;;
  esac
  case ${options[chaselinks]} in
    on)
       # PWD does not usually contain symlinks when CHASE_LINKS is set
#       z --add "${PWD}" ;
       y --add "${PWD}" ;;
    off)
       # Record the symlink-free version of the path
#       z --add "$(pwd -P)" ;
       y --add "$(pwd -P)" ;;
  esac
}


# Record the current git branch as a directory feature.
_z_feature_git_current_branch() {
  (cd "$Z_DIR"; git rev-parse --is-inside-work-tree) 1>/dev/null 2>&1 || return
  local branch="$(cd "$Z_DIR"; git symbolic-ref HEAD 2>/dev/null)"
  branch="${branch##refs/[^/]##/}"
  reply="$branch"
}
zstyle -e ':y:feature' git-current-branch _z_feature_git_current_branch


_z_feature_git_all_branch() {
  (cd "$Z_DIR"; git rev-parse --is-inside-work-tree) 1>/dev/null 2>&1 || return
  reply="$(git rev-parse --symbolic --branches)"
}
zstyle -e ':y:feature' git-has-branch _z_feature_git_all_branch

# Record the current git5 changelist as a directory feature.
_z_feature_git5_changelist() {
  (cd "$Z_DIR"; git rev-parse --is-inside-work-tree 1>/dev/null 2>&1) || return
  local cl="$(cd "$Z_DIR"; git5 info review_cl 2>/dev/null)"
  [[ ! -z "$cl" ]] && reply="$cl"
}
zstyle -e ':y:feature' git5-cl _z_feature_git5_changelist

zstyle ':y:ignore' "$HOME" yes

zstyle ':y:ignore:/google/src/cloud/*' ignore no
zstyle ':y:ignore:/google/*' ignore yes

y --clean &!


source ~/.cargo/env

if [[ -e '/home/linuxbrew/.linuxbrew/bin/brew' ]] ; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi


# Just in case some plugin sets this. It's never what I want.
unsetopt share_history
