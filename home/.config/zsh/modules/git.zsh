function helper-git-history() {
  local out shas sha q k
  while out=$(
    git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
      fzf --ansi --multi --no-sort --reverse --query="$q" \
        --print-query --expect=ctrl-d --toggle-sort=\`
  ); do
    q=$(head -1 <<<"$out")
    k=$(head -2 <<<"$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<<"$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
    if [ "$k" = ctrl-d ]; then
      git diff --color $shas | diff-so-fancy | $PAGER
    else
      for sha in $shas; do
        git show --color $sha | diff-so-fancy | $PAGER
      done
    fi
  done
}

function helper-git-diff() {
  git -c color.diff.meta="normal" \
    -c color.diff.frag="normal" \
    -c color.diff.old="dim" \
    -c color.diff.new="bold" \
    -c color.ui=always \
    diff $1 $2 | diff-so-fancy --no-strip-leading-symbols | $PAGER
}

# Git
alias g=git
alias gl="git log --oneline"
alias gs='git status'
alias gc='git checkout'
alias gr='git rebase -i'
alias gh='helper-git-history'

gd() {
  git diff --color=always "$@" | $PAGER -p
}
