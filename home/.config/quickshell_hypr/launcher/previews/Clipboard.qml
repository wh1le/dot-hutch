import QtQuick
import Quickshell
import Quickshell.Io
import "../../modules/common"
import "../../modules/common/functions"

Item {
    id: root

    required property string rawText
    required property string entryLabel

    // Detect entry type from the cliphist label (ID\tcontent)
    readonly property string entryContent: {
        let idx = entryLabel.indexOf("\t");
        return idx !== -1 ? entryLabel.substring(idx + 1) : entryLabel;
    }
    readonly property string entryId: {
        let idx = entryLabel.indexOf("\t");
        return idx !== -1 ? entryLabel.substring(0, idx) : "";
    }

    readonly property bool isBinaryImage: entryContent.indexOf("[[ binary data") !== -1 && entryContent.indexOf("png") !== -1
    readonly property bool isFilePath: entryContent.startsWith("file://")
    readonly property string filePath: isFilePath ? decodeURIComponent(entryContent.substring(7)) : ""
    readonly property bool isImageFile: {
        if (!isFilePath) return false;
        let lower = filePath.toLowerCase();
        return lower.endsWith(".png") || lower.endsWith(".jpg") || lower.endsWith(".jpeg") ||
               lower.endsWith(".webp") || lower.endsWith(".gif") || lower.endsWith(".svg");
    }
    readonly property bool showImage: isBinaryImage || isImageFile
    readonly property bool isText: !showImage && !isFilePath

    // For binary images: decode to temp file
    readonly property string tempImagePath: "/tmp/qs-clip-preview-" + entryId + ".png"
    property string imageSource: ""

    function loadPreview() {
        if (isBinaryImage && entryId) {
            root.imageSource = "";
            decodeProcess.command = ["bash", "-c", "printf '%s' " + JSON.stringify(entryLabel) + " | cliphist decode > '" + tempImagePath + "' && echo done"];
            decodeProcess.running = true;
        } else if (isImageFile) {
            root.imageSource = "file://" + filePath;
        } else {
            root.imageSource = "";
        }
    }

    Component.onCompleted: loadPreview()
    onEntryLabelChanged: loadPreview()

    Process {
        id: decodeProcess
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim() === "done") {
                    root.imageSource = "file://" + root.tempImagePath + "?" + Date.now();
                }
            }
        }
    }

    // --- Image preview ---
    Image {
        id: imagePreview
        visible: root.showImage && root.imageSource !== ""
        anchors.fill: parent
        source: root.imageSource
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        cache: false
    }

    // --- File info (non-image files) ---
    Column {
        visible: root.isFilePath && !root.isImageFile
        anchors.fill: parent
        spacing: 4

        Text {
            text: root.filePath.split("/").pop() || "file"
            font.family: Config.options.launcher.fontFamily
            font.pixelSize: 12
            font.bold: true
            color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.5)
            elide: Text.ElideMiddle
            width: parent.width
            renderType: Text.NativeRendering
        }
        Text {
            text: root.filePath
            font.family: Config.options.appearance.fonts.monospace
            font.pixelSize: 10
            color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.2)
            elide: Text.ElideMiddle
            width: parent.width
            renderType: Text.NativeRendering
        }
    }

    // --- Binary image info label ---
    Text {
        visible: root.isBinaryImage && root.imageSource === ""
        anchors.centerIn: parent
        text: "decoding image..."
        font.family: Config.options.launcher.fontFamily
        font.pixelSize: 10
        color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.2)
        renderType: Text.NativeRendering
    }

    // --- Text preview ---
    Item {
        visible: root.isText
        anchors.fill: parent

        readonly property int charCount: root.rawText ? root.rawText.trim().length : 0

        // Size bar + char count
        Item {
            id: sizeRow
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 14

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - charLabel.width - 8
                height: 3
                radius: 1.5
                color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.06)

                Rectangle {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * Math.min(1.0, Math.log(1 + parent.parent.parent.charCount) / Math.log(5001))
                    height: 3
                    radius: 1.5
                    color: ColorUtils.applyAlpha(Appearance.colors.colPrimary, 0.4)
                }
            }

            Text {
                id: charLabel
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: parent.parent.charCount + " chars"
                font.family: Config.options.launcher.fontFamily
                font.pixelSize: 9
                color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.25)
                renderType: Text.NativeRendering
            }
        }

        Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: sizeRow.bottom
            anchors.topMargin: 6
            anchors.bottom: parent.bottom
            text: root.rawText ? root.rawText.trim() : ""
            font.family: Config.options.appearance.fonts.monospace
            font.pixelSize: 11
            color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.2)
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: 7
            renderType: Text.NativeRendering
            lineHeight: 1.3
        }
    }
}
