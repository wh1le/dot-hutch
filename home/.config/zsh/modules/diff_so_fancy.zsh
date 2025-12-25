function helper-git-diff() {
  git -c color.diff.meta="normal" \
    -c color.diff.frag="normal" \
    -c color.diff.old="dim" \
    -c color.diff.new="bold" \
    -c color.ui=always \
    diff --include-untracked $1 $2 | diff-so-fancy --no-strip-leading-symbols | $PAGER
}
#
# alias gd='helper-git-diff'
