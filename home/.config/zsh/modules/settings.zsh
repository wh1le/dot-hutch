# CD
setopt AUTO_PUSHD        # [default] cd automatically pushes old dir onto dir stack
setopt PUSHD_IGNORE_DUPS # don't push multiple copies of same dir onto stack
setopt PUSHD_SILENT      # [default] don't print dir stack after pushing/popping

# shell
setopt CLOBBER              # allow clobbering with >, no need to use >!
setopt IGNORE_EOF           # [default] prevent accidental C-d from exiting shell
setopt INTERACTIVE_COMMENTS # [default] allow comments, even in interactive shells
setopt NO_NOMATCH           # [default] unmatched patterns are left unchanged
setopt PRINT_EXIT_VALUE     # [default] for non-zero exit status
