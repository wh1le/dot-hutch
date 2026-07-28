import QtQuick
import QtQuick.Layouts
import "../modules/common"
import "../modules/common/widgets"
import "../services"

Rectangle {
    id: root
    implicitHeight: weatherColumn.implicitHeight + 16
    color: Appearance.colors.colLayer2
    radius: Appearance.rounding.normal
    visible: Weather.displayText !== ""

    ColumnLayout {
        id: weatherColumn
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4

        StyledText {
            text: Weather.displayText
            font.pixelSize: Appearance.font.pixelSize.large
        }

        StyledText {
            text: Weather.tooltip
            font.pixelSize: Appearance.font.pixelSize.smallest
            color: Appearance.colors.colSubtext
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }

    // --- Testable pure JS functions ---
    function _formatTemp(celsius) {
        return `${Math.round(celsius)}°C`;
    }

    function _windDirection(degrees) {
        if (degrees < 22.5) return "N";
        if (degrees < 67.5) return "NE";
        if (degrees < 112.5) return "E";
        if (degrees < 157.5) return "SE";
        if (degrees < 202.5) return "S";
        if (degrees < 247.5) return "SW";
        if (degrees < 292.5) return "W";
        if (degrees < 337.5) return "NW";
        return "N";
    }

    function _formatHumidity(percent) {
        return `${Math.round(Math.max(0, Math.min(100, percent)))}%`;
    }
}
