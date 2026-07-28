import QtQuick
import Quickshell
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

StyledText {
    text: HyprlandXkb.currentLayoutCode.substring(0, 2).toLowerCase()
    font.pixelSize: Appearance.font.pixelSize.smallest
    font.bold: true
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["hyprctl", "switchxkblayout", "all", "next"])
    }
}
