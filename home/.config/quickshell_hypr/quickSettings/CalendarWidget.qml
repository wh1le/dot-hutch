import QtQuick
import QtQuick.Layouts
import "../modules/common"
import "../modules/common/widgets"
import "../modules/common/functions"
import "../services"

ColumnLayout {
    id: root
    spacing: 4

    property int displayMonth
    property int displayYear
    Component.onCompleted: {
        displayMonth = DateTime.clock.date.getMonth();
        displayYear = DateTime.clock.date.getFullYear();
    }

    readonly property int cellSize: 26

    function daysInMonth(month, year) {
        return new Date(year, month + 1, 0).getDate();
    }

    function firstDayOfMonth(month, year) {
        var d = new Date(year, month, 1).getDay();
        return d === 0 ? 6 : d - 1;
    }

    function prevMonth() {
        if (displayMonth === 0) { displayMonth = 11; displayYear--; }
        else displayMonth--;
    }

    function nextMonth() {
        if (displayMonth === 11) { displayMonth = 0; displayYear++; }
        else displayMonth++;
    }

    function prevMonthDays() {
        let m = displayMonth === 0 ? 11 : displayMonth - 1;
        let y = displayMonth === 0 ? displayYear - 1 : displayYear;
        return daysInMonth(m, y);
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 28

        RippleButton {
            implicitWidth: 28; implicitHeight: 28
            buttonRadius: Appearance.rounding.full
            z: 10
            contentItem: MaterialSymbol {
                text: "chevron_left"; iconSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: root.prevMonth()
        }

        Item { Layout.fillWidth: true }

        StyledText {
            text: Qt.locale().standaloneMonthName(root.displayMonth) + " " + root.displayYear
            font.pixelSize: Appearance.font.pixelSize.normal
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            color: ColorUtils.applyAlpha(Appearance.colors.colOnLayer1, 0.8)
        }

        Item { Layout.fillWidth: true }

        RippleButton {
            implicitWidth: 28; implicitHeight: 28
            buttonRadius: Appearance.rounding.full
            z: 10
            contentItem: MaterialSymbol {
                text: "chevron_right"; iconSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: root.nextMonth()
        }
    }

    Grid {
        id: dayHeaders
        columns: 7
        columnSpacing: 0
        rowSpacing: 0
        Layout.fillWidth: true

        Repeater {
            model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
            Item {
                required property string modelData
                width: root.cellSize
                height: 20
                StyledText {
                    anchors.centerIn: parent
                    text: modelData
                    font.pixelSize: Appearance.font.pixelSize.smallest
                    color: Appearance.colors.colSubtext
                }
            }
        }
    }

    Grid {
        columns: 7
        columnSpacing: 0
        rowSpacing: 2
        Layout.fillWidth: true

        Repeater {
            model: 42
            Rectangle {
                required property int index
                property int offset: root.firstDayOfMonth(root.displayMonth, root.displayYear)
                property int dayNum: index - offset + 1
                property int totalDays: root.daysInMonth(root.displayMonth, root.displayYear)
                property bool isCurrentMonth: dayNum >= 1 && dayNum <= totalDays
                property bool isToday: isCurrentMonth
                    && dayNum === DateTime.clock.date.getDate()
                    && root.displayMonth === DateTime.clock.date.getMonth()
                    && root.displayYear === DateTime.clock.date.getFullYear()

                property string displayText: {
                    if (isCurrentMonth) return String(dayNum);
                    if (dayNum < 1) return String(root.prevMonthDays() + dayNum);
                    return String(dayNum - totalDays);
                }

                width: root.cellSize
                height: root.cellSize
                radius: Appearance.rounding.full
                color: isToday ? Appearance.colors.colPrimary : "transparent"

                StyledText {
                    anchors.centerIn: parent
                    text: displayText
                    font.pixelSize: Appearance.font.pixelSize.smallest
                    color: isToday ? Appearance.colors.colOnPrimary
                         : isCurrentMonth ? ColorUtils.applyAlpha(Appearance.colors.colOnLayer1, 0.7)
                         : ColorUtils.applyAlpha(Appearance.colors.colOnLayer1, 0.25)
                }
            }
        }
    }

    function _daysInMonth(month, year) { return daysInMonth(month, year); }
    function _firstDayOfMonth(month, year) { return firstDayOfMonth(month, year); }
}
