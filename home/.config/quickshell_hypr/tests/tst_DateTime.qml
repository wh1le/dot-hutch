import QtQuick
import QtTest

TestCase {
    name: "DateTime"

    function formatTime(hours, minutes, use24h) {
        if (use24h) {
            return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}`;
        }
        let period = hours >= 12 ? "PM" : "AM";
        let h = hours % 12;
        if (h === 0) h = 12;
        return `${h}:${String(minutes).padStart(2, '0')} ${period}`;
    }

    // --- 24h format ---
    function test_24h_afternoon() {
        compare(formatTime(14, 30, true), "14:30");
    }

    function test_24h_morning() {
        compare(formatTime(9, 5, true), "09:05");
    }

    function test_24h_midnight() {
        compare(formatTime(0, 0, true), "00:00");
    }

    function test_24h_noon() {
        compare(formatTime(12, 0, true), "12:00");
    }

    function test_24h_end_of_day() {
        compare(formatTime(23, 59, true), "23:59");
    }

    // --- 12h format ---
    function test_12h_afternoon() {
        compare(formatTime(14, 30, false), "2:30 PM");
    }

    function test_12h_morning() {
        compare(formatTime(9, 5, false), "9:05 AM");
    }

    function test_12h_midnight() {
        compare(formatTime(0, 0, false), "12:00 AM");
    }

    function test_12h_noon() {
        compare(formatTime(12, 0, false), "12:00 PM");
    }

    function test_12h_1am() {
        compare(formatTime(1, 0, false), "1:00 AM");
    }

    function test_12h_1pm() {
        compare(formatTime(13, 0, false), "1:00 PM");
    }

    function test_12h_11pm() {
        compare(formatTime(23, 59, false), "11:59 PM");
    }
}
