#!/usr/bin/env bash

window_name="$1"
pane_title="$2"
window_id="$3"

# Icons (nerd font) with display widths
# Material Design icons (󰀀-󱿿) = 2 cells, Custom icons () = 1 cell
declare -A icons=(
	[agent]="󱐋"
	[nvim]=" "
	[zsh]=" "
	[mpv]=" "
	[ruby]=" "
	[puma]=" "
	[rspec]=" "
	[sidekiq]=" "
)
declare -A widths=(
	[agent]=0
	[nvim]=1
	[zsh]=1
	[mpv]=0
	[ruby]=1
	[puma]=1
	[rspec]=" 1"
	[sidekiq]=1
)

get_icon() {
	local cmd="$1"
	if [[ "$cmd" == "npm" || "$cmd" == "node" || "$cmd" == "claude" ]]; then
		echo "agent"
	elif [[ "$cmd" == *nvim* || "$cmd" == *vim* ]]; then
		echo "nvim"
	elif [[ "$cmd" == *zsh* || "$cmd" == *bash* ]]; then
		echo "zsh"
	elif [[ "$cmd" == *mpv* ]]; then
		echo "mpv"
	elif [[ "$cmd" == *ruby* ]]; then
		echo "ruby"
	elif [[ "$cmd" == *rspec* ]]; then
		echo "ruby"
	elif [[ "$cmd" == *puma* ]]; then
		echo "puma"
	elif [[ "$cmd" == *sidekiq* ]]; then
		echo "sidekiq"
	fi
}

# Determine display name
name="$window_name"
if [[ -n "$window_id" ]]; then
	has_agent=$(tmux list-panes -t "$window_id" -F "#{pane_current_command}" 2>/dev/null | grep -E "^(npm|node)$")
	if [[ -n "$has_agent" && "$window_name" == "npm" ]]; then
		name="agent"
	fi
fi

# Collect icons from all panes with proper spacing
result=""
prev_width=""
if [[ -n "$window_id" ]]; then
	zoomed=$(tmux display-message -t "$window_id" -p "#{window_zoomed_flag}" 2>/dev/null)
	if [[ "$zoomed" == "1" ]]; then
		result="$result  - " # fa-expand icon
	fi
	while IFS= read -r pane_cmd; do
		key=$(get_icon "$pane_cmd")
		if [[ -n "$key" ]]; then
			icon="${icons[$key]}"
			width="${widths[$key]}"

			# Add spacing based on previous icon's width
			if [[ -n "$prev_width" && "$prev_width" -eq 1 ]]; then
				result="$result " # add space after 1-cell icon
			fi

			result="$result$icon"
			prev_width="$width"
		fi
	done < <(tmux list-panes -t "$window_id" -F "#{pane_current_command}" 2>/dev/null)

fi

if [[ -n "$result" ]]; then
	echo "$name $result"
else
	echo "$name"
fi
