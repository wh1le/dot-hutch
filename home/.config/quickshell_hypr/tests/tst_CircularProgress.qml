import QtQuick
import QtTest

TestCase {
    name: "CircularProgress"

    function valueToDegrees(val) {
        return val * 360;
    }

    function clampValue(val) {
        return Math.max(0, Math.min(1, val));
    }

    function secondaryArcSweep(deg, gap) {
        return -(360 - deg - 2 * gap);
    }

    // --- percent to degrees ---
    function test_0_percent() {
        compare(valueToDegrees(0), 0);
    }

    function test_50_percent() {
        compare(valueToDegrees(0.5), 180);
    }

    function test_100_percent() {
        compare(valueToDegrees(1.0), 360);
    }

    function test_25_percent() {
        compare(valueToDegrees(0.25), 90);
    }

    function test_75_percent() {
        compare(valueToDegrees(0.75), 270);
    }

    // --- clamping ---
    function test_clamp_above_100() {
        compare(clampValue(1.1), 1);
    }

    function test_clamp_below_0() {
        compare(clampValue(-0.05), 0);
    }

    function test_clamp_normal() {
        compare(clampValue(0.5), 0.5);
    }

    function test_clamp_exactly_0() {
        compare(clampValue(0), 0);
    }

    function test_clamp_exactly_1() {
        compare(clampValue(1), 1);
    }

    // --- gap angle computation ---
    function test_secondary_arc_full() {
        // 0 degrees progress, 20 gap -> secondary sweep = -(360 - 0 - 40) = -320
        compare(secondaryArcSweep(0, 20), -320);
    }

    function test_secondary_arc_half() {
        // 180 degrees, 20 gap -> -(360 - 180 - 40) = -140
        compare(secondaryArcSweep(180, 20), -140);
    }

    function test_secondary_arc_complete() {
        // 360 degrees, 20 gap -> -(360 - 360 - 40) = 40 (no secondary arc visible)
        compare(secondaryArcSweep(360, 20), 40);
    }

    function test_secondary_arc_zero_gap() {
        compare(secondaryArcSweep(90, 0), -270);
    }

    // --- line width effect on arc radius ---
    function test_arc_radius() {
        var implicitSize = 30;
        var lineWidth = 2;
        compare(implicitSize / 2 - lineWidth, 13);
    }

    function test_arc_radius_thick_line() {
        var implicitSize = 30;
        var lineWidth = 5;
        compare(implicitSize / 2 - lineWidth, 10);
    }
}
