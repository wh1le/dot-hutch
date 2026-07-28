import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

Item {
    id: root
    property var services: SystemdServices.services
    property bool anyActive: {
        for (let i = 0; i < services.length; i++) {
            let s = SystemdServices.statuses[services[i].name];
            if (s && s.active === "active") return true;
        }
        return false;
    }
    property bool menuOpen: false

    visible: services.length > 0
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    BarIcon {
        id: icon
        text: "shield"
        active: root.anyActive
        activeColor: Appearance.m3colors.m3success
        onLeftClicked: root.menuOpen = !root.menuOpen
    }

    // Close menu on workspace change
    Connections {
        target: HyprlandData
        function onActiveWorkspaceChanged() { root.menuOpen = false; }
    }

    Loader {
        id: menuLoader
        active: root.menuOpen
        sourceComponent: Item {
            id: menuPopup
            parent: root.QsWindow.contentItem
            z: 100

            x: {
                let pos = root.mapToItem(parent, root.width / 2, 0);
                return pos.x - menuBg.width / 2;
            }
            y: {
                let pos = root.mapToItem(parent, 0, root.height);
                return pos.y + 4;
            }
            width: menuBg.width
            height: menuBg.height

            Rectangle {
                id: menuBg
                property real pad: 4
                width: stackView.implicitWidth + pad * 2
                height: stackView.implicitHeight + pad * 2
                color: Appearance.colors.colBarBg ?? Appearance.colors.colLayer0
                radius: Appearance.rounding.verysmall
                border.width: 1
                border.color: Appearance.colors.colOutlineVariant

                StackView {
                    id: stackView
                    anchors.fill: parent
                    anchors.margins: menuBg.pad
                    implicitWidth: currentItem ? currentItem.implicitWidth : 100
                    implicitHeight: currentItem ? currentItem.implicitHeight : 50

                    pushEnter: Transition { NumberAnimation { duration: 0 } }
                    pushExit: Transition { NumberAnimation { duration: 0 } }
                    popEnter: Transition { NumberAnimation { duration: 0 } }
                    popExit: Transition { NumberAnimation { duration: 0 } }

                    initialItem: serviceListComponent
                }
            }

            // Service list (main view)
            Component {
                id: serviceListComponent
                ColumnLayout {
                    spacing: 0
                    Repeater {
                        model: root.services
                        delegate: Rectangle {
                            id: svcItem
                            required property var modelData
                            required property int index
                            property string svcName: modelData.name
                            property bool isUser: modelData.user ?? false
                            property var status: SystemdServices.statuses[svcName] ?? null
                            property bool isActive: status ? status.active === "active" : false

                            Layout.fillWidth: true
                            implicitWidth: svcRow.implicitWidth + 12
                            implicitHeight: 22
                            radius: Appearance.rounding.verysmall - menuBg.pad
                            color: svcMa.containsMouse ? (Appearance.colors.colLayer1Hover ?? "#ffffff20") : "transparent"

                            RowLayout {
                                id: svcRow
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.leftMargin: 6
                                anchors.rightMargin: 6
                                spacing: 6

                                Rectangle {
                                    width: 6; height: 6; radius: 3
                                    color: svcItem.isActive ? Appearance.m3colors.m3success : "transparent"
                                    border.width: svcItem.isActive ? 0 : 1
                                    border.color: Appearance.colors.colSubtext
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: svcItem.svcName
                                    font.family: "Hack"
                                    font.pixelSize: 11
                                    font.hintingPreference: Font.PreferFullHinting
                                    color: Appearance.m3colors.m3onSurfaceVariant
                                    renderType: Text.NativeRendering
                                }
                                Text {
                                    text: "›"
                                    font.pixelSize: 12
                                    color: Appearance.m3colors.m3onSurfaceVariant
                                    renderType: Text.NativeRendering
                                }
                            }

                            MouseArea {
                                id: svcMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    stackView.push(detailComponent.createObject(null, {
                                        svcName: svcItem.svcName,
                                        isUser: svcItem.isUser
                                    }));
                                }
                            }
                        }
                    }
                }
            }

            // Detail/actions view (submenu)
            Component {
                id: detailComponent
                ColumnLayout {
                    id: detailView
                    property string svcName: ""
                    property bool isUser: false
                    property var status: SystemdServices.statuses[svcName] ?? null
                    property bool isActive: status ? status.active === "active" : false
                    spacing: 0

                    // Back button
                    Rectangle {
                        Layout.fillWidth: true
                        implicitWidth: backRow.implicitWidth + 12
                        implicitHeight: 22
                        radius: Appearance.rounding.verysmall - menuBg.pad
                        color: backMa.containsMouse ? (Appearance.colors.colLayer1Hover ?? "#ffffff20") : "transparent"

                        RowLayout {
                            id: backRow
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 6
                            anchors.rightMargin: 6
                            spacing: 4
                            Text {
                                text: "‹"
                                font.pixelSize: 12
                                color: Appearance.m3colors.m3onSurfaceVariant
                                renderType: Text.NativeRendering
                            }
                            Text {
                                Layout.fillWidth: true
                                text: detailView.svcName
                                font.family: "Hack"
                                font.pixelSize: 11
                                font.weight: Font.Bold
                                color: Appearance.m3colors.m3onSurfaceVariant
                                renderType: Text.NativeRendering
                            }
                            Rectangle {
                                width: 6; height: 6; radius: 3
                                color: detailView.isActive ? Appearance.m3colors.m3success : "transparent"
                                border.width: detailView.isActive ? 0 : 1
                                border.color: Appearance.colors.colSubtext
                            }
                        }

                        MouseArea {
                            id: backMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: stackView.pop()
                        }
                    }

                    // Status info
                    Text {
                        Layout.leftMargin: 6
                        Layout.topMargin: 4
                        text: {
                            let s = detailView.status;
                            if (!s) return "polling...";
                            return s.active + " (" + s.sub + ")";
                        }
                        font.family: "Hack"
                        font.pixelSize: 9
                        color: Appearance.colors.colSubtext
                        renderType: Text.NativeRendering
                    }

                    // Actions
                    Repeater {
                        model: [
                            { action: "start", icon: "play_arrow", label: "Start", color: Appearance.m3colors.m3success },
                            { action: "stop", icon: "stop", label: "Stop", color: Appearance.m3colors.m3error },
                            { action: "restart", icon: "refresh", label: "Restart", color: Appearance.m3colors.m3onSurfaceVariant }
                        ]
                        delegate: Rectangle {
                            id: actionItem
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.topMargin: index === 0 ? 4 : 0
                            implicitWidth: actionRow.implicitWidth + 12
                            implicitHeight: 22
                            radius: Appearance.rounding.verysmall - menuBg.pad
                            color: actionMa.containsMouse ? (Appearance.colors.colLayer1Hover ?? "#ffffff20") : "transparent"

                            RowLayout {
                                id: actionRow
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.leftMargin: 6
                                anchors.rightMargin: 6
                                spacing: 6

                                MaterialSymbol {
                                    text: actionItem.modelData.icon
                                    iconSize: 12
                                    color: actionItem.modelData.color
                                    opacity: 0.7
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: actionItem.modelData.label
                                    font.family: "Hack"
                                    font.pixelSize: 11
                                    color: Appearance.m3colors.m3onSurfaceVariant
                                    renderType: Text.NativeRendering
                                }
                            }

                            MouseArea {
                                id: actionMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    let cmd = ["systemctl"];
                                    if (detailView.isUser) cmd.push("--user");
                                    cmd.push(actionItem.modelData.action, detailView.svcName);
                                    Quickshell.execDetached(cmd);
                                    SystemdServices.pollService(detailView.svcName, detailView.isUser);
                                    root.menuOpen = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
