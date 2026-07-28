import QtQuick
import QtQuick.Layouts
import "../modules/common"
import "../modules/common/widgets"
import "../services"

ColumnLayout {
    spacing: 4

    RowLayout {
        Layout.fillWidth: true
        StyledText {
            text: "Notifications"
            font.pixelSize: Appearance.font.pixelSize.normal
            font.weight: Font.DemiBold
        }
        Item { Layout.fillWidth: true }
        RippleButton {
            visible: Notifications.list.length > 0
            implicitHeight: 24
            buttonRadius: Appearance.rounding.small
            contentItem: StyledText {
                text: "Clear all"
                font.pixelSize: Appearance.font.pixelSize.smallest
                color: Appearance.colors.colPrimary
            }
            onClicked: Notifications.discardAllNotifications()
        }
    }

    StyledText {
        visible: Notifications.list.length === 0
        text: "No notifications"
        font.pixelSize: Appearance.font.pixelSize.smaller
        color: Appearance.colors.colSubtext
    }

    Repeater {
        model: Math.min(Notifications.list.length, 5)
        Rectangle {
            required property int index
            property var notif: Notifications.list[Notifications.list.length - 1 - index]
            Layout.fillWidth: true
            implicitHeight: notifCol.implicitHeight + 12
            color: Appearance.colors.colLayer2
            radius: Appearance.rounding.small

            ColumnLayout {
                id: notifCol
                anchors.fill: parent
                anchors.margins: 6
                spacing: 2
                StyledText {
                    text: notif?.summary ?? ""
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                StyledText {
                    text: notif?.body ?? ""
                    font.pixelSize: Appearance.font.pixelSize.smallest
                    color: Appearance.colors.colSubtext
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }
            }
        }
    }
}
