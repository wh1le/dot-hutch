import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../modules/common"
import "../../modules/common/functions"
import "../../services"

Item {
    id: root
    readonly property var activeWindow: ToplevelManager.activeToplevel
    readonly property string rawTitle: activeWindow?.activated ? (activeWindow?.title ?? "") : ""
    readonly property string appId: activeWindow?.appId ?? ""
    readonly property string title: {
        let t = rawTitle;
        if (!t) return "";
        // Strip " — AppName" or " - AppName" suffixes
        let separators = [" — ", " - ", " – "];
        for (let sep of separators) {
            let idx = t.lastIndexOf(sep);
            if (idx > 0) {
                let suffix = t.substring(idx + sep.length).toLowerCase();
                let app = appId.toLowerCase().replace(/[^a-z]/g, "");
                // Strip if suffix looks like the app name
                if (suffix.includes(app) || app.includes(suffix.replace(/[^a-z]/g, "")))
                    t = t.substring(0, idx);
            }
        }
        return t;
    }

    anchors.centerIn: parent
    implicitWidth: 200
    implicitHeight: Appearance.sizes.barHeight

    Text {
        anchors.centerIn: parent
        width: parent.width
        text: root.title
        font.family: "Hack-ZeroSlash"
        font.pixelSize: 10
        font.weight: Font.Normal
        color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.5)
        renderType: Text.NativeRendering
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
