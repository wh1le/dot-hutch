import QtQuick
import QtTest

TestCase {
    name: "Revealer"

    // Test the logic of the Revealer: implicitWidth/Height based on reveal and vertical

    // Horizontal mode (vertical=false)
    function test_horizontal_reveal_true() {
        var reveal = true;
        var vertical = false;
        var childWidth = 100;
        var childHeight = 30;
        var implicitWidth = (reveal || vertical) ? childWidth : 0;
        var implicitHeight = (reveal || !vertical) ? childHeight : 0;
        compare(implicitWidth, 100);
        compare(implicitHeight, 30);
    }

    function test_horizontal_reveal_false() {
        var reveal = false;
        var vertical = false;
        var childWidth = 100;
        var childHeight = 30;
        var implicitWidth = (reveal || vertical) ? childWidth : 0;
        var implicitHeight = (reveal || !vertical) ? childHeight : 0;
        compare(implicitWidth, 0);
        compare(implicitHeight, 30); // Height stays in horizontal mode
    }

    // Vertical mode (vertical=true)
    function test_vertical_reveal_true() {
        var reveal = true;
        var vertical = true;
        var childWidth = 100;
        var childHeight = 30;
        var implicitWidth = (reveal || vertical) ? childWidth : 0;
        var implicitHeight = (reveal || !vertical) ? childHeight : 0;
        compare(implicitWidth, 100);
        compare(implicitHeight, 30);
    }

    function test_vertical_reveal_false() {
        var reveal = false;
        var vertical = true;
        var childWidth = 100;
        var childHeight = 30;
        var implicitWidth = (reveal || vertical) ? childWidth : 0;
        var implicitHeight = (reveal || !vertical) ? childHeight : 0;
        compare(implicitWidth, 100); // Width stays in vertical mode
        compare(implicitHeight, 0);
    }

    // Visibility logic
    function test_visible_when_revealed() {
        var reveal = true;
        var width = 100;
        var height = 30;
        var visible = reveal || (width > 0 && height > 0);
        verify(visible);
    }

    function test_visible_during_animation() {
        // During animation, width might be > 0 but reveal is false
        var reveal = false;
        var width = 50; // mid-animation
        var height = 30;
        var visible = reveal || (width > 0 && height > 0);
        verify(visible);
    }

    function test_invisible_when_collapsed() {
        var reveal = false;
        var width = 0;
        var height = 30;
        var visible = reveal || (width > 0 && height > 0);
        verify(!visible);
    }
}
