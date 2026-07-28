import QtQuick
import "../../modules"
import "../../modules/functions"
import "../services"

Column {
    id: root
    spacing: 4

    required property string rawText
    required property var activeItem

    readonly property var fields: {
        if (!rawText) return null;
        try {
            let data = JSON.parse(rawText.trim());
            let meta = data.meta || {};
            let lic = meta.license;
            let licStr = "—";
            if (lic) licStr = lic.spdxId || lic.shortName || lic.fullName || "—";
            let src = (activeItem && activeItem.sourceLabel) ? activeItem.sourceLabel : "—";
            let unstable = activeItem ? !!activeItem.unstable : false;
            return {
                name: data.pname || data.name || data._key || "",
                version: data.version || "",
                description: meta.description || "—",
                homepage: meta.homepage || "—",
                license: licStr,
                command: meta.mainProgram || "—",
                source: src + (unstable ? " (unstable)" : "")
            };
        } catch (e) {
            return null;
        }
    }

    visible: fields !== null

    Text {
        width: parent.width
        text: root.fields ? root.fields.name : ""
        font.family: Config.options.launcher.fontFamily
        font.pixelSize: 14
        font.bold: true
        color: Appearance.m3colors.m3onBackground
        elide: Text.ElideRight
        renderType: Text.NativeRendering
    }

    Repeater {
        model: root.fields ? [
            { key: "version", val: root.fields.version || "—" },
            { key: "source", val: root.fields.source },
            { key: "description", val: root.fields.description },
            { key: "homepage", val: root.fields.homepage },
            { key: "license", val: root.fields.license }
        ] : []

        Row {
            required property var modelData
            spacing: 12
            Text {
                text: modelData.key
                width: 75
                font.family: Config.options.launcher.fontFamily
                font.pixelSize: 10
                color: Appearance.colors.colPrimary
                renderType: Text.NativeRendering
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: modelData.val
                width: root.width - 87
                font.family: Config.options.launcher.fontFamily
                font.pixelSize: 11
                color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.7)
                elide: Text.ElideRight
                renderType: Text.NativeRendering
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
