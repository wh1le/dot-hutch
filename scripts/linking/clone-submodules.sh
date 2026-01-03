export DOT_FILES="${1:?dot-files-path required}"

clone_submodules() {
  git -C "$DOT_FILES" submodule update --init --recursive

  echo "submodules initialized"
}

clone_submodules
