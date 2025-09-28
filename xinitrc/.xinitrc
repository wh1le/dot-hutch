#!/bin/sh

# Starts when you log in via a display mananger

autorandr &
xmodmap -e 'keycode 49 = less greater' -e 'keycode 94 = grave asciitilde'
