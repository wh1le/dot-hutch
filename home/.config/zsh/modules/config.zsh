function config-reload-kitty() {
  kill -SIGUSR1 $KITTY_PID
  kitten @ load-config
  echo "reloaded"
}