import QtQuick
import QtQuick.Layouts
import "../modules/common"
import "../modules/common/functions"

Item {
    id: root
    default property alias content: contentRow.data

    implicitWidth: contentRow.implicitWidth + 2
    implicitHeight: 22
    Layout.alignment: Qt.AlignVCenter

    RowLayout {
        id: contentRow
        anchors.centerIn: parent
        spacing: 3
    }
}
