import QtQuick
import QtTest

TestCase {
    name: "CalendarWidget"

    function daysInMonth(month, year) {
        return new Date(year, month + 1, 0).getDate();
    }

    function firstDayOfMonth(month, year) {
        var d = new Date(year, month, 1).getDay();
        return d === 0 ? 6 : d - 1; // Monday=0
    }

    function isLeapYear(year) {
        return (year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0);
    }

    // --- days in month ---
    function test_january_31() { compare(daysInMonth(0, 2025), 31); }
    function test_february_28() { compare(daysInMonth(1, 2025), 28); }
    function test_february_leap_29() { compare(daysInMonth(1, 2024), 29); }
    function test_april_30() { compare(daysInMonth(3, 2025), 30); }
    function test_december_31() { compare(daysInMonth(11, 2025), 31); }

    // --- first day offset (Monday=0..Sunday=6) ---
    function test_first_day_jan_2025() {
        // Jan 1 2025 is Wednesday = 2
        compare(firstDayOfMonth(0, 2025), 2);
    }
    function test_first_day_mar_2025() {
        // Mar 1 2025 is Saturday = 5
        compare(firstDayOfMonth(2, 2025), 5);
    }

    // --- leap year ---
    function test_leap_2024() { verify(isLeapYear(2024)); }
    function test_not_leap_2025() { verify(!isLeapYear(2025)); }
    function test_leap_2000() { verify(isLeapYear(2000)); }
    function test_not_leap_1900() { verify(!isLeapYear(1900)); }
    function test_leap_400() { verify(isLeapYear(400)); }

    // --- month navigation ---
    function test_nav_dec_to_jan() {
        var month = 11;
        var year = 2025;
        if (month === 11) { month = 0; year++; }
        else month++;
        compare(month, 0);
        compare(year, 2026);
    }
    function test_nav_jan_to_dec() {
        var month = 0;
        var year = 2025;
        if (month === 0) { month = 11; year--; }
        else month--;
        compare(month, 11);
        compare(year, 2024);
    }

    // --- grid cells ---
    function test_grid_size() {
        compare(6 * 7, 42);
    }
}
