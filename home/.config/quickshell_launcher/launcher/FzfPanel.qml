pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "../modules"
import "../modules/functions"
import ".."
import "../services"
import "services"
import "previews"

Rectangle {
    id: root

    readonly property int listWidth: Config.options.launcher.itemWidth
    readonly property int maxItems: Config.options.launcher.maxItems
    readonly property int itemHeight: Config.options.launcher.itemHeight
    readonly property int padding: 10
    readonly property int listHeight: maxItems * itemHeight
    readonly property bool hasPreview: FzfSource.activeItem && (FzfSource.activeItem.preview || root.previewFormat === "image")
    readonly property int previewHeight: hasPreview ? 160 : 0

    // Action menu state
    property bool actionMenuOpen: false
    property var actionMenuActions: []
    property string actionMenuLabel: ""
    property string actionMenuScript: ""

    color: Appearance.colors.colBarBg
    radius: 6

    implicitWidth: listWidth + padding * 2
    implicitHeight: previewHeight + listHeight + searchWrapper.height + padding * (hasPreview ? 4 : 3)

    readonly property string previewFormat: (FzfSource.activeItem && FzfSource.activeItem.previewFormat) || ""

    // --- Top: preview pane ---
    Item {
        id: previewWrapper
        visible: root.hasPreview
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: root.padding
        height: root.previewHeight

        Loader {
            anchors.fill: parent
            active: FzfSource.currentPreviewRaw !== "" || root.previewFormat === "image"
            sourceComponent: {
                if (root.previewFormat === "nix-json") return nixPackagePreview;
                if (root.previewFormat === "image") return imagePreview;
                if (root.previewFormat === "clipboard") return clipboardPreview;
                return clipboardPreview; // fallback: raw text
            }
        }

        // Loading preview
        Text {
            anchors.centerIn: parent
            visible: FzfSource.currentItem && FzfSource.currentPreviewRaw === "" && !FzfSource.loading && root.previewFormat !== "image"
            text: "loading preview..."
            color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.2)
            font.family: Config.options.launcher.fontFamily
            font.pixelSize: Config.options.launcher.fontSize
            renderType: Text.NativeRendering
        }
    }

    Component {
        id: nixPackagePreview
        NixPackage {
            rawText: FzfSource.currentPreviewRaw
            activeItem: FzfSource.activeItem
        }
    }

    Component {
        id: clipboardPreview
        Clipboard {
            rawText: FzfSource.currentPreviewRaw
            entryLabel: FzfSource.currentItem ? FzfSource.currentItem.label : ""
        }
    }

    Component {
        id: imagePreview
        ImagePreview {
            rawText: FzfSource.currentPreviewRaw
        }
    }

    // --- Separator ---
    Rectangle {
        id: separator
        visible: root.hasPreview
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: root.padding
        anchors.rightMargin: root.padding
        anchors.top: previewWrapper.bottom
        anchors.topMargin: root.padding
        height: 1
        color: ColorUtils.applyAlpha(Appearance.colors.colPrimary, 0.15)
    }

    // --- Result count ---
    Text {
        anchors.left: parent.left
        anchors.leftMargin: root.padding + 12
        anchors.top: root.hasPreview ? separator.bottom : parent.top
        anchors.topMargin: 4
        visible: FzfSource.ready && !FzfSource.loading && listView.count > 0
        text: listView.count + " results"
        color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.2)
        font.family: Config.options.launcher.fontFamily
        font.pixelSize: 10
        renderType: Text.NativeRendering
        z: 2
    }

    // --- List ---
    Item {
        id: listWrapper
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: root.hasPreview ? separator.bottom : parent.top
        anchors.topMargin: root.padding
        anchors.margins: root.padding
        height: root.listHeight
        clip: true

        ListView {
            id: listView
            anchors.fill: parent

            model: FzfSource.results
            spacing: 0
            orientation: Qt.Vertical
            verticalLayoutDirection: ListView.BottomToTop
            clip: true
            interactive: false
            highlightMoveDuration: 0
            highlightFollowsCurrentItem: true

            onModelChanged: currentIndex = 0
            onCurrentIndexChanged: {
                if (currentIndex >= 0 && currentIndex < model.length) {
                    FzfSource.currentItem = model[currentIndex];
                }
            }

            Rectangle {
                visible: listView.count > 0 && listView.contentHeight > listView.height
                anchors.right: parent.right
                width: 3
                radius: 1.5
                color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.15)
                property real progress: listView.count > 0 ? listView.currentIndex / (listView.count - 1) : 0
                property real trackHeight: listView.height
                property real thumbHeight: Math.max(20, trackHeight * (trackHeight / listView.contentHeight))
                y: (1 - progress) * (trackHeight - thumbHeight)
                height: thumbHeight
            }

            function clampedIncrement() {
                if (currentIndex < count - 1) incrementCurrentIndex();
            }
            function clampedDecrement() {
                if (currentIndex > 0) decrementCurrentIndex();
            }

            delegate: Item {
                id: delegateRoot
                required property var modelData
                required property int index
                height: root.itemHeight
                implicitHeight: root.itemHeight
                anchors.left: parent?.left
                anchors.right: parent?.right
                property bool selected: index === listView.currentIndex

                Rectangle {
                    anchors.fill: parent
                    anchors.rightMargin: 6
                    color: ColorUtils.applyAlpha(Appearance.colors.colPrimary, 0.1)
                    visible: delegateRoot.selected
                }
                Rectangle {
                    width: 3; height: parent.height
                    color: Appearance.colors.colPrimary
                    visible: delegateRoot.selected
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    text: root.formatLabel(delegateRoot.modelData?.label ?? "")
                    font.family: Config.options.launcher.fontFamily
                    font.pixelSize: Config.options.launcher.fontSize
                    color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, delegateRoot.selected ? 1.0 : 0.5)
                    elide: Text.ElideRight
                    renderType: Text.NativeRendering
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: { listView.currentIndex = index; root.acceptCurrent(); }
                }
            }
        }

        Text {
            anchors.centerIn: parent
            visible: FzfSource.loading
            text: "loading..."
            color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.3)
            font.family: Config.options.launcher.fontFamily
            font.pixelSize: Config.options.launcher.fontSize
            renderType: Text.NativeRendering
        }

        Text {
            anchors.centerIn: parent
            visible: !FzfSource.loading && listView.count === 0 && FzfSource.ready
            text: FzfSource.searchText ? "no match" : "type to search..."
            color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.3)
            font.family: Config.options.launcher.fontFamily
            font.pixelSize: Config.options.launcher.fontSize
            renderType: Text.NativeRendering
        }
    }

    // --- Search bar ---
    Rectangle {
        id: searchWrapper
        color: Qt.lighter(Appearance.colors.colBarBg, 1.15)
        radius: 4
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: root.padding
        height: 32

        TextInput {
            id: search
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            verticalAlignment: TextInput.AlignVCenter
            font.family: Config.options.launcher.fontFamily
            font.pixelSize: Config.options.launcher.fontSize
            color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.5)
            selectionColor: Appearance.m3colors.m3primary
            selectedTextColor: Appearance.m3colors.m3onPrimary
            clip: true
            cursorVisible: false

            cursorDelegate: Rectangle {
                visible: search.activeFocus
                width: 1
                color: ColorUtils.applyAlpha(Appearance.colors.colPrimary, 0.3)
            }

            onTextChanged: FzfSource.searchText = text
            onAccepted: root.acceptCurrent()
            Keys.onUpPressed: listView.clampedIncrement()
            Keys.onDownPressed: listView.clampedDecrement()
            Keys.onEscapePressed: GlobalStates.fzfPanelOpen = false

            Keys.onPressed: event => {
                if (event.modifiers & Qt.ControlModifier) {
                    if (event.key === Qt.Key_A) { root.openActionMenu(); event.accepted = true; }
                    else if (event.key === Qt.Key_J || event.key === Qt.Key_N) { listView.clampedDecrement(); event.accepted = true; }
                    else if (event.key === Qt.Key_K || event.key === Qt.Key_P) { listView.clampedIncrement(); event.accepted = true; }
                    else if (event.key === Qt.Key_BracketLeft) { GlobalStates.fzfPanelOpen = false; event.accepted = true; }
                } else if (event.key === Qt.Key_Tab) { listView.clampedDecrement(); event.accepted = true; }
                else if (event.key === Qt.Key_Backtab) { listView.clampedIncrement(); event.accepted = true; }
            }

            Component.onCompleted: forceActiveFocus()

            Connections {
                target: GlobalStates
                function onFzfPanelOpenChanged() {
                    if (GlobalStates.fzfPanelOpen) search.forceActiveFocus();
                    else search.text = "";
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                visible: !search.text
                text: "search"
                color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.15)
                font: search.font
                renderType: Text.NativeRendering
            }
        }
    }

    function formatLabel(label) {
        if (!label) return "";
        // For bookmark-like formats: show only title before " | url"
        if (root.previewFormat === "bookmark" || root.previewFormat === "image") {
            let sepIdx = label.lastIndexOf(" | ");
            if (sepIdx !== -1) return label.substring(0, sepIdx);
        }
        // For clipboard: strip "ID\t" prefix
        if (root.previewFormat === "clipboard") {
            let idx = label.indexOf("\t");
            if (idx !== -1) {
                let content = label.substring(idx + 1);
                // Clean up file paths for display
                if (content.startsWith("file://"))
                    return content.substring(7).split("/").pop();
                return content;
            }
        }
        return label;
    }

    function acceptCurrent() {
        if (listView.currentIndex < 0 || listView.currentIndex >= FzfSource.results.length) return;
        let item = FzfSource.results[listView.currentIndex];
        if (!item) return;

        let label = item.label;
        let ai = FzfSource.activeItem;
        let handler = ai ? (ai.handler || "") : "";

        // Script-based source: call "handler select <label>"
        if (handler) {
            GlobalStates.fzfPanelOpen = false;
            Quickshell.execDetached(["bash", "-c", handler + " select \"$1\"", "--", label]);
            return;
        }

        // Default: copy label to clipboard via copyq
        GlobalStates.fzfPanelOpen = false;
        Quickshell.execDetached(["copyq", "copy", label]);
        SoundService.play("completion-partial");
    }

    function openActionMenu() {
        if (listView.currentIndex < 0 || listView.currentIndex >= FzfSource.results.length) return;
        let ai = FzfSource.activeItem;
        let handler = ai ? (ai.handler || "") : "";
        if (!handler) { console.log("[FzfPanel] no handler for actions"); return; }

        root.actionMenuLabel = FzfSource.results[listView.currentIndex].label;
        root.actionMenuScript = handler;

        actionNamesProcess.running = false;
        actionNamesProcess.command = ["bash", "-c", handler + " actions"];
        actionNamesProcess.running = true;
    }

    function runAction(actionName, label) {
        root.actionMenuOpen = false;
        GlobalStates.fzfPanelOpen = false;
        Quickshell.execDetached(["bash", "-c", root.actionMenuScript + " action \"$1\" \"$2\"", "--", actionName, label]);
    }

    // Action menu overlay
    Rectangle {
        id: actionMenu
        visible: root.actionMenuOpen
        focus: root.actionMenuOpen
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: root.padding
        height: actionCol.implicitHeight + root.padding * 2
        radius: 4
        color: Qt.lighter(Appearance.colors.colBarBg, 1.15)
        z: 50

        Column {
            id: actionCol
            anchors.fill: parent
            anchors.margins: root.padding
            spacing: 0

            Repeater {
                model: root.actionMenuActions

                Item {
                    width: actionCol.width
                    height: root.itemHeight
                    required property var modelData
                    required property int index
                    property bool selected: index === actionListView.currentIndex

                    Rectangle {
                        anchors.fill: parent
                        color: parent.selected ? ColorUtils.applyAlpha(Appearance.colors.colPrimary, 0.1) : "transparent"
                    }
                    Rectangle {
                        width: 3; height: parent.height
                        color: Appearance.colors.colPrimary
                        visible: parent.selected
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        text: modelData
                        font.family: Config.options.launcher.fontFamily
                        font.pixelSize: Config.options.launcher.fontSize
                        color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, parent.selected ? 1.0 : 0.5)
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.runAction(modelData, root.actionMenuLabel)
                    }
                }
            }
        }

        // Invisible focus handler for action menu keyboard nav
        Item {
            id: actionListView
            property int currentIndex: 0
            visible: false
            function up() { if (currentIndex > 0) currentIndex--; }
            function down() { if (currentIndex < root.actionMenuActions.length - 1) currentIndex++; }
        }

        Keys.enabled: root.actionMenuOpen
        Keys.onUpPressed: actionListView.up()
        Keys.onDownPressed: actionListView.down()
        Keys.onReturnPressed: root.acceptAction()
        Keys.onEscapePressed: root.actionMenuOpen = false
        Keys.onPressed: event => {
            if (event.modifiers & Qt.ControlModifier) {
                if (event.key === Qt.Key_J || event.key === Qt.Key_N) { actionListView.down(); event.accepted = true; }
                else if (event.key === Qt.Key_K || event.key === Qt.Key_P) { actionListView.up(); event.accepted = true; }
                else if (event.key === Qt.Key_BracketLeft) { root.actionMenuOpen = false; event.accepted = true; }
            } else if (event.key === Qt.Key_Tab) { actionListView.down(); event.accepted = true; }
            else if (event.key === Qt.Key_Backtab) { actionListView.up(); event.accepted = true; }
        }

        onVisibleChanged: {
            if (visible) {
                actionListView.currentIndex = 0;
                forceActiveFocus();
            } else {
                search.forceActiveFocus();
            }
        }
    }

    function acceptAction() {
        if (actionListView.currentIndex >= 0 && actionListView.currentIndex < root.actionMenuActions.length)
            root.runAction(root.actionMenuActions[actionListView.currentIndex], root.actionMenuLabel);
    }

    Process {
        id: actionNamesProcess
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                root.actionMenuActions = text.trim().split("\n").filter(s => s.length > 0);
                if (root.actionMenuActions.length > 0)
                    root.actionMenuOpen = true;
            }
        }
    }
}
