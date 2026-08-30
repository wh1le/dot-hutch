# fzf.zsh - widgets and default fzf options

source "$HOME/.cache/zsh/fzf-init.zsh" 2>/dev/null || eval "$(fzf --zsh)"

# --- options --------------------------------------------------------------

# Color picker: https://minsw.github.io/fzf-color-picker/

local FZF_IGNORE_PATHS=(/mnt/homepc)

export FZF_DEFAULT_OPTS="
  --style=minimal
  --layout=reverse
  --ansi
  --margin=1,1,1,1
  --cycle
  --height=50%
  --color=fg:8,fg+:7
  --color=hl:7,hl+:7
  --color=bg:-1,bg+:0
  --color=info:8,prompt:7,pointer:4
  --color=marker:4,spinner:8
  --color=header:8
  --color=gutter:-1,border:8,scrollbar:8
  --prompt='> '
  --bind esc:abort
  --bind ctrl-d:preview-half-page-down
  --bind ctrl-u:preview-half-page-up
  --bind ctrl-f:preview-page-down
  --bind ctrl-b:preview-page-up
  --no-sort
"

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

function _quick_jump_dirs() {
  local file dir root depth=${1:-3} mount
  for mount in /mnt/*(N); do
    [[ -n ${FZF_IGNORE_PATHS[(r)$mount]} ]] && continue
    file=$mount/.locations
    [[ -f $file ]] || continue
    root=$mount
    while IFS= read -r dir; do
      [[ -n $dir ]] || continue
      [[ $dir == /* ]] || dir=$root/$dir
      dir=${dir//\/.\//\/}
      [[ -d $dir ]] || continue
      print -r -- "$dir"
      ((depth > 0)) && fd -a --type d --max-depth "$depth" -E .git -E .direnv -E __pycache__ . "$dir"
    done <"$file"
  done | sort
}

function _dedupe_by_realpath() {
  local -A seen
  local line key
  while IFS= read -r line; do
    key=${line:A}
    [[ -n ${seen[$key]} ]] && continue
    seen[$key]=1
    print -r -- "$line"
  done
}

function _search_roots() {
  print -r -- ${(@s/:/)SEARCH_DIRECTORIES_PATHS}
}

function _list_project_dirs() {
  find -L $(_search_roots) -mindepth 1 -maxdepth 1 -type d ! -name .git ! -name .direnv
  _quick_jump_dirs 1
}

function _list_dirs() {
  fd -a --type d --max-depth 10 $FZF_EXCLUDES . .
  fd -a --type d --max-depth 4 $FZF_EXCLUDES . $(_search_roots)
  _quick_jump_dirs
}

function _list_files() {
  fd -a --type f --max-depth 10 $FZF_EXCLUDES . .
  fd -a --type f --max-depth 4 $FZF_EXCLUDES . $(_search_roots)
}

function _fzf_pick() {
  _dedupe_by_realpath | fzf --scheme=path "$@"
}

# After cd from a widget: run chpwd/precmd hooks and redraw the prompt
_zle_after_cd() {
  local f
  for f in chpwd "${chpwd_functions[@]}" precmd "${precmd_functions[@]}"; do
    ((${+functions[$f]})) && "$f" &>/dev/null || true
  done
  zle .reset-prompt
  zle -R
}

# Reload history from file before searching so cross-pane commands appear
function fzf_history_widget_synced() {
  fc -RI
  zle fzf-history-widget
}
zle -N fzf_history_widget_synced
bindkey '^r' fzf_history_widget_synced

function quick_edit_directory() {
  if [[ $# -eq 1 ]]; then
    selected=$1
  else
    selected=$({
      find -L ${(@s/:/)SEARCH_DIRECTORIES_PATHS} -mindepth 1 -maxdepth 1 -type d ! -name .git ! -name .direnv
      _quick_jump_dirs 1
    } 2>/dev/null | _dedupe_by_realpath | fzf --sort)
  fi

  if [[ -z $selected ]]; then
    return
  fi

  selected_name=$(basename "$selected" | tr . _)

  cd $selected
}

function quick_edit_directory_widget() {
  zle -I
  quick_edit_directory || return
  local f
  for f in chpwd "${chpwd_functions[@]}" precmd "${precmd_functions[@]}"; do
    [[ "${+functions[$f]}" == 0 ]] || "$f" &>/dev/null || true
  done
  zle .reset-prompt
  zle -R
}

zle -N quick_edit_directory_widget
bindkey -M emacs '^O' quick_edit_directory_widget
bindkey -M viins '^O' quick_edit_directory_widget
bindkey -M vicmd '^O' quick_edit_directory_widget

function fzf-open() {
  local out key file
  out=$({
    fd -a --type f --max-depth 10 -E .git -E .direnv -E __pycache__ . . | sort
    fd -a --type f --max-depth 4 -E .git -E .direnv -E __pycache__ . ${(@s.:.)SEARCH_DIRECTORIES_PATHS:#} | sort
  } 2>/dev/null | _dedupe_by_realpath | fzf --sort --expect=ctrl-o)
  key=$(head -1 <<<"$out")
  file=$(tail -1 <<<"$out")
  [[ -z "$file" ]] && return

  if [[ "$key" == "ctrl-o" || $(file -bL --mime-encoding -- "$file") == binary ]]; then
    xdg-open "$file" &>/dev/null &|
  else
    "${EDITOR:-nvim}" "$file"
  fi
}
bindkey -s ';f' 'fzf-open\n'

function fzf-change-directory() {
  zle -I
  local dir
  dir=$({
    fd -a --type d --max-depth 10 -E .git -E .direnv -E __pycache__ . . | sort
    fd -a --type d --max-depth 4 -E .git -E .direnv -E __pycache__ . ${(@s.:.)SEARCH_DIRECTORIES_PATHS:#} | sort
    _quick_jump_dirs
  } 2>/dev/null | _dedupe_by_realpath | fzf --sort) || {
    zle .reset-prompt
    return
  }
  cd "$dir"
  local f
  for f in chpwd "${chpwd_functions[@]}" precmd "${precmd_functions[@]}"; do
    [[ "${+functions[$f]}" == 0 ]] || "$f" &>/dev/null || true
  done
  zle .reset-prompt
  zle -R
}

zle -N fzf-change-directory
bindkey -M emacs ';d' fzf-change-directory
bindkey -M viins ';d' fzf-change-directory
bindkey -M vicmd ';d' fzf-change-directory

function tmux-sessionizer-widget() {
  zle -I
  BUFFER="tmux-sessionizer"
  zle accept-line
}

zle -N tmux-sessionizer-widget
bindkey '^f' tmux-sessionizer-widget
