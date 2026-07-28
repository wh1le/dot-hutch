# Until .argc exists...
# (https://github.com/ggreer/the_silver_searcher/pull/709)
function ag() {
  emulate -L zsh

  command ag --pager="$PAGER" --color-path=34\;3 --color-line-number=35 --color-match=35\;1\;4 "$@"
}
