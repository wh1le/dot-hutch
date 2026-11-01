# Shared picker settings and project discovery; no interactive shell setup.
export FZF_DEFAULT_OPTS="
  --style=minimal
  --layout=reverse
  --ansi
  --margin=1,1,1,1
  --cycle
  --tiebreak=length
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
  --bind 'start,change:transform-search:q=\$FZF_QUERY; case \$q in \"~/\"*) q=\$HOME/\${q#??} ;; esac; printf \"%s\" \"\$q\"'
  --no-sort
"

function fzf_path_pick() {
  fzf --scheme=path --sort "$@"
}

function _quick_jump_dirs() {
  local file dir root depth=${1:-3} mount
  for mount in /mnt/*(N); do
    [[ $mount == /mnt/homepc ]] && continue
    file=$mount/.locations
    [[ -f $file ]] || continue
    root=$mount
    while IFS= read -r dir; do
      [[ -n $dir ]] || continue
      [[ $dir == /* ]] || dir=$root/$dir
      dir=${dir//\/.\//\/}
      [[ -d $dir ]] || continue
      print -r -- "$dir"
      ((depth > 0)) && fd -HL -a --type d --max-depth "$depth" -E .git -E .direnv -E __pycache__ . "$dir"
    done <"$file"
  done | sort
}

function _dedupe_by_realpath() {
  local -A seen
  local line key
  while IFS= read -r line; do
    [[ -n $line ]] || continue
    key=${line:A}
    [[ -n ${seen[$key]-} ]] && continue
    seen[$key]=1
    print -r -- "$key"
  done
}

function _list_project_dirs() {
  local -a roots=("${(@s/:/)SEARCH_DIRECTORIES_PATHS}")
  roots=("${(@)roots:#}")
  {
    ((${#roots})) && find -L "${roots[@]}" -mindepth 1 -maxdepth 1 -type d ! -name .git ! -name .direnv
    _quick_jump_dirs 1
  } | _dedupe_by_realpath
}

function _fzf_pick() {
  _dedupe_by_realpath | fzf_path_pick "$@"
}
