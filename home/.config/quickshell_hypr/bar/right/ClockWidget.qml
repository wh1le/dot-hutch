import QtQuick
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"
import "../.."

StyledText {
    text: DateTime.time
    font.pixelSize: Appearance.font.pixelSize.smaller
    animateChange: true
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: GlobalStates.quickSettingsOpen = !GlobalStates.quickSettingsOpen
    }
}
