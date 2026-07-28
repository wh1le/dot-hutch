#!/usr/bin/env bash
# Outputs full tmux state as JSON
# Used by QuickShell TmuxService on each event

CLIENTS=$(tmux list-clients -F '{"pid":#{client_pid},"session":"#{session_name}","tty":"#{client_tty}"}' 2>/dev/null | paste -sd, -)
WINDOWS=$(tmux list-windows -a -F '{"session":"#{session_name}","index":#{window_index},"name":"#{window_name}","active":#{window_active},"flags":"#{window_flags}","command":"#{pane_current_command}","windowId":"#{window_id}","zoomed":#{window_zoomed_flag}}' 2>/dev/null | paste -sd, -)

# Build pane commands map: windowId -> [cmd1, cmd2, ...]
declare -A pane_map
while IFS='|' read -r wid cmd; do
    if [[ -n "${pane_map[$wid]}" ]]; then
        pane_map[$wid]="${pane_map[$wid]},\"$cmd\""
    else
        pane_map[$wid]="\"$cmd\""
    fi
done < <(tmux list-panes -a -F "#{window_id}|#{pane_current_command}" 2>/dev/null)

# Build panes JSON object
PANES="{"
first=true
for wid in "${!pane_map[@]}"; do
    if $first; then first=false; else PANES="$PANES,"; fi
    PANES="$PANES\"$wid\":[${pane_map[$wid]}]"
done
PANES="$PANES}"

echo "{\"clients\":[$CLIENTS],\"windows\":[$WINDOWS],\"panes\":$PANES}"
