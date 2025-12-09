# fd - "find directory"
# From: https://github.com/junegunn/fzf/wiki/examples#changing-directory
function fd() {
  local DIR
  DIR=$(bfs ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$DIR"
}

# From: https://github.com/junegunn/fzf/wiki/examples#command-history
function mvim() {
  emulate -L zsh

  # Makes user-installed fonts visible to MacVim.
  if which reattach-to-user-namespace &> /dev/null ; then
    reattach-to-user-namespace mvim
  else
    command mvim
  fi
}

# function ssh() {
#   emulate -L zsh
#
#   if [[ -z "$@" ]]; then
#     # common case: getting to my workstation
#     command ssh dev
#   else
#     local LOCAL_TERM=$(echo -n "$TERM" | sed -e s/tmux/screen/)
#     env TERM=$LOCAL_TERM command ssh "$@"
#   fi
# }
#
# regmv = regex + mv (mv with regex parameter specification)
#   example: regmv '/\.tif$/.tiff/' *
#   replaces .tif with .tiff for all files in current dir
#   must quote the regex otherwise "\." becomes "."
# limitations: ? doesn't seem to work in the regex, nor *
regmv() {
  emulate -L zsh

  if [ $# -lt 2 ]; then
    echo "  Usage: regmv 'regex' file(s)"
    echo "  Where:       'regex' should be of the format '/find/replace/'"
    echo "Example: regmv '/\.tif\$/.tiff/' *"
    echo "   Note: Must quote/escape the regex otherwise \"\.\" becomes \".\""
    return 1
  fi
  local regex="$1"
  shift
  while [ -n "$1" ]
  do
    local newname=$(echo "$1" | sed "s${regex}g")
    if [ "${newname}" != "$1" ]; then
      mv -i -v "$1" "$newname"
    fi
    shift
  done
}

function email() {
  emulate -L zsh

  if ! tmux has-session -t email 2> /dev/null; then
    # Make saved attachments go to ~/Downloads by default.
    tmux new-session -d -s email -c ~/Downloads -n mutt
    tmux send-keys -t email:mutt mutt Enter
    tmux new-window -t email -c ~/.mutt -n sync
    tmux send-keys -t email:sync '~/.mutt/scripts/control.sh --daemon' Enter
    tmux split-window -t email:sync -v -f -l 8 -c ~/.mutt
    tmux send-keys -t email:sync.bottom '~/.mutt/scripts/control.sh' Enter
  fi
  if [ -z "$TMUX" ]; then
    tmux attach -t email:mutt
  else
    tmux switch-client -t email:mutt
  fi
}

# Convenience function for jumping to hashed directory aliases
# (ie. `j rn` -> `jump rn` -> `cd ~rn`).
function jump() {
  emulate -L zsh

  if [ $# -eq 0 ]; then
    cd -
  elif [ $# -gt 1 ]; then
    echo "jump: single argument required, got $#"
    return 1
  else
    if [ $(hash -d|cut -d= -f1|grep -c "^$1\$") = 0 ]; then
      # Not in `hash -d`: assume it's just a dir.
      cd $1
    else
      cd ~$1
    fi
  fi
}

function _jump_complete() {
  emulate -L zsh

  local word completions
  word="$1"
  completions="$(hash -d|cut -d= -f1)"
  reply=( "${(ps:\n:)completions}" )
}

# Complete filenames and `hash -d` entries.
compctl -f -K _jump_complete jump

# "[t]ime[w]arp" by setting GIT_AUTHOR_DATE and GIT_COMMITTER_DATE.
function tw() {
  emulate -L zsh

  local TS=$(ts "$@")
  echo "Spawning subshell with timestamp: $TS"
  env GIT_AUTHOR_DATE="$TS" GIT_COMMITTER_DATE="$TS" zsh
}

# "tick" by incrementing GIT_AUTHOR_DATE and GIT_COMMITTER_DATE.
function tick() {
  emulate -L zsh

  if [ -z "$GIT_AUTHOR_DATE" -o -z "$GIT_COMMITTER_DATE" ]; then
    echo 'Expected $GIT_AUTHOR_DATE and $GIT_COMMITTER_DATE to be set.'
    echo 'Did you forget to timewarp with `tw`?'
  else
    # Fragile assumption: dates are in format produced by `tw`/`ts`.
    local TS=$(expr \
      $(echo $GIT_AUTHOR_DATE | cut -d ' ' -f 1) \
      $(parseoffset "$@") \
    )
    local TZ=$(date +%z)
    echo "Bumping timestamp to: $TS $TZ"
    export GIT_AUTHOR_DATE="$TS $TZ"
    export GIT_COMMITTER_DATE="$TS $TZ"
  fi
}

function split_logs() {
  emulate -L zsh
  # get all active services
  all_docker_services=( $(docker-compose ps --services) )
  # describe services that you ignore
  excluded_services=(db redis)

  array_index=0

  # filter elements
  for element in "${all_docker_services[@]}"; do
    should_delete=false

    for target in "${excluded_services[@]}"; do
      if [[ "$element" = "$target" ]]; then
        should_delete=true
      fi
    done

    if [[ $should_delete = true ]]; then
      unset "all_docker_services[$array_index]"
    fi

    ((array_index+=1))
  done

  main_pane_opened=false

  echo $all_docker_services

  for element in "${all_docker_services[@]}"; do
    if [[ $main_pane_opened = false ]]; then
      tmux new-window -c $(pwd) -n "logs" "docker-compose logs -f --tail='all' ${element}"
      main_pane_opened=true
    else
      tmux split-window -h "docker-compose logs -f --tail='all' ${element}"
    fi
  done
}

function tmuker() {
  emulate -L zsh

  session_name="docker"

  tmux new -d -s $session_name -c $(pwd) -n 'compose'
  tmux send-keys -t "${session_name}:compose" "docker-compose up" Enter
  tmux new-window -c $(pwd) -t 1 -n "logs"
  tmux new-window -c $(pwd) -t 2 -n "code"
  tmux send-keys -t "${session_name}:logs" "split_logs" Enter
  sleep 1
  tmux send-keys -t "${session_name}:code" "vim" Enter

  tmux attach
}

function kill_by_name() {
  ps ax | grep $1 | grep -v grep | awk '{print $1}' | xargs kill
}


# TODO: Revisit integration of tmux to ssh
# function ssh() {
#   emulate -L zsh
#
#   if [[ -z "$@" ]]; then
#     # common case: getting to my workstation
#     command ssh dev
#   else
#     local LOCAL_TERM=$(echo -n "$TERM" | sed -e s/tmux/screen/)
#     env TERM=$LOCAL_TERM command ssh "$@"
#   fi
# }
#
# function tmux() {
#   emulate -L zsh

#   # Make sure even pre-existing tmux sessions use the latest SSH_AUTH_SOCK.
#   # (Inspired by: https://gist.github.com/lann/6771001)
#   local SOCK_SYMLINK=~/.ssh/ssh_auth_sock
#   if [ -r "$SSH_AUTH_SOCK" -a ! -L "$SSH_AUTH_SOCK" ]; then
#     ln -sf "$SSH_AUTH_SOCK" $SOCK_SYMLINK
#   fi

#   # If provided with args, pass them through.
#   if [[ -n "$@" ]]; then
#     env SSH_AUTH_SOCK=$SOCK_SYMLINK tmux "$@"
#     return
#   fi

#   # Check for .tmux file (poor man's Tmuxinator).
#   if [ -x .tmux ]; then
#     # Prompt the first time we see a given .tmux file before running it.
#     local DIGEST="$(openssl sha -sha512 .tmux)"
#     if ! grep -q "$DIGEST" ~/..tmux.digests 2> /dev/null; then
#       cat .tmux
#       read -k 1 -r \
#         'REPLY?Trust (and run) this .tmux file? (t = trust, otherwise = skip) '
#       echo
#       if [[ $REPLY =~ ^[Tt]$ ]]; then
#         echo "$DIGEST" >> ~/..tmux.digests
#         ./.tmux
#         return
#       fi
#     else
#       ./.tmux
#       return
#     fi
#   fi

