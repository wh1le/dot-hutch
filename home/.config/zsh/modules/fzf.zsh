source <(fzf --zsh)

export FZF_DEFAULT_OPTS=$'--style=minimal --layout=reverse --height=30% --no-preview --color=fg:black,bg:#ededed,fg+:black,bg+:#ffffff,hl:#005fcc,hl+:#005fcc,info:black,prompt:black,spinner:black,pointer:black,marker:black,header:black'
export FZF_CTRL_R_OPTS=$'--style=minimal --info=inline --no-sort --exact --no-preview --color=fg:black,bg:#ededed,fg+:black,bg+:#ffffff,hl:#005fcc,hl+:#005fcc,info:black,prompt:black,spinner:black,pointer:black,marker:black,header:black'

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
    selected=$(find ~/obsidian ~/projects ~/.config ~/dot -mindepth 1 -maxdepth 1 -xtype d | fzf)
  fi

  if [[ -z $selected ]]; then
    exit 0
  fi

  selected_name=$(basename "$selected" | tr . _)

  cd $selected && nvim .
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
