#!/usr/bin/env sh

killall -q polybar

# Wait until the processes have been shut down
while pgrep -u "$UID" -x polybar >/dev/null; do
	sleep 1
done

polybar --log=error bottom_bar -r &
polybar --log=error top_bar -r
