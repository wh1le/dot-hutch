# Word-wise motion for Alt+arrows and Alt+h / Alt+l (Linux + macOS).
# Sourced after `bindkey -e` (hotkeys.zsh), so nothing rebinds over it.

# Alt + ← / Alt + → : modifier codes 3 (xterm/kitty/alacritty/wezterm/Terminal.app),
# 9 (iTerm2 "natural text editing"), 5 (xremap/keyd emitting Ctrl+arrow codes)
#
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[[1;9D' backward-word
bindkey '^[[1;9C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Ghostty sends ESC+b / ESC+f for Alt+arrows.
bindkey '^[b' backward-word
bindkey '^[f' forward-word

# Alt+h / Alt+l : ESC-prefixed (Linux, macOS with "Use Option as Meta key")
bindkey '^[h' backward-word
bindkey '^[l' forward-word

# Alt+h / Alt+l : macOS default Option chars ˙ (U+02D9) and ¬ (U+00AC)
bindkey $'\u02d9' backward-word
bindkey $'\u00ac' forward-word
