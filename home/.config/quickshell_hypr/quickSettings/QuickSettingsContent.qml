import QtQuick
import QtQuick.Layouts
import "../modules/common"
import "../modules/common/widgets"
import "quickToggles"

Rectangle {
    id: root
    implicitHeight: mainColumn.implicitHeight + 24
    color: Appearance.colors.colLayer1
    radius: Appearance.rounding.large

    ColumnLayout {
        id: mainColumn
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Quick toggles grid
        QuickToggleGrid {}

        // Volume/mic sliders
        QuickSliders {}

        // Calendar
        CalendarWidget {}

        // Weather
        WeatherCard {}

        // Notifications
        NotificationList {}
    }
}
