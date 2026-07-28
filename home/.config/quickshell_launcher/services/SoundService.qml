pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string themePath: Quickshell.env("SOUND_THEME_PATH") || "/run/current-system/sw/share/sounds/ocean/stereo"

    function play(name) {
        player.command = ["sh", "-c", "paplay " + themePath + "/" + name + ".oga &"];
        player.running = true;
    }

    Process {
        id: player
    }
}
