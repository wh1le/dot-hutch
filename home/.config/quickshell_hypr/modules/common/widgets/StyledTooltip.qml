import QtQuick
import Quickshell
import Quickshell.Widgets
import ".."

PopupWindow {
    id: popup
    property Item targetItem: null
    property string text: ""
    property bool tooltipVisible: false

    property bool showInternal: false
    property real tooltipOpacity: showInternal ? 1 : 0

    onTooltipVisibleChanged: {
        if (tooltipVisible) {
            showTimer.restart();
        } else {
            hideTimer.restart();
        }
    }

    // Delay before showing
    Timer {
        id: showTimer
        interval: 300
        onTriggered: popup.showInternal = true
    }

    // Delay before hiding — keeps tooltip alive while hovered
    Timer {
        id: hideTimer
        interval: 200
        onTriggered: {
            if (!popup.tooltipVisible)
                popup.showInternal = false;
        }
    }

    Behavior on tooltipOpacity {
        NumberAnimation {
            duration: 150
            easing.type: popup.showInternal ? Easing.InQuart : Easing.OutQuart
        }
    }

    color: "transparent"
    visible: tooltipOpacity != 0

    anchor {
        window: targetItem ? targetItem.QsWindow.window : null
        adjustment: PopupAdjustment.None
        gravity: Edges.Bottom
        onAnchoring: {
            if (!targetItem) return;
            // Position below target, centered horizontally
            var pos = targetItem.QsWindow.contentItem.mapFromItem(
                targetItem,
                targetItem.width / 2 - popup.width / 2,
                targetItem.height + 6
            );
            anchor.rect.x = pos.x;
            anchor.rect.y = pos.y;
        }
    }

    implicitWidth: tooltipBg.implicitWidth
    implicitHeight: tooltipBg.implicitHeight

    Rectangle {
        id: tooltipBg
        implicitWidth: tooltipText.implicitWidth + 12
        implicitHeight: tooltipText.implicitHeight + 6
        radius: 4
        color: Appearance.colors.colBarBg
        border.color: Appearance.colors.colOutlineVariant
        border.width: 1
        opacity: popup.tooltipOpacity

        Text {
            id: tooltipText
            anchors.centerIn: parent
            text: popup.text
            color: Appearance.colors.colOnLayer0
            font.family: "Hack"
            font.pixelSize: 10
        }
    }
}
