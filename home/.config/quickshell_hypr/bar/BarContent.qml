import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../modules/common"
import "../modules/common/widgets"
import "../modules/common/functions"
import "../modules/minimize-tray"
import "../services"
import ".."
import "left"
import "center"
import "right"

Item {
    id: root
    property real screenWidth: 1920

    readonly property color fgColor: Appearance.m3colors.m3onBackground
    readonly property color accentColor: Appearance.m3colors.m3primary

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 4

        // === LEFT ===
        PowerMenu {
            Layout.alignment: Qt.AlignVCenter
        }
        BarGroup {
            visible: root.screenWidth > Appearance.sizes.barHellaShortenScreenWidthThreshold && (Submap.activeSubmap !== "" || MicActivity.active || FloatingWindows.count > 0)
            SubmapIndicator {}
            MicIndicator {}
            FloatingCount {}
        }

        Media {
            Layout.alignment: Qt.AlignVCenter
            visible: root.screenWidth > Appearance.sizes.barHellaShortenScreenWidthThreshold
        }

        Item { Layout.fillWidth: true }

        // === RIGHT SIDE: all zones in one parent with 12px group spacing ===
        RowLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 12

            // Row A: Tray icons
            SysTray {
                Layout.alignment: Qt.AlignVCenter
                opacity: 0.3
            }

            // Row B: Toggle icons
            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 4
                SystemdServiceItem {
                    Layout.alignment: Qt.AlignVCenter
                    visible: services.length > 0
                }
                VpnIndicator {}
                EncryptionIndicator {}
                CaffeineToggle {}
                NightShiftToggle {}
            }

            // Row C: Status icons
            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 4
                VolumeIcon {}
                BluetoothIcon {}
                NetworkIcon {}
            }

            // Row D: Text info + clock
            Row {
                Layout.alignment: Qt.AlignVCenter
                spacing: 6

                Text {
                    text: HyprlandXkb.currentLayoutCode.substring(0, 2).toLowerCase()
                    font.family: "Hack-ZeroSlash"
                    font.pixelSize: 10
                    font.weight: Font.Normal
                    color: ColorUtils.applyAlpha(root.fgColor, 0.5)
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Quickshell.execDetached(["hyprctl", "switchxkblayout", "all", "next"])
                    }
                }

                Text {
                    text: Weather.displayText.replace(/<[^>]*>/g, "")
                    font.family: "Hack-ZeroSlash"
                    font.pixelSize: 10
                    font.weight: Font.Normal
                    color: ColorUtils.applyAlpha(root.fgColor, 0.6)
                    anchors.verticalCenter: parent.verticalCenter
                    visible: Weather.displayText !== "" && root.screenWidth > Appearance.sizes.barShortenScreenWidthThreshold
                }

                Text {
                    text: (Battery.isCharging ? "~" : "") + Math.round(Battery.percentage * 100) + "%"
                    font.family: "Hack-ZeroSlash"
                    font.pixelSize: 10
                    font.weight: Font.Normal
                    color: !Battery.isCharging && Battery.isCritical ? "#FF4444"
                         : !Battery.isCharging && Battery.isLow ? "#FFAA33"
                         : ColorUtils.applyAlpha(root.fgColor, 0.6)
                    anchors.verticalCenter: parent.verticalCenter
                    visible: Battery.available
                }

                Text {
                    text: DateTime.time
                    font.family: "Hack-ZeroSlash"
                    font.pixelSize: 10
                    font.weight: Font.Normal
                    color: root.accentColor
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: GlobalStates.quickSettingsOpen = !GlobalStates.quickSettingsOpen
                    }
                }

                MouseArea {
                    implicitWidth: dateLabel.implicitWidth
                    implicitHeight: dateLabel.implicitHeight
                    anchors.verticalCenter: parent.verticalCenter
                    cursorShape: Qt.PointingHandCursor
                    onClicked: GlobalStates.calendarOpen = !GlobalStates.calendarOpen

                    Text {
                        id: dateLabel
                        readonly property string dayStr: Qt.locale().toString(DateTime.clock.date, "dd")
                        readonly property string monthStr: Qt.locale().toString(DateTime.clock.date, "MM")
                        textFormat: Text.RichText
                        text: `<span style="color:${ColorUtils.applyAlpha(root.accentColor, 0.7)};">${dayStr}</span>`
                            + `<span style="color:${ColorUtils.applyAlpha(root.fgColor, 0.35)};">/</span>`
                            + `<span style="color:${ColorUtils.applyAlpha(root.fgColor, 0.45)};">${monthStr}</span>`
                        font.family: "Hack-ZeroSlash"
                        font.pixelSize: 10
                        font.weight: Font.Normal
                    }
                }

                MaterialSymbol {
                    visible: Notifications.unread > 0
                    text: "notifications_active"
                    iconSize: 12
                    fill: 1
                    color: root.accentColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    visible: Notifications.unread > 0
                    text: Notifications.unread
                    font.family: "Hack-ZeroSlash"
                    font.pixelSize: 10
                    color: root.accentColor
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    property bool showTmux: TmuxService.available && (ToplevelManager.activeToplevel?.appId ?? "") === "kitty"
    TmuxTabs {
        anchors.centerIn: parent
        visible: root.showTmux
    }
    ActiveWindow {
        anchors.centerIn: parent
        visible: !root.showTmux
    }
}
