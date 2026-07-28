#!/usr/bin/env bash
# Resolves the tmux session name for a given kitty PID
# Usage: tmux-resolve-session.sh <kitty_pid>

KITTY_PID="$1"
[ -z "$KITTY_PID" ] && exit 0

# Get direct children of kitty (usually shells)
CHILDREN=$(pgrep -P "$KITTY_PID" 2>/dev/null | tr '\n' ',')
[ -z "$CHILDREN" ] && exit 0

# Find tmux client among grandchildren (shell -> tmux)
TMUX_PID=$(pgrep -a -P "$CHILDREN" 2>/dev/null | grep tmux | head -1 | awk '{print $1}')

# Fallback: check direct children
[ -z "$TMUX_PID" ] && TMUX_PID=$(pgrep -P "$KITTY_PID" -f tmux 2>/dev/null | head -1)

[ -z "$TMUX_PID" ] && exit 0

# Match tmux client PID to session name
tmux list-clients -F "#{client_pid}|#{session_name}" 2>/dev/null | grep "^${TMUX_PID}|" | cut -d'|' -f2
