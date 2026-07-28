import QtQuick
import "../services"

Item {
    id: root
    property string rawText: ""

    readonly property string imagePath: {
        let label = FzfSource.currentItem ? (FzfSource.currentItem.label || "") : "";
        let sep = label.lastIndexOf(" | ");
        let p = sep !== -1 ? label.substring(sep + 3) : label;
        if (p.startsWith("/")) return "file://" + p;
        return "";
    }

    Image {
        anchors.fill: parent
        source: root.imagePath
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        sourceSize.height: 160
    }
}
