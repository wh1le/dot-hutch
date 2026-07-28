import QtQuick
import QtQuick.Layouts
import "../../modules/common"
import "../../modules/common/widgets"

RippleButton {
    id: root
    required property QtObject model
    implicitHeight: 48
    Layout.fillWidth: true
    buttonRadius: Appearance.rounding.normal
    toggled: model.toggled
    onClicked: model.mainAction()

    contentItem: RowLayout {
        spacing: 8
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        MaterialSymbol {
            text: root.model.icon
            iconSize: 18
            fill: root.model.toggled ? 1 : 0
            color: root.model.toggled ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
        }
        StyledText {
            text: root.model.name
            font.pixelSize: Appearance.font.pixelSize.smaller
            color: root.model.toggled ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
    }
}
