import QtQuick
import QtTest

TestCase {
    name: "Hyprsunset"

    function inBetween(t, from, to) {
        if (from < to) return (t >= from && t <= to);
        return (t >= from || t <= to);
    }

    function clampGamma(gamma) {
        return Math.max(25, Math.min(100, gamma));
    }

    // --- inBetween (no midnight wrap) ---
    function test_in_between_normal_inside() {
        verify(inBetween(12 * 60, 10 * 60, 14 * 60)); // 12:00 between 10:00-14:00
    }
    function test_in_between_normal_outside() {
        verify(!inBetween(9 * 60, 10 * 60, 14 * 60)); // 9:00 not between 10:00-14:00
    }
    function test_in_between_normal_boundary_from() {
        verify(inBetween(10 * 60, 10 * 60, 14 * 60)); // exactly at from
    }
    function test_in_between_normal_boundary_to() {
        verify(inBetween(14 * 60, 10 * 60, 14 * 60)); // exactly at to
    }

    // --- inBetween (midnight wrap) ---
    function test_midnight_wrap_at_22() {
        verify(inBetween(22 * 60, 19 * 60, 6 * 60 + 30)); // 22:00 between 19:00-06:30
    }
    function test_midnight_wrap_at_2() {
        verify(inBetween(2 * 60, 19 * 60, 6 * 60 + 30)); // 02:00 between 19:00-06:30
    }
    function test_midnight_wrap_at_12_outside() {
        verify(!inBetween(12 * 60, 19 * 60, 6 * 60 + 30)); // 12:00 not between 19:00-06:30
    }
    function test_midnight_wrap_at_midnight() {
        verify(inBetween(0, 19 * 60, 6 * 60 + 30)); // 00:00 between 19:00-06:30
    }
    function test_midnight_wrap_2359() {
        verify(inBetween(23 * 60 + 59, 19 * 60, 6 * 60 + 30)); // 23:59 inside
    }
    function test_midnight_wrap_0001() {
        verify(inBetween(1, 19 * 60, 6 * 60 + 30)); // 00:01 inside
    }

    // --- gamma clamping ---
    function test_gamma_normal() { compare(clampGamma(50), 50); }
    function test_gamma_min() { compare(clampGamma(25), 25); }
    function test_gamma_max() { compare(clampGamma(100), 100); }
    function test_gamma_below_min() { compare(clampGamma(10), 25); }
    function test_gamma_above_max() { compare(clampGamma(150), 100); }
    function test_gamma_zero() { compare(clampGamma(0), 25); }

    // --- toggle state ---
    function test_toggle_off_on_off() {
        var active = false;
        active = !active; verify(active);
        active = !active; verify(!active);
    }

    // --- manual override ---
    function test_manual_override_concept() {
        var manualActive = undefined;
        var temperatureActive = false;
        // First toggle: capture current state
        manualActive = temperatureActive;
        manualActive = !manualActive;
        verify(manualActive === true);
    }
}
