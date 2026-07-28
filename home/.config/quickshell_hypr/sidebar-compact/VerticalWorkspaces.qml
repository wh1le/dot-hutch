pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Widgets
import "../modules/common"
import "../modules/common/functions"
import "../modules/common/widgets"
import "../services"
import ".."

Rectangle {
    id: root

    readonly property int activeWsId: HyprlandData.activeWorkspace?.id ?? 1
    readonly property var sortedOccupiedIds: {
        var ids = [];
        for (var i = 0; i < HyprlandData.workspaceIds.length; i++)
            ids.push(HyprlandData.workspaceIds[i]);
        var active = root.activeWsId;
        var found = false;
        for (var j = 0; j < ids.length; j++) {
            if (ids[j] === active) { found = true; break; }
        }
        if (!found) ids.push(active);
        ids.sort(function(a, b) { return a - b; });
        return ids;
    }

    property bool keyboardExpanded: false
    property bool expanded: hoverArea.containsMouse || wsExpandTimer.running || collapseDelay.running || keyboardExpanded

    IpcHandler {
        target: "sidebar"
        function show() { root.keyboardExpanded = true; }
        function hide() { root.keyboardExpanded = false; }
        function toggle() { root.keyboardExpanded = !root.keyboardExpanded; }
    }

    onExpandedChanged: {
        GlobalStates.sidebarExpanded = expanded;
        if (!expanded) {
            // Refresh cached windows when collapsing
            for (var i = 0; i < repeater.count; i++) {
                var item = repeater.itemAt(i);
                if (item) item.cachedWindows = item.pendingWindows;
            }
            // Hide tooltip
            sharedTooltip.tooltipVisible = false;
        }
    }

    // Small delay before collapsing to prevent flicker
    Timer {
        id: collapseDelay
        interval: 150
        repeat: false
    }
    Connections {
        target: hoverArea
        function onContainsMouseChanged() {
            if (!hoverArea.containsMouse && !wsExpandTimer.running)
                collapseDelay.start();
        }
    }

    // Expand briefly on workspace switch (not on initial load)
    property bool initialized: false
    property int prevActiveWsId: -1
    Component.onCompleted: {
        initTimer.start();
        iconCountTimer.triggered();
    }
    Timer {
        id: initTimer
        interval: 200
        onTriggered: {
            root.prevActiveWsId = root.activeWsId;
            root.initialized = true;
        }
    }
    onActiveWsIdChanged: {
        if (initialized && prevActiveWsId !== activeWsId) {
            prevActiveWsId = activeWsId;
            wsExpandTimer.restart();
        }
    }
    Timer {
        id: wsExpandTimer
        interval: 1500
        repeat: false
    }

    readonly property real tileWidth: 16
    readonly property real tileHeight: 20
    readonly property real iconSize: 14

    property int cachedMaxIconCount: 1
    Timer {
        id: iconCountTimer
        interval: 100
        onTriggered: {
            var max = 0;
            for (var i = 0; i < root.sortedOccupiedIds.length; i++) {
                var wins = HyprlandData.hyprlandClientsForWorkspace(root.sortedOccupiedIds[i])
                    .filter(function(w) { return !w.fullscreen; });
                if (wins.length > max) max = wins.length;
            }
            root.cachedMaxIconCount = Math.max(max, 1);
        }
    }
    onSortedOccupiedIdsChanged: if (!expanded) iconCountTimer.restart()

    readonly property real expandedWidth: 1 + tileWidth + 1 + 3 + (cachedMaxIconCount * (iconSize + 3)) + 3
    readonly property real compactWidth: 1 + tileWidth + 6

    implicitWidth: expandedWidth
    implicitHeight: layout.implicitHeight + 15
    color: "transparent"

    // Background — only covers compact or expanded visual area
    Rectangle {
        id: bg
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: expanded ? root.expandedWidth : root.compactWidth
        radius: Appearance.rounding.verysmall
        color: Appearance.colors.colBarBg
        layer.enabled: !root.expanded
        layer.effect: DropShadow {
            horizontalOffset: 3
            verticalOffset: 0
            radius: 16
            color: Qt.rgba(0, 0, 0, 0.5)
        }
    }
    // Cover left rounded corners to make them flat
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Appearance.rounding.small
        color: Appearance.colors.colBarBg
    }

    // Right-edge gradient (expanded only)
    Rectangle {
        x: bg.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 20
        radius: Appearance.rounding.verysmall
        visible: root.expanded
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.25) }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0) }
        }
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            hoverEnabled: false
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }

    StyledTooltip {
        id: sharedTooltip
    }

    // Active indicator — right of tile
    Rectangle {
        id: activeIndicator
        x: 0
        y: {
            for (var i = 0; i < repeater.count; i++) {
                var item = repeater.itemAt(i);
                if (item && item.wsId === root.activeWsId)
                    return layout.y + item.y;
            }
            return 0;
        }
        width: 2
        height: root.tileHeight
        z: 10
        color: Appearance.colors.colPrimary
        visible: {
            for (var i = 0; i < repeater.count; i++) {
                var item = repeater.itemAt(i);
                if (item && item.wsId === root.activeWsId) return true;
            }
            return false;
        }
    }

    ColumnLayout {
        id: layout
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Repeater {
            id: repeater
            model: root.sortedOccupiedIds

            Item {
                id: tile
                required property var modelData
                property int wsId: modelData
                property bool isActive: root.activeWsId === wsId

                Layout.alignment: Qt.AlignLeft
                implicitWidth: root.implicitWidth - 1
                implicitHeight: root.tileHeight

                // Cache window list to avoid Repeater rebuilds during hover
                property var cachedWindows: []
                property var pendingWindows: {
                    var all = HyprlandData.hyprlandClientsForWorkspace(tile.wsId);
                    return all.filter(function(w) { return !w.fullscreen; });
                }
                onPendingWindowsChanged: {
                    if (!root.expanded)
                        cachedWindows = pendingWindows;
                }
                Component.onCompleted: cachedWindows = pendingWindows
                onIsActiveChanged: cachedWindows = pendingWindows

                // Tile background
                Rectangle {
                    id: tileBg
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: root.tileWidth
                    radius: 0
                    color: tile.isActive
                        ? ColorUtils.lighten(Appearance.colors.colBarBg, 0.18)
                        : ColorUtils.lighten(Appearance.colors.colBarBg, 0.10)

                    Text {
                        anchors.fill: parent
                        text: tile.wsId
                        font.family: "Hack-ZeroSlash"
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        color: tile.isActive
                            ? Appearance.m3colors.m3primary
                            : ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.4)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                // App icons row — to the right of tile
                Row {
                    anchors.left: tileBg.right
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 3
                    visible: root.expanded

                    Repeater {
                        model: tile.cachedWindows

                        Item {
                            id: appIconItem
                            required property var modelData
                            width: root.iconSize
                            height: root.iconSize

                            IconImage {
                                id: appIcon
                                anchors.fill: parent
                                source: Quickshell.iconPath(AppIcons.guessIcon(appIconItem.modelData.class), "image-missing")
                                opacity: 0.65
                                layer.enabled: true
                                layer.effect: DropShadow {
                                    radius: 6
                                    color: Qt.rgba(0, 0, 0, 0.6)
                                    verticalOffset: 1
                                    horizontalOffset: 0
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: {
                                    sharedTooltip.text = appIconItem.modelData.title || appIconItem.modelData.class;
                                    sharedTooltip.targetItem = appIconItem;
                                    sharedTooltip.tooltipVisible = true;
                                }
                                onClicked: {
                                    Hyprland.dispatch("workspace " + tile.wsId);
                                    Hyprland.dispatch("focuswindow address:" + appIconItem.modelData.address);
                                }
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: tileBg
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch(`workspace ${tile.wsId}`)
                }
            }
        }
    }
}
