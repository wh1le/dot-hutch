pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import Quickshell
import "../modules/common"
import "../modules/common/functions"
import ".."
import "items"
import "services"

ListView {
    id: root

    required property TextInput search
    required property int itemHeight
    required property int itemWidth
    property bool isMenuMode: false

    model: isMenuMode ? MenuMode.results : Apps.results
    onModelChanged: currentIndex = 0

    spacing: 0
    orientation: Qt.Vertical
    verticalLayoutDirection: ListView.BottomToTop
    clip: true
    interactive: false
    highlightMoveDuration: 0
    highlightFollowsCurrentItem: true

    // Scroll position indicator
    Rectangle {
        visible: root.count > 0 && root.contentHeight > root.height
        anchors.right: parent.right
        width: 3
        radius: 1.5
        color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.15)

        property real progress: root.count > 0 ? root.currentIndex / (root.count - 1) : 0
        property real trackHeight: root.height
        property real thumbHeight: Math.max(20, trackHeight * (trackHeight / root.contentHeight))

        // BottomToTop: index 0 is bottom, so invert progress
        y: (1 - progress) * (trackHeight - thumbHeight)
        height: thumbHeight
    }

    // Clamp selection to valid range
    function clampedIncrement() {
        if (currentIndex < count - 1)
            incrementCurrentIndex();
    }
    function clampedDecrement() {
        if (currentIndex > 0)
            decrementCurrentIndex();
    }

    delegate: AppItem {
        required property var modelData
        required property int index
        entry: modelData
        selected: index === root.currentIndex
        rowHeight: root.itemHeight
        isMenuMode: root.isMenuMode
    }

    Connections {
        target: root.search
        function onTextChanged() {
            if (root.isMenuMode)
                MenuMode.searchText = root.search.text;
            else
                Apps.searchText = root.search.text;
        }
    }
}
