import QtQuick
import Quickshell
import Quickshell.Widgets
import "../../modules/common"
import "../../modules/common/functions"
import "../.."
import "../../services"
import "../services"

Item {
    id: root

    required property var entry
    property bool selected: false
    property int rowHeight: 40
    property bool isMenuMode: false

    height: rowHeight
    implicitHeight: rowHeight

    anchors.left: parent?.left
    anchors.right: parent?.right

    // Selected tint — colPrimary at 0.1 alpha, same as sidebar
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 6
        color: ColorUtils.applyAlpha(Appearance.colors.colPrimary, 0.1)
        visible: root.selected
    }

    // 3px accent left border — same as sidebar
    Rectangle {
        width: 3
        height: parent.height
        color: Appearance.colors.colPrimary
        visible: root.selected
    }

    IconImage {
        id: appIcon
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 12
        width: 16
        height: 16
        source: AppIcons.get(root.entry?.icon ?? "")
        asynchronous: true
        opacity: 0.4
        visible: !root.isMenuMode
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: root.isMenuMode ? parent.left : appIcon.right
        anchors.right: root.isMenuMode ? parent.right : categoryText.left
        anchors.leftMargin: root.isMenuMode ? 12 : 8
        anchors.rightMargin: 12

        text: root.isMenuMode ? (root.entry?.displayLabel ?? "") : (root.entry?.name ?? "")
        font.family: Config.options.launcher.fontFamily
        font.pixelSize: Config.options.launcher.fontSize
        color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, root.selected ? 1.0 : 0.5)
        elide: Text.ElideRight
        renderType: Text.NativeRendering
    }

    Text {
        id: categoryText
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 12
        visible: !root.isMenuMode

        text: {
            const cats = root.entry?.categories ?? [];
            if (cats.length === 0) return "";
            // Filter out generic categories
            const skip = ["Application", "GNOME", "GTK", "Qt", "KDE", "X-"];
            for (let i = 0; i < cats.length; i++) {
                const c = cats[i];
                let dominated = false;
                for (let j = 0; j < skip.length; j++) {
                    if (c === skip[j] || c.startsWith("X-")) { dominated = true; break; }
                }
                if (!dominated) return c;
            }
            return "";
        }
        font.family: Config.options.launcher.fontFamily
        font.pixelSize: Config.options.launcher.fontSize - 2
        color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.3)
        renderType: Text.NativeRendering
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (root.isMenuMode)
                MenuMode.launch(root.entry);
            else
                Apps.launch(root.entry);
        }
    }
}
