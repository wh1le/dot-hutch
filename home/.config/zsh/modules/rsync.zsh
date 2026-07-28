rs-clone-from-ssh() {
  rsync -avz --filter=':- .gitignore' $1 $2
}
