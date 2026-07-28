import QtQuick
import "modules/common"
import "modules/common/widgets"
import "modules/common/functions"
import "bar"
import "bar/left"
import "bar/left/mediaControls"
import "quickSettings"
import "sidebar"
import "launcher"
import "wallpaper"
import "services"

Item {
    id: root
    anchors.fill: parent

    required property real borderWidth

    // Animated popup heights
    property real mediaControlsWidth: 320
    property real mediaControlsTargetHeight: mediaControlsLoader.item?.implicitHeight ?? 120
    property real mediaControlsHeight: 0
    property real quickSettingsWidth: Appearance.sizes.quickSettingsWidth
    property real quickSettingsTargetHeight: quickSettingsLoader.item?.implicitHeight ?? 200
    property real quickSettingsHeight: 0
    property real calendarWidth: 210
    property real calendarTargetHeight: calendarLoader.item?.implicitHeight ?? 250
    property real calendarHeight: 0


    onMediaControlsTargetHeightChanged: {
        if (GlobalStates.mediaControlsOpen)
            mediaControlsHeight = mediaControlsTargetHeight;
    }

    onQuickSettingsTargetHeightChanged: {
        if (GlobalStates.quickSettingsOpen)
            quickSettingsHeight = quickSettingsTargetHeight;
    }

    onCalendarTargetHeightChanged: {
        if (GlobalStates.calendarOpen)
            calendarHeight = calendarTargetHeight;
    }

    Connections {
        target: GlobalStates
        function onMediaControlsOpenChanged() {
            root.mediaControlsHeight = GlobalStates.mediaControlsOpen ? root.mediaControlsTargetHeight : 0;
        }
        function onQuickSettingsOpenChanged() {
            root.quickSettingsHeight = GlobalStates.quickSettingsOpen ? root.quickSettingsTargetHeight : 0;
        }
        function onCalendarOpenChanged() {
            root.calendarHeight = GlobalStates.calendarOpen ? root.calendarTargetHeight : 0;
        }
    }

    Behavior on mediaControlsHeight {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    Behavior on quickSettingsHeight {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    Behavior on calendarHeight {
        NumberAnimation {
            duration: 0
        }
    }

    // Launcher dimensions for input mask
    property real launcherWidth: launcherLoader.item?.implicitWidth ?? 0
    property real launcherHeight: launcherLoader.item?.implicitHeight ?? 0

    property real sidebarWidth: 30

    // Vertical workspace sidebar (left edge, full height)
    VerticalWorkspaces {
        id: sidebarWorkspaces
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.sidebarWidth
    }

    // Bar content (to the right of sidebar)
    BarContent {
        id: barContent
        anchors.left: sidebarWorkspaces.right
        anchors.right: parent.right
        anchors.top: parent.top
        height: Appearance.sizes.barHeight
        screenWidth: root.width - root.sidebarWidth
    }

    // Media song change toast — below bar, aligned under song text
    MediaToast {
        x: root.sidebarWidth
        y: Appearance.sizes.barHeight
    }

    // Media controls popup content
    Item {
        x: root.sidebarWidth
        y: Appearance.sizes.barHeight
        width: root.mediaControlsWidth
        height: root.mediaControlsHeight
        clip: true

        Loader {
            id: mediaControlsLoader
            width: parent.width
            height: root.mediaControlsTargetHeight
            active: GlobalStates.mediaControlsOpen || root.mediaControlsHeight > 0
            sourceComponent: MediaControlsContent {}
        }
    }

    // Volume OSD — right edge, vertically centered
    VolumeOsd {}

    BrightnessOsd {}

    // Quick settings popup content
    Item {
        x: root.width - root.borderWidth - root.quickSettingsWidth
        y: Appearance.sizes.barHeight
        width: root.quickSettingsWidth
        height: root.quickSettingsHeight
        clip: true

        Loader {
            id: quickSettingsLoader
            width: parent.width
            height: root.quickSettingsTargetHeight
            active: GlobalStates.quickSettingsOpen || root.quickSettingsHeight > 0
            sourceComponent: QuickSettingsContent {}
        }
    }

    // Calendar popup content
    Item {
        x: root.width - root.borderWidth - root.calendarWidth
        y: Appearance.sizes.barHeight
        width: root.calendarWidth
        height: root.calendarHeight
        clip: true

        Loader {
            id: calendarLoader
            width: parent.width
            height: root.calendarTargetHeight
            active: GlobalStates.calendarOpen || root.calendarHeight > 0
            sourceComponent: CalendarWidget {}
        }
    }

    // App launcher — centered, bottom-anchored
    Loader {
        id: launcherLoader
        active: GlobalStates.appLauncherOpen || GlobalStates.menuModeOpen || GlobalStates.fzfPanelOpen
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        sourceComponent: Wrapper {}
    }

    // Wallpaper picker — full-screen overlay
    Loader {
        id: wallpaperPickerLoader
        active: GlobalStates.wallpaperPickerOpen
        anchors.fill: parent

        sourceComponent: WallpaperPicker {
            visible: GlobalStates.wallpaperPickerOpen
        }
    }

    // Pinentry dialog
    Loader {
        active: PinEntry.visible
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        z: 100

        sourceComponent: Rectangle {
            width: Config.options.launcher.itemWidth + 20
            height: col.implicitHeight + 20
            radius: 6
            color: Appearance.colors.colBarBg

            Component.onCompleted: pinInput.forceActiveFocus()

            Column {
                id: col
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                Text {
                    width: parent.width
                    text: PinEntry.description
                    color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.5)
                    font.family: Config.options.launcher.fontFamily
                    font.pixelSize: Config.options.launcher.fontSize
                    wrapMode: Text.Wrap
                }

                Text {
                    visible: PinEntry.error !== ""
                    text: PinEntry.error
                    color: "#FF4444"
                    font.family: Config.options.launcher.fontFamily
                    font.pixelSize: Config.options.launcher.fontSize
                }

                SearchInput {
                    id: pinInput
                    anchors.left: parent.left
                    anchors.right: parent.right
                    password: true
                    placeholder: PinEntry.prompt || "passphrase..."

                    onAccepted: PinEntry.submit(pinInput.text)
                    Component.onCompleted: forceActiveFocus()

                    Keys.onEscapePressed: PinEntry.cancel()
                }
            }
        }
    }
}
