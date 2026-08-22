export ZDOTDIR="$HOME/.config/zsh"

for f in "$HOME"/.config/environment.d/*.conf(N); do
  source "$f"
done

# export NETSKOPE_BUNDLE="$HOME/.secrets/corp-ca.pem"
export NETSKOPE_BUNDLE="$HOME/.nscacert_combined.pem"
export SSL_CERT_FILE="$NETSKOPE_BUNDLE"
export CA_BUNDLE="$NETSKOPE_BUNDLE"
export CURL_CA_BUNDLE="$NETSKOPE_BUNDLE"
export REQUESTS_CA_BUNDLE="$NETSKOPE_BUNDLE"
export PIP_CERT="$NETSKOPE_BUNDLE"
export AWS_CA_BUNDLE="$NETSKOPE_BUNDLE"
export NODE_EXTRA_CA_CERTS="$NETSKOPE_BUNDLE"
export NODE_CAFILE="$NETSKOPE_BUNDLE"
export GIT_SSL_CAINFO="$NETSKOPE_BUNDLE"
export CARGO_HTTP_CAINFO="$NETSKOPE_BUNDLE"
