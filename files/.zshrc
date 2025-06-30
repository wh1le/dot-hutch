# ## Performance
if [ "$BENCHMARK" = true ]; then
  zmodload zsh/zprof
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

typeset -A __NIKITA

autoload -U colors
colors

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'

## Configuration based on 
## https://github.com/wincent/wincent/tree/master/roles/dotfiles/files/.zsh

##
## Promt
##

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' disable-patterns "${(b)HOME}/code/portal(|-ee)(|/*)"
zstyle ':vcs_info:*' stagedstr "%F{green}●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats '[%b%m%c%u] ' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u] ' # default ' (%s)-[%b|%a]%c%u-'
zstyle ':vcs_info:hg*:*' formats '[%m%b] '
zstyle ':vcs_info:hg*:*' actionformats '[%b|%a%m] '
zstyle ':vcs_info:hg*:*' branchformat '%b'
zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*:*' get-revision true
zstyle ':vcs_info:hg*:*' get-mq false
zstyle ':vcs_info:hg*+gen-hg-bookmark-string:*' hooks hg-bookmarks
zstyle ':vcs_info:hg*+set-message:*' hooks hg-message

function +vi-hg-bookmarks() {
  emulate -L zsh
  if [[ -n "${hook_com[hg-active-bookmark]}" ]]; then
    hook_com[hg-bookmark-string]="${(Mj:,:)@}"
    ret=1
  fi
}

function +vi-hg-message() {
  emulate -L zsh

  # Suppress hg branch display if we can display a bookmark instead.
  if [[ -n "${hook_com[misc]}" ]]; then
    hook_com[branch]=''
  fi
  return 0
}

function +vi-git-untracked() {
  emulate -L zsh
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{red} ● %f"
  fi
}

RPROMPT_BASE="\${vcs_info_msg_0_}%F{blue}"
setopt PROMPT_SUBST

# Anonymous function to avoid leaking variables.
function () {
  # Check for tmux by looking at $TERM, because $TMUX won't be propagated to any
  # nested sudo shells but $TERM will.
  # local TMUXING=$([[ "$TERM" =~ "tmux" ]] && echo tmux)
  if [ -n "$TMUX" ]; then
    # In a a tmux session created in a non-root or root shell.
    local LVL=$(($SHLVL - 1))
  else
    # Either in a root shell created inside a non-root tmux session,
    # or not in a tmux session.
    local LVL=$SHLVL
  fi
  if [[ $EUID -eq 0 ]]; then
    local SUFFIX='%F{yellow}%n%f'$(printf '%%F{yellow}\u276f%.0s%%f' {1..$LVL})
  else
    local SUFFIX=$(printf '%%F{yellow}\u276f%.0s%%f' {1..$LVL})
  fi
  export PS1="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}%b%F{blue}%B%1~%b%F{yellow}%B%(1j.*.)%(?..!)%b%f %B${SUFFIX}%b "
  if [[ -n "$TMUXING" ]]; then
    # Outside tmux, ZLE_RPROMPT_INDENT ends up eating the space after PS1, and
    # prompt still gets corrupted even if we add an extra space to compensate.
    export ZLE_RPROMPT_INDENT=0
  fi
}

export RPROMPT=$RPROMPT_BASE
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

#
# History
#

export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

#
# Options
#

setopt AUTO_CD                 # [default] .. is shortcut for cd .. (etc)
setopt AUTO_PARAM_SLASH        # tab completing directory appends a slash
setopt AUTO_PUSHD              # [default] cd automatically pushes old dir onto dir stack
setopt AUTO_RESUME             # allow simple commands to resume backgrounded jobs
setopt CLOBBER                 # allow clobbering with >, no need to use >!
# setopt CORRECT                 # [default] command auto-correction
# setopt CORRECT_ALL             # [default] argument auto-correction
setopt NO_FLOW_CONTROL         # disable start (C-s) and stop (C-q) characters
setopt NO_HIST_IGNORE_ALL_DUPS # don't filter duplicates from history
setopt NO_HIST_IGNORE_DUPS     # don't filter contiguous duplicates from history
setopt HIST_FIND_NO_DUPS       # don't show dupes when searching
setopt HIST_IGNORE_SPACE       # [default] don't record commands starting with a space
setopt HIST_VERIFY             # confirm history expansion (!$, !!, !foo)
setopt IGNORE_EOF              # [default] prevent accidental C-d from exiting shell
setopt INTERACTIVE_COMMENTS    # [default] allow comments, even in interactive shells
setopt LIST_PACKED             # make completion lists more densely packed
setopt MENU_COMPLETE           # auto-insert first possible ambiguous completion
setopt NO_NOMATCH              # [default] unmatched patterns are left unchanged
setopt PRINT_EXIT_VALUE        # [default] for non-zero exit status
setopt PUSHD_IGNORE_DUPS       # don't push multiple copies of same dir onto stack
setopt PUSHD_SILENT            # [default] don't print dir stack after pushing/popping
setopt SHARE_HISTORY           # share history across shells

