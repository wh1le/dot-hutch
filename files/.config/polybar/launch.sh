#!/usr/bin/env sh

pkill -x polybar 2>/dev/null

polybar --log=error bottom_bar -r & polybar --log=error top_bar -r &
