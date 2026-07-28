pragma Singleton
pragma ComponentBehavior: Bound
import "../modules/common"
import QtQuick
import Quickshell

Singleton {
    property var clock: SystemClock {
        id: clock
        precision: Config.options?.time.secondPrecision ? SystemClock.Seconds : SystemClock.Minutes
    }
    property string time: Qt.locale().toString(clock.date, Config.options?.time.format ?? "HH:mm")
    property string shortDate: Qt.locale().toString(clock.date, Config.options?.time.shortDateFormat ?? "dd/MM")
    property string date: Qt.locale().toString(clock.date, Config.options?.time.dateWithYearFormat ?? "dd/MM/yyyy")
    property string longDate: Qt.locale().toString(clock.date, Config.options?.time.dateFormat ?? "ddd, dd/MM")
    property string collapsedCalendarFormat: Qt.locale().toString(clock.date, "dddd, MMMM dd")

    // --- Testable pure JS functions ---
    function _formatTime(hours, minutes, use24h) {
        if (use24h) {
            return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}`;
        }
        let period = hours >= 12 ? "PM" : "AM";
        let h = hours % 12;
        if (h === 0) h = 12;
        return `${h}:${String(minutes).padStart(2, '0')} ${period}`;
    }
}
