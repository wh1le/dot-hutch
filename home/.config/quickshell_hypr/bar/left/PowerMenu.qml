import QtQuick
import "../../modules/common"
import "../../modules/common/widgets"

Item {
    implicitWidth: 22
    implicitHeight: 22

    Text {
        text: "\u{F0BC9}"
        font.family: Appearance.font.family.monospace
        font.pixelSize: 18
        anchors.centerIn: parent
        color: Appearance.colors.colPrimary
        renderType: Text.NativeRendering
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            // TODO: Power menu popup
        }
    }
}
