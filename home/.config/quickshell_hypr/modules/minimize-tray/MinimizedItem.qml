pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

MouseArea {
    id: root
    required property string address
    required property string icon
    required property string title
    required property string appId
    required property bool hidden

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
    implicitWidth: Appearance.sizes.barMaterialIconSize
    implicitHeight: Appearance.sizes.barMaterialIconSize

    onPressed: (event) => {
        if (event.button === Qt.LeftButton)
            MinimizeTrayService.restore(root.address);
        else if (event.button === Qt.MiddleButton)
            MinimizeTrayService.closeWindow(root.address);
        event.accepted = true;
    }

    IconImage {
        source: Quickshell.iconPath(AppIcons.guessIcon(root.appId), "image-missing")
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }
}