#
# Bindings
#


# Use "cbt" capability ("back_tab", as per `man terminfo`), if we have it:
if tput cbt &> /dev/null; then
  bindkey "$(tput cbt)" reverse-menu-complete # make Shift-tab go to previous completion
fi

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "\e[A" history-beginning-search-backward-end  # cursor up
bindkey "\e[B" history-beginning-search-forward-end   # cursor down

autoload -U select-word-style
select-word-style bash # only alphanumeric chars are considered WORDCHARS

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line

bindkey ' ' magic-space # do history expansion on space

# Replace standard history-incremental-search-{backward,forward} bindings.
# These are the same but permit patterns (eg. a*b) to be used.
bindkey "^r" history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward

# Make CTRL-Z background things and unbackground them.
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg

source $HOME/.zsh/colors
source $HOME/.zsh/aliases
source $HOME/.zsh/path
source $HOME/.zsh/exports
source $HOME/.zsh/common
source $HOME/.zsh/functions

#
## Hooks
#
autoload -U add-zsh-hook

function -set-tab-and-window-title() {
  emulate -L zsh
  local CMD="${1:gs/$/\\$}"
  print -Pn "\e]0;$CMD:q\a"
}

# Remember each command we run.
function -record-command() {
  __NIKITA[LAST_COMMAND]="$2"
}
add-zsh-hook preexec -record-command

function -update-window-title-precmd() {
  emulate -L zsh
  if [[ HISTCMD_LOCAL -eq 0 ]]; then
    # About to display prompt for the first time; nothing interesting to show in
    # the history. Show $PWD.
    -set-tab-and-window-title "$(basename $PWD)"
  else
    local LAST=$(history | tail -1 | awk '{print $2}')
    if [ -n "$TMUX" ]; then
      # Inside tmux, just show the last command: tmux will prefix it with the
      # session name (for context).
      -set-tab-and-window-title "$LAST"
    else
      # Outside tmux, show $PWD (for context) followed by the last command.
      -set-tab-and-window-title "$(basename $PWD) > $LAST"
    fi
  fi
}
add-zsh-hook precmd -update-window-title-precmd

# Executed before executing a command: $2 is one-line (truncated) version of
# the command.
function -update-window-title-preexec() {
  emulate -L zsh
  setopt EXTENDED_GLOB
  HISTCMD_LOCAL=$((++HISTCMD_LOCAL))

  # Skip ENV=settings, sudo, ssh; show first distinctive word of command;
  # mostly stolen from:
  #   https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/termsupport.zsh
  local TRIMMED="${2[(wr)^(*=*|mosh|ssh|sudo)]}"
  if [ -n "$TMUX" ]; then
    # Inside tmux, show the running command: tmux will prefix it with the
    # session name (for context).
    -set-tab-and-window-title "$TRIMMED"
  else
    # Outside tmux, show $PWD (for context) followed by the running command.
    -set-tab-and-window-title "$(basename $PWD) > $TRIMMED"
  fi
}
add-zsh-hook preexec -update-window-title-preexec

function -auto-ls-after-cd() {
  emulate -L zsh
  # Only in response to a user-initiated `cd`, not indirectly (eg. via another
  # function).
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
    # pwd
    # tree -L 1
    #
    echo -e "\n📂 $(pwd)\n" && gls --color=always | sed "s/^/  /" && echo
  fi
}
add-zsh-hook chpwd -auto-ls-after-cd

