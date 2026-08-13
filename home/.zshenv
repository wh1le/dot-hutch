export ZDOTDIR="$HOME/.config/zsh"

for f in "$HOME"/.config/environment.d/*.conf(N); do
  source "$f"
done
