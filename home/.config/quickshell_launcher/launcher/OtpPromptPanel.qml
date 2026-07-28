pragma ComponentBehavior: Bound

import QtQuick
import "../modules"
import "../modules/functions"
import "../modules/widgets"
import ".."
import "services"

Rectangle {
    id: root

    readonly property int itemWidth: Config.options.launcher.itemWidth
    readonly property int padding: 10

    color: Appearance.colors.colBarBg
    radius: 6

    implicitWidth: itemWidth + padding * 2
    implicitHeight: label.height + searchWrapper.height + padding * 3

    Text {
        id: label
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: root.padding
        text: "Save OTP as"
        color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.6)
        font.family: Config.options.launcher.fontFamily
        font.pixelSize: Config.options.launcher.fontSize
        renderType: Text.NativeRendering
    }

    SearchInput {
        id: searchWrapper
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: root.padding
        placeholder: "service/login"

        onAccepted: {
            const name = searchWrapper.text.trim();
            if (name.length > 0)
                OtpPrompt.submit(name);
        }

        textInput.Keys.onEscapePressed: OtpPrompt.cancel()

        Component.onCompleted: {
            searchWrapper.text = OtpPrompt.defaultName;
            searchWrapper.textInput.selectAll();
            forceActiveFocus();
        }

        Connections {
            target: GlobalStates
            function onOtpPromptOpenChanged() {
                if (GlobalStates.otpPromptOpen) {
                    searchWrapper.text = OtpPrompt.defaultName;
                    searchWrapper.textInput.selectAll();
                    searchWrapper.forceActiveFocus();
                } else {
                    searchWrapper.text = "";
                }
            }
        }
    }
}
