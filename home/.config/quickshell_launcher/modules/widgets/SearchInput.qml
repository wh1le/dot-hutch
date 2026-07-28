import QtQuick
import ".."
import "../functions"

Rectangle {
    id: root

    property alias text: input.text
    property alias textInput: input
    property string placeholder: "search"
    property bool password: false

    signal accepted()
    signal textEdited()

    color: Qt.lighter(Appearance.colors.colBarBg, 1.15)
    radius: 4
    height: 32

    TextInput {
        id: input
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        verticalAlignment: TextInput.AlignVCenter
        activeFocusOnPress: true

        font.family: Config.options.launcher.fontFamily
        font.pixelSize: Config.options.launcher.fontSize
        color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.5)
        selectionColor: Appearance.m3colors.m3primary
        selectedTextColor: Appearance.m3colors.m3onPrimary
        clip: true
        echoMode: root.password ? TextInput.Password : TextInput.Normal
        passwordCharacter: "*"
        cursorVisible: false

        cursorDelegate: Rectangle {
            visible: input.activeFocus
            width: 1
            color: ColorUtils.applyAlpha(Appearance.colors.colPrimary, 0.3)
        }

        onAccepted: root.accepted()
        onTextEdited: root.textEdited()

        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: !input.text
            text: root.placeholder
            color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.15)
            font: input.font
            renderType: Text.NativeRendering
        }
    }

    function forceActiveFocus() { input.forceActiveFocus(); }
    function clear() { input.text = ""; }
}