function -maybe-show-vcs-info() {
  local LAST="$__NIKITA[LAST_COMMAND]"

  # In case user just hit enter, overwrite LAST_COMMAND, because preexec
  # won't run and it will otherwise linger.
  __NIKITA[LAST_COMMAND]="<unset>"

  # Check first word; via:
  # http://tim.vanwerkhoven.org/post/2012/10/28/ZSH/Bash-string-manipulation
  case "$LAST[(w)1]" in
    (cd|cp|git|rm|touch|mv|)
      vcs_info
      ;;
    *)
      ;;
  esac
}

add-zsh-hook precmd -maybe-show-vcs-info

alias song="yt-dlp -x --audio-format mp3 --embed-thumbnail"
alias video="yt-dlp"



if which rbenv > /dev/null; then 
  eval "$(rbenv init -)"; 
fi

if [ "$BENCHMARK" = true ]; then
  zprof
fi

export TERM="xterm-256color"

# export NVM_DIR="$HOME/.nvm"
#   [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#   [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
#
# nvm use 18.17

# S=${1:-10}

# while true
# do
#     pbcopy < /dev/null
#     sleep $S
# done

# /usr/local/bin/clear_buffer 120 &
#
alias chatgpt="/Users/nikitamiloserdov/code/bin/chatgpt.sh"


export CLICOLOR=1
# export LSCOLORS=gxfxcxdxbxegedabagacad
eval "$(gdircolors -b ~/.dir_colors)"
# alias ls='echo -e "\n📂 $(pwd)\n" && gls --color=always | sed "s/^/  /" && echo'
ls() {
  echo -e "\n📂 $(pwd)\n"
  gls --color=always "$@" | sed 's/^/  /'
  echo
}

# pytest_wrapper() {
#   PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 \
#   PY_COLORS=0 \
#   pytest --color=no "$@"
# }
# alias pytest='pytest'
#
# pytest() {
#   PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 \
#   PY_COLORS=0 \
#   PYGMENTS_NO_COLOR=1 \
#   NO_COLOR=1 \
#   FORCE_COLOR=0 \
#   command pytest --color=no "$@"
# }

# export PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
# export PY_COLORS=0
# export PYGMENTS_NO_COLOR=1
# export NO_COLOR=1
export FORCE_COLOR=0

nocolor() {
  NO_COLOR=1 \
  PY_COLORS=0 \
  PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 \
  PYGMENTS_NO_COLOR=1 \
  RICH_NO_COLOR=1 \
  FORCE_COLOR=0 \
  TERM=dumb \
  command "$@"
}
alias pytest='nocolor pytest'

alias yt="/Users/nikitamiloserdov/code/assistant/youtube/bin/transcript.sh"
alias yd="/Users/nikitamiloserdov/code/assistant/youtube/bin/download.sh"
alias ymd="/Users/nikitamiloserdov/code/assistant/youtube/bin/music.sh"

[ -f "$HOME/.zsh_secrets" ] && source "$HOME/.zsh_secrets"

# Enable VIM mode
bindkey -v
export PATH="$PATH:/Users/nikitamiloserdov/code/bin/android"
export PATH="$PATH:/Users/nikitamiloserdov/code/bin/scrcpy"

# Show -- NORMAL -- or -- INSERT -- in prompt
function zle-keymap-select {
  case $KEYMAP in
    vicmd) RPROMPT="-- NORMAL --" ;;
    main|viins) RPROMPT="-- INSERT --" ;;
  esac
  zle reset-prompt
}
zle-line-init() { zle vi-insert }
zle -N zle-line-init

function edit_obsidian() {
  cd ~/code/obsidian_vaults/self_architect
  nvim
}

function mancopy() {
  if [[ -z "$1" ]]; then
    echo "Usage: mancopy <command>"
    return 1
  fi

  man "$1" | col -bx | pbcopy
  echo "Copied man page for '$1' to clipboard ✅"
}

# Python
# source ~/venvs/algos/bin/activate

eval "$(pyenv virtualenv-init -)"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
pyenv global 🐍local
