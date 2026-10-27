unset NPM_CONFIG_USERCONFIG

export PATH="$HOME/.npm-global/bin:$PATH"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME/bin:$HOME/.npm-global/bin:$PATH"

if [[ -n ${CONTAINER_ID:-} || -f /run/.containerenv ]]; then
  local -a user_dirs=(
    "$HOME/.pi/agent/bin"
    "$HOME/.hunk/bin"
    "$HOME/.local/bin"
    "$HOME/.local/bin/public"
    "$HOME/.local/bin/personal"
    "$HOME/.local/bin/personal/encryption"
    "$HOME/.asdf/shims"
    "$PNPM_HOME/bin"
    "$HOME/.npm-global/bin"
    "$HOME/.cabal/bin"
    "$HOME/Code/fzm/bin"
  )
  local -a head=() d
  for d in $user_dirs; do
    [[ -d "$d" ]] && head+=("$d")
  done
  local -a nix_clients=( /nix/store/*-nix-*/bin(N) )
  PATH="${(j/:/)head}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
  (( ${#nix_clients} )) && PATH="$PATH:${(j/:/)nix_clients}"
  export PATH
fi
