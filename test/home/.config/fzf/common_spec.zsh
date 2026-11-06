#!/usr/bin/env zsh
# Run: zsh -f test/home/.config/fzf/common_spec.zsh
set -eu
source "${0:A:h:h:h:h:h}/home/.config/fzf/common.zsh"

tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
mkdir -p "$tmp/projects with spaces/dot-hutch" "$tmp/projects with spaces/dot-hutch-before-public-release" "$tmp/projects with spaces/.git"
ln -s "$tmp/projects with spaces/dot-hutch" "$tmp/alias"
export SEARCH_DIRECTORIES_PATHS="$tmp/projects with spaces:"
# Keep mount discovery deterministic and include a duplicate via a symlink.
function _quick_jump_dirs() { print -r -- "$tmp/alias"; }

dirs=$(_list_project_dirs)
[[ ${#${(f)dirs}} == 2 ]]
[[ $dirs != *'/.git'* && $dirs != *'/alias'* ]]
[[ $(print -r -- "$dirs" | _fzf_pick --filter=dot-hut | head -1) == "$tmp/projects with spaces/dot-hutch" ]]

# Exercise the actual search-transform command, not a copy of its logic.
transform=''
for option in ${(z)FZF_DEFAULT_OPTS}; do
  option=${(Q)option}
  if [[ $option == start,change:transform-search:* ]]; then
    transform=${option#start,change:transform-search:}
    break
  fi
done
[[ -n $transform ]]
for query expected in '~/Code/dot-hutch' "$HOME/Code/dot-hutch" 'dot-hutch' 'dot-hutch' '~/Code/my project' "$HOME/Code/my project"; do
  export FZF_QUERY=$query
  [[ $(eval "$transform") == "$expected" ]]
done
print 'Shared fzf checks passed'
