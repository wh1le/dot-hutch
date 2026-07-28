pragma ComponentBehavior: Bound

import QtQuick
import "../modules/common"
import "../modules/common/functions"
import "../modules/common/widgets"
import ".."
import "services"

Rectangle {
    id: root

    property bool isMenuMode: false
    readonly property int maxItems: Config.options.launcher.maxItems
    readonly property int itemHeight: Config.options.launcher.itemHeight
    readonly property int itemWidth: Config.options.launcher.itemWidth
    readonly property int padding: 10
    readonly property int listHeight: maxItems * itemHeight

    color: Appearance.colors.colBarBg
    radius: 6

    implicitWidth: itemWidth + padding * 2
    implicitHeight: listHeight + searchWrapper.height + padding * 3

    // Results list — fixed height
    Item {
        id: listWrapper
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: root.padding
        height: root.listHeight
        clip: true

        AppList {
            id: appList
            anchors.fill: parent
            search: searchWrapper.textInput
            itemHeight: root.itemHeight
            itemWidth: root.itemWidth
            isMenuMode: root.isMenuMode
        }

        // Empty state
        Text {
            anchors.centerIn: parent
            visible: appList.count === 0
            text: "no match"
            color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.3)
            font.family: Config.options.launcher.fontFamily
            font.pixelSize: Config.options.launcher.fontSize
            renderType: Text.NativeRendering
        }
    }

    SearchInput {
        id: searchWrapper
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: root.padding

        onAccepted: {
            if (appList.currentItem) {
                if (root.isMenuMode)
                    MenuMode.launch(appList.currentItem.modelData);
                else
                    Apps.launch(appList.currentItem.modelData);
            }
        }

        textInput.Keys.onUpPressed: appList.clampedIncrement()
        textInput.Keys.onDownPressed: appList.clampedDecrement()
        textInput.Keys.onEscapePressed: {
            GlobalStates.appLauncherOpen = false;
            GlobalStates.menuModeOpen = false;
        }

        textInput.Keys.onPressed: event => {
            if (event.modifiers & Qt.ControlModifier) {
                if (event.key === Qt.Key_J || event.key === Qt.Key_N) {
                    appList.clampedDecrement();
                    event.accepted = true;
                } else if (event.key === Qt.Key_K || event.key === Qt.Key_P) {
                    appList.clampedIncrement();
                    event.accepted = true;
                } else if (event.key === Qt.Key_BracketLeft) {
                    GlobalStates.appLauncherOpen = false;
                    GlobalStates.menuModeOpen = false;
                    event.accepted = true;
                }
            } else if (event.key === Qt.Key_Tab) {
                appList.clampedDecrement();
                event.accepted = true;
            } else if (event.key === Qt.Key_Backtab) {
                appList.clampedIncrement();
                event.accepted = true;
            }
        }

        Component.onCompleted: forceActiveFocus()

        Connections {
            target: GlobalStates
            function onAppLauncherOpenChanged() {
                if (GlobalStates.appLauncherOpen)
                    searchWrapper.forceActiveFocus();
                else
                    searchWrapper.text = "";
            }
            function onMenuModeOpenChanged() {
                if (GlobalStates.menuModeOpen)
                    searchWrapper.forceActiveFocus();
                else
                    searchWrapper.text = "";
            }
        }
    }
}
