pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import "modules/common"
import "services"

Variants {
    model: Quickshell.screens

    Scope {
        id: scope
        required property var modelData

        property real borderWidth: 2
        property real cornerRadius: Appearance.rounding.verysmall

        // True when THIS screen has a fullscreen toplevel (wlr foreign-toplevel).
        readonly property bool screenFullscreen: Fullscreen.onScreen(scope.modelData)

        // Shell chrome is shown when not fullscreen, when revealed, or when any
        // popup/OSD needs to draw above the fullscreen window.
        readonly property bool chromeVisible: !scope.screenFullscreen
            || GlobalStates.barRevealedInFullscreen
            || GlobalStates.volumeOsdVisible
            || GlobalStates.brightnessOsdVisible
            || GlobalStates.mediaToastVisible
            || GlobalStates.quickSettingsOpen
            || GlobalStates.calendarOpen
            || GlobalStates.mediaControlsOpen
            || GlobalStates.appLauncherOpen
            || GlobalStates.menuModeOpen
            || GlobalStates.wallpaperPickerOpen
            || GlobalStates.fzfPanelOpen
            || PinEntry.visible

        // Invisible exclusion windows to reserve space
        Exclusions {
            screen: scope.modelData
            borderWidth: scope.borderWidth
        }

        // Bar reveal during fullscreen is toggled via IPC keybind (target "bar",
        // toggleReveal) — no persistent surface over the fullscreen window, so
        // Hyprland keeps direct-scanout (no tearing / VRR flicker).

        // Timer to hide bar when mouse leaves during fullscreen
        Timer {
            id: barHideTimer
            interval: 100
            onTriggered: {
                GlobalStates.barRevealedInFullscreen = false;
            }
        }

        Connections {
            target: scope
            function onScreenFullscreenChanged() {
                if (!scope.screenFullscreen)
                    GlobalStates.barRevealedInFullscreen = false;
            }
        }

        // Main overlay window spanning full screen
        PanelWindow {
            id: win
            screen: scope.modelData
            color: "transparent"

            // Stay mapped at all times. Toggling `visible` destroys & recreates the
            // Wayland surface, rebuilding the whole scene graph — a big flash across
            // every workspace on the output. Instead drop to the Background layer
            // during fullscreen: nothing renders above the fullscreen window, so
            // Hyprland keeps direct-scanout (no tearing / VRR flicker), and the
            // fullscreen window fully occludes the shell so it's invisible. Raising
            // back to Overlay on exit is a cheap layer reorder, not a surface
            // recreate, so there's no flash.
            visible: true

            anchors { top: true; bottom: true; left: true; right: true }

            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: scope.chromeVisible ? WlrLayer.Overlay : WlrLayer.Background
            WlrLayershell.namespace: "quickshell-shell"
            WlrLayershell.keyboardFocus: (GlobalStates.quickSettingsOpen || GlobalStates.calendarOpen || GlobalStates.appLauncherOpen || GlobalStates.menuModeOpen || GlobalStates.wallpaperPickerOpen || GlobalStates.fzfPanelOpen || PinEntry.visible) ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

            // Hide bar when mouse leaves bar area during fullscreen
            MouseArea {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Appearance.sizes.barHeight
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                visible: scope.screenFullscreen && GlobalStates.barRevealedInFullscreen
                z: 100
                onContainsMouseChanged: {
                    if (containsMouse)
                        barHideTimer.stop();
                    else
                        barHideTimer.restart();
                }
            }

            // Input mask: make interior click-through, bar+borders+popups receive input
            // When bar is hidden (fullscreen), make entire window click-through
            mask: (scope.screenFullscreen && !GlobalStates.barRevealedInFullscreen) ? nullMask : normalMask

            Region {
                id: nullMask
                // Full window Xor = entire surface is click-through
                x: 0; y: 0; width: win.width; height: win.height
                intersection: Intersection.Xor
            }

            Region {
                id: normalMask
                // Interior hole (click-through)
                x: panels.sidebarWidth
                y: Appearance.sizes.barHeight
                width: win.width - panels.sidebarWidth - scope.borderWidth
                height: win.height - Appearance.sizes.barHeight
                intersection: Intersection.Xor

                // Subtract popup and sidebar regions so they receive input
                regions: [sidebarRegion].concat(popupRegions.instances)
            }

            Region {
                id: sidebarRegion
                x: 0
                y: 0
                width: panels.sidebarWidth
                height: win.height
                intersection: Intersection.Subtract
            }

            Variants {
                id: popupRegions
                model: {
                    var regions = [];
                    if (GlobalStates.mediaControlsOpen)
                        regions.push({
                            rx: panels.sidebarWidth,
                            ry: Appearance.sizes.barHeight,
                            rw: panels.mediaControlsWidth,
                            rh: panels.mediaControlsHeight
                        });
                    if (GlobalStates.quickSettingsOpen)
                        regions.push({
                            rx: win.width - scope.borderWidth - panels.quickSettingsWidth,
                            ry: Appearance.sizes.barHeight,
                            rw: panels.quickSettingsWidth,
                            rh: panels.quickSettingsHeight
                        });
                    if (GlobalStates.calendarOpen)
                        regions.push({
                            rx: win.width - scope.borderWidth - panels.calendarWidth,
                            ry: Appearance.sizes.barHeight,
                            rw: panels.calendarWidth,
                            rh: panels.calendarHeight
                        });
                    if (GlobalStates.volumeOsdVisible || GlobalStates.brightnessOsdVisible)
                        regions.push({
                            rx: win.width - 36,
                            ry: (win.height - 160) / 2,
                            rw: 36,
                            rh: 160
                        });
                    if (GlobalStates.appLauncherOpen || GlobalStates.menuModeOpen || GlobalStates.fzfPanelOpen)
                        regions.push({
                            rx: (win.width - panels.launcherWidth) / 2,
                            ry: win.height - panels.launcherHeight,
                            rw: panels.launcherWidth,
                            rh: panels.launcherHeight
                        });
                    if (GlobalStates.wallpaperPickerOpen)
                        regions.push({
                            rx: 0,
                            ry: 0,
                            rw: win.width,
                            rh: win.height
                        });
                    return regions;
                }

                Region {
                    required property var modelData
                    x: modelData.rx
                    y: modelData.ry
                    width: modelData.rw
                    height: modelData.rh
                    intersection: Intersection.Subtract
                }
            }

            // Focus grab to close popups when clicking outside
            HyprlandFocusGrab {
                id: focusGrab
                active: GlobalStates.quickSettingsOpen || GlobalStates.calendarOpen || GlobalStates.mediaControlsOpen || GlobalStates.appLauncherOpen || GlobalStates.menuModeOpen || GlobalStates.wallpaperPickerOpen || GlobalStates.fzfPanelOpen
                windows: [win]
                onCleared: {
                    GlobalStates.quickSettingsOpen = false;
                    GlobalStates.calendarOpen = false;
                    GlobalStates.mediaControlsOpen = false;
                    GlobalStates.appLauncherOpen = false;
                    GlobalStates.menuModeOpen = false;
                    GlobalStates.wallpaperPickerOpen = false;
                    GlobalStates.fzfPanelOpen = false;
                }
            }

            // Border frame (bar + side borders via inverted mask)
            Border {
                visible: scope.chromeVisible
                borderWidth: scope.borderWidth
                cornerRadius: scope.cornerRadius
            }

            // Popup backgrounds (drawn inside the border area)
            Backgrounds {
                visible: scope.chromeVisible
                panels: panels
                borderWidth: scope.borderWidth
                cornerRadius: scope.cornerRadius
            }

            // All content panels
            Panels {
                id: panels
                visible: scope.chromeVisible
                borderWidth: scope.borderWidth
            }
        }
    }
}
