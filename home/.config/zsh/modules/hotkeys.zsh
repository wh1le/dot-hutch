bindkey -e

# Treat path separators as word boundaries for movement and deletion.
WORDCHARS=${WORDCHARS//\/}

bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^b" backward-word


bindkey "^w" backward-kill-word
bindkey "^k" kill-word
