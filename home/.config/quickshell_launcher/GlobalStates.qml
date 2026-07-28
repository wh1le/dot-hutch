pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root
    property bool quickSettingsOpen: false
    property bool mediaControlsOpen: false
    property bool barOpen: true
    property bool sidebarExpanded: false
    property bool mediaToastVisible: false
    property bool volumeOsdVisible: false
    property bool brightnessOsdVisible: false
    property bool appLauncherOpen: false
    property bool menuModeOpen: false
    property bool wallpaperPickerOpen: false
    property bool fzfPanelOpen: false
    property bool otpPromptOpen: false
    property bool barRevealedInFullscreen: false
    property bool calendarOpen: false
}
