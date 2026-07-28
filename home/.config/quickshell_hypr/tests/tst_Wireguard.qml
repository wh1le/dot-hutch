import QtQuick
import QtTest

TestCase {
    name: "Wireguard"

    function parseIpLink(text) {
        if (!text || text.trim() === "") return false;
        return text.includes("UP");
    }

    function parseMultipleInterfaces(text) {
        var lines = text.split("\n");
        for (var i = 0; i < lines.length; i++) {
            if (lines[i].includes("UP")) return true;
        }
        return false;
    }

    function test_up() {
        verify(parseIpLink("3: wg0: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420"));
    }
    function test_down() {
        verify(!parseIpLink("3: wg0: <POINTOPOINT,NOARP> mtu 1420"));
    }
    function test_empty() {
        verify(!parseIpLink(""));
    }
    function test_null() {
        verify(!parseIpLink(null));
    }
    function test_multiple_one_up() {
        var text = "3: wg0: <POINTOPOINT,NOARP> mtu 1420\n5: wg1: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420";
        verify(parseMultipleInterfaces(text));
    }
    function test_multiple_all_down() {
        var text = "3: wg0: <POINTOPOINT,NOARP> mtu 1420\n5: wg1: <POINTOPOINT,NOARP> mtu 1420";
        verify(!parseMultipleInterfaces(text));
    }
    function test_lower_up_only() {
        verify(parseIpLink("3: wg0: <POINTOPOINT,NOARP,UP,LOWER_UP>"));
    }
}
