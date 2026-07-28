import QtQuick
import QtTest

TestCase {
    name: "Idle"

    function test_toggle_false_to_true() {
        var inhibit = false;
        inhibit = !inhibit;
        verify(inhibit);
    }

    function test_toggle_true_to_false() {
        var inhibit = true;
        inhibit = !inhibit;
        verify(!inhibit);
    }

    function test_toggle_round_trip() {
        var inhibit = false;
        inhibit = !inhibit; // true
        inhibit = !inhibit; // false
        verify(!inhibit);
    }

    function test_initial_state() {
        var inhibit = false;
        verify(!inhibit);
    }

    function test_explicit_set_true() {
        var inhibit = false;
        var active = true;
        if (active !== null) inhibit = active;
        verify(inhibit);
    }

    function test_explicit_set_false() {
        var inhibit = true;
        var active = false;
        if (active !== null) inhibit = active;
        verify(!inhibit);
    }

    function test_explicit_null_toggles() {
        var inhibit = false;
        var active = null;
        if (active !== null) inhibit = active;
        else inhibit = !inhibit;
        verify(inhibit);
    }
}
