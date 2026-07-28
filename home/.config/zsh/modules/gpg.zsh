alias gpg-keys="gpg --list-keys --keyid-format=long"

function gpg-restart() {
  gpgconf --kill gpg-agent
  gpg-connect-agent /bye
  echo "GPG agent restarted"
}
