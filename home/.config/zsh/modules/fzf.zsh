source <(fzf --zsh)

# https://minsw.github.io/fzf-color-picker/

export FZF_DEFAULT_OPTS="
  --style=minimal
  --layout=reverse
  --ansi 
  --margin=1,1,1,1 
  --cycle 
  --height=50%
  --color=fg:2,fg+:4
  --color=hl:3:bold,hl+:3:bold
  --color=bg:-1,bg+:1
  --color=info:3,prompt:1,pointer:5
  --color=marker:2,spinner:5
  --color=header:15
  --color=gutter:-1,border:8,scrollbar:8
  --prompt='> '
  --bind esc:abort 
  --bind ctrl-d:preview-half-page-down 
  --bind ctrl-u:preview-half-page-up 
  --bind ctrl-f:preview-page-down 
  --bind ctrl-b:preview-page-up 
"

export FZF_CTRL_R_OPTS="
  --style=minimal
  --info=inline
  --no-sort
  --exact
  --no-preview
  --height=50%
  --prompt='> '
  --margin=1,1,1,1
  --layout=reverse
  --ansi
"

# export FZF_CTRL_R_OPTS="
#   --style=minimal
#   --info=inline
#   --no-sort
#   --exact
#   --no-preview
#   --color=gutter:-1,border:238,scrollbar:238
#   --height=50%
#   --prompt='> '
#   --margin=1,1,1,1
#   --layout=reverse
#   --ansi
# "

bindkey '^r' fzf-history-widget

function fzf-quick-edit() {
  local dir file

  if git rev-parse --show-toplevel &>/dev/null; then
    dir=$(git rev-parse --show-toplevel)
  else
    dir=.
  fi

  file=$(git ls-files --cached --others --exclude-standard 2>/dev/null | fzf --no-sort --tac --prompt="edit> " --bind=ctrl-z:abort --ansi --height=40% --border=rounded --query="$LBUFFER") || return

  [[ -n $file ]] && "$EDITOR" "$dir/$file"

  zle redisplay
}

quick-edit-directory() {
  if [[ $# -eq 1 ]]; then
    selected=$1
  else
    selected=$(find ${(@s/:/)SEARCH_DIRECTORIES_PATHS} -mindepth 1 -maxdepth 1 -xtype d 2>/dev/null | fzf)
  fi

  if [[ -z $selected ]]; then
    return
  fi

  selected_name=$(basename "$selected" | tr . _)

  cd $selected 
}

quick_edit_directory_widget() {
  zle -I # suspend ZLE so fzf draws cleanly
  quick-edit-directory || return
  zle reset-prompt # refresh prompt after cd
}

zle -N quick_edit_directory_widget
bindkey -M emacs '^O' quick_edit_directory_widget
bindkey -M viins '^O' quick_edit_directory_widget
bindkey -M vicmd '^O' quick_edit_directory_widget
