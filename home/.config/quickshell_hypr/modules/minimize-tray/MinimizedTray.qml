pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 6

    Repeater {
        model: MinimizeTrayService.items
        MinimizedItem {
            required property var model
            address: model.address
            icon: model.icon
            title: model.title
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
