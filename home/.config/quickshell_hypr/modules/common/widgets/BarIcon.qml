import QtQuick
import ".."

MaterialSymbol {
    id: root

    property bool active: false
    property bool clickable: true
    property color activeColor: Appearance.m3colors.m3primary
    property color inactiveColor: Appearance.colors.colSubtext

    signal leftClicked()
    signal rightClicked()

    iconSize: 12
    fill: active ? 1 : 0
    color: Appearance.m3colors.m3onBackground
    opacity: active ? 0.6 : 0.2
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    MouseArea {
        anchors.fill: parent
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: root.clickable
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (event) => {
            if (event.button === Qt.RightButton)
                root.rightClicked();
            else
                root.leftClicked();
        }
    }
}
