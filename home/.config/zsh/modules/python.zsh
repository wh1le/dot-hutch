function helper-python-watch() {
  nodemon --quiet --exec 'clear; echo "[reloaded]"; python3 -m friendly' "$1"
}

function python_repl {
  python3 -i -c "import friendly; friendly.set_formatter('plain'); friendly.install()"
}
