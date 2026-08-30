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

function _strip_cwd_prefix() {
	local line
	while IFS= read -r line; do
		if [[ $line == "$PWD" ]]; then
			print -r -- .
		elif [[ $line == "$PWD"/* ]]; then
			print -r -- "${line#"$PWD"/}"
		else
			print -r -- "$line"
		fi
	done
}

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
			((depth > 0)) && fd -L -a --type d --max-depth "$depth" -E .git -E .direnv -E __pycache__ . "$dir"
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
	{
		find -L $(_search_roots) -mindepth 1 -maxdepth 1 -type d ! -name .git ! -name .direnv
		_quick_jump_dirs 1
	} | _strip_cwd_prefix
}

function _wh1le_list_dirs() {
	fd -L --type d --max-depth 10 --strip-cwd-prefix $FZF_EXCLUDES
}

# two walks: [current dir, shadow walk all roots]
function _wh1le_list_files() {
	fd -L --type f --max-depth 10 --strip-cwd-prefix $FZF_EXCLUDES
	# Diabled for now, see how it goes
	# fd -a --type f --max-depth 4 $FZF_EXCLUDES . $(_search_roots)
}

function _fzf_pick() {
	_dedupe_by_realpath | fzf --scheme=path --sort "$@"
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
