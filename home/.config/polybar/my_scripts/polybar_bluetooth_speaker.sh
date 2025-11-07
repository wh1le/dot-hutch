#!/bin/bash
# Bluetooth speaker indicator for polybar.
# Change the MAC address to the MAC of your speaker, after it is paired.
# I cannot guarantee it will work for you. This script does nothing to
# actually connect to the speaker, it only displays a status icon.
#
# Author: machaerus
# https://gitlab.com/machaerus

bluetooth_speaker() {
	SPEAKER_CONNECTED=$(bt-device -i 1C:1D:D3:74:6C:A9 | grep Connected | xargs | cut -d ' ' -f 2)
	if [ "$SPEAKER_CONNECTED" -eq 1 ]; then
		speaker_indicator=true
	else
		speaker_indicator=false
	fi
	echo $speaker_indicator
}
bluetooth_speaker