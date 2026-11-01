# fzf.zsh - widgets and default fzf options

source "$HOME/.cache/zsh/fzf-init.zsh" 2>/dev/null || eval "$(fzf --zsh)"

source "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/common.zsh"

# History: chronological order
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

# --- helpers --------------------------------------------------------------

function _wh1le_list_dirs() {
  fd -LH --type d --max-depth 10 --strip-cwd-prefix $FZF_EXCLUDES
}

function _wh1le_list_files() {
  fd -LH --type f --max-depth 10 --strip-cwd-prefix $FZF_EXCLUDES
}

# After cd from a widget: run chpwd/precmd hooks and redraw the prompt
function _zle_after_cd() {
  local f
  for f in chpwd "${chpwd_functions[@]}" precmd "${precmd_functions[@]}"; do
    ((${+functions[$f]})) && "$f" &>/dev/null || true
  done
  zle .reset-prompt
  zle -R
}

# --- widgets --------------------------------------------------------------

# Reload history from file before searching so cross-pane commands appear
function fzf_history_widget_synced() {
  fc -RI
  zle fzf-history-widget
}
zle -N fzf_history_widget_synced
bindkey '^r' fzf_history_widget_synced

function open_directories_from_cwd() {
  local from_zle=0 selected
  [[ -n $WIDGET ]] && from_zle=1
  ((from_zle)) && zle -I

  if [[ $# -eq 1 ]]; then
    selected=$1
  else
    selected=$(_list_project_dirs 2>/dev/null | _fzf_pick) || {
      ((from_zle)) && zle .reset-prompt
      return 1
    }
  fi
  [[ -z $selected ]] && return 1

  cd -- "$selected" || return 1
  ((from_zle)) && _zle_after_cd
}

zle -N open_directories_from_cwd
bindkey -M emacs '^O' open_directories_from_cwd
bindkey -M viins '^O' open_directories_from_cwd
bindkey -M vicmd '^O' open_directories_from_cwd

function fzf_open_file() {
  local out key file
  out=$(_wh1le_list_files 2>/dev/null | _fzf_pick --expect=ctrl-o) || return
  key=$(print -r -- "$out" | head -1)
  file=$(print -r -- "$out" | tail -1)
  [[ -z $file ]] && return

  if [[ $key == ctrl-o || $(file -bL --mime-encoding -- "$file") == binary ]]; then
    xdg-open "$file" &>/dev/null &|
  else
    "${EDITOR:-nvim}" "$file"
  fi
}
bindkey -s ';f' 'fzf_open_file\n'

function fzf_change_directory_from_cwd() {
  zle -I
  local dir
  dir=$(_wh1le_list_dirs 2>/dev/null | _fzf_pick) || {
    zle .reset-prompt
    return
  }
  cd -- "$dir"
  _zle_after_cd
}
zle -N fzf_change_directory_from_cwd
bindkey -M emacs ';d' fzf_change_directory_from_cwd
bindkey -M viins ';d' fzf_change_directory_from_cwd
bindkey -M vicmd ';d' fzf_change_directory_from_cwd

function tmux_sessionizer_widget() {
  zle -I
  BUFFER="tmux-sessionizer"
  zle accept-line
}
zle -N tmux_sessionizer_widget
bindkey '^f' tmux_sessionizer_widget
