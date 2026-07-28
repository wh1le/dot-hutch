#!/usr/bin/env bash
# Long-running tmux -CC monitor
# Closes stdin so nothing leaks to tmux
# Filters output to only % events (not %output/%begin/%end)
# Usage: tmux-cc-monitor.sh [session_name]

SESSION="${1:-$(tmux list-sessions -F '#{session_name}' 2>/dev/null | head -1)}"
[ -z "$SESSION" ] && exit 1

exec 0</dev/null
script -qfec "tmux -CC attach -t '$SESSION'" /dev/null 2>/dev/null | while IFS= read -r line; do
    case "$line" in
        %output*|%begin*|%end*|\\\x1b*|P1000p*) ;;
        %*) echo "$line" ;;
    esac
done
