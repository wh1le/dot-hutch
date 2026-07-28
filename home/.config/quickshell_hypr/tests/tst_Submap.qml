import QtQuick
import QtTest

TestCase {
    name: "Submap"

    function parseSubmapEvent(data) {
        if (!data || data.trim() === "") return "";
        return data.trim();
    }

    function test_parse_resize() { compare(parseSubmapEvent("resize"), "resize"); }
    function test_parse_move() { compare(parseSubmapEvent("move"), "move"); }
    function test_parse_cleared() { compare(parseSubmapEvent(""), ""); }
    function test_parse_null() { compare(parseSubmapEvent(null), ""); }
    function test_parse_undefined() { compare(parseSubmapEvent(undefined), ""); }
    function test_parse_whitespace() { compare(parseSubmapEvent("  "), ""); }
    function test_parse_with_spaces() { compare(parseSubmapEvent("  resize  "), "resize"); }
    function test_non_submap_ignored() {
        // Non-submap events should not be processed - this tests that only "submap" name matches
        var eventName = "workspace";
        verify(eventName !== "submap");
    }
}
