pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland

// Per-screen fullscreen state via the wlr foreign-toplevel protocol.
// Event-driven (no hyprctl polling) and correct on multi-monitor setups:
// only the screen with a fullscreen toplevel reports fullscreen.
Singleton {
    id: root

    // Screens that currently have a fullscreen toplevel.
    readonly property var fullscreenScreens: {
        var screens = [];
        var tl = ToplevelManager.toplevels.values;
        for (var i = 0; i < tl.length; ++i) {
            var t = tl[i];
            if (!t || !t.fullscreen)
                continue;
            var scr = t.screens;
            for (var j = 0; j < scr.length; ++j)
                if (!screens.includes(scr[j]))
                    screens.push(scr[j]);
        }
        return screens;
    }

    // True if any toplevel anywhere is fullscreen.
    readonly property bool anyFullscreen: fullscreenScreens.length > 0

    function onScreen(screen): bool {
        return fullscreenScreens.includes(screen);
    }
}
