export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

setopt HIST_FIND_NO_DUPS       # don't show dupes when searching
setopt NO_HIST_IGNORE_SPACE    # record commands even if they start with a space
setopt HIST_VERIFY             # confirm history expansion (!$, !!, !foo)
setopt NO_HIST_IGNORE_ALL_DUPS # don't filter duplicates from history
setopt NO_HIST_IGNORE_DUPS     # don't filter contiguous duplicates from history
setopt SHARE_HISTORY           # share history across shells
setopt EXTENDED_HISTORY        # required for SHARE_HISTORY to merge correctly

function history() {
  emulate -L zsh

  # This is a function because Zsh aliases can't take arguments.
  fc -l 1
}

function incognito() {
  fc -p /dev/null 0 0
  setopt NO_INC_APPEND_HISTORY NO_SHARE_HISTORY
  echo "history: off"
}

# fh - "find [in] history"
function search-history() {
  print -z $(fc -l 1 | fzf +s --tac | sed 's/ *[0-9]* *//')
}
