import QtQuick
import QtTest

TestCase {
    name: "QuickToggleModel"

    function toggleState(current) {
        return !current;
    }

    function test_toggle_false_to_true() {
        compare(toggleState(false), true);
    }

    function test_toggle_true_to_false() {
        compare(toggleState(true), false);
    }

    function test_default_properties() {
        var model = { name: "", icon: "", toggled: false };
        compare(model.name, "");
        compare(model.icon, "");
        verify(!model.toggled);
    }

    function test_name_property() {
        var model = { name: "Caffeine", icon: "coffee", toggled: false };
        compare(model.name, "Caffeine");
    }

    function test_icon_property() {
        var model = { name: "Night Light", icon: "nightlight", toggled: true };
        compare(model.icon, "nightlight");
    }

    function test_toggled_state_change() {
        var toggled = false;
        toggled = toggleState(toggled);
        verify(toggled);
        toggled = toggleState(toggled);
        verify(!toggled);
    }

    function test_mainAction_callback() {
        var callCount = 0;
        var action = function() { callCount++; };
        action();
        action();
        compare(callCount, 2);
    }
}
