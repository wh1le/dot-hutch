rerun() {
  local specs
  specs=$(wl-paste 2>/dev/null | grep -oE 'spec/[^[:space:]]+:[0-9]+' | tr '\n' ' ')

  if [[ -z "$specs" ]]; then
    echo "No specs found in clipboard"
    return 1
  fi

  echo "Running: nix develop -c bundle exec rspec $specs"
  eval "nix develop -c bundle exec rspec $specs"
}

rerunw() {
  local specs
  specs=$(wl-paste 2>/dev/null | grep -oE 'spec/[^[:space:]]+:[0-9]+' | tr '\n' ' ')

  if [[ -z "$specs" ]]; then
    echo "No specs found in clipboard"
    return 1
  fi

  echo "Running: WATCH=1 nix develop -c cage -- bundle exec rspec $specs"
  WATCH=1 nix develop -c cage -- bundle exec rspec ${=specs}
}