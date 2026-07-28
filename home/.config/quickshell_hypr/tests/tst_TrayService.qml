import QtQuick
import QtTest

TestCase {
    name: "TrayService"

    function filterItems(items, pinnedList, filterPassive) {
        return items.filter(i => pinnedList.includes(i.id) && (!filterPassive || i.status !== "Passive"));
    }

    function invertPinBehavior(inUserList, notInUserList, invert) {
        return invert ? { pinned: notInUserList, unpinned: inUserList } : { pinned: inUserList, unpinned: notInUserList };
    }

    // --- pin/unpin ---
    function test_pin() {
        var pins = ["A"];
        if (!pins.includes("B")) pins.push("B");
        verify(pins.includes("B"));
        compare(pins.length, 2);
    }
    function test_pin_duplicate() {
        var pins = ["A"];
        if (!pins.includes("A")) pins.push("A");
        compare(pins.length, 1);
    }
    function test_unpin() {
        var pins = ["A", "B", "C"];
        pins = pins.filter(id => id !== "B");
        verify(!pins.includes("B"));
        compare(pins.length, 2);
    }

    // --- filter passive ---
    function test_filter_passive() {
        var items = [
            {id: "A", status: "Active"},
            {id: "B", status: "Passive"},
            {id: "C", status: "Active"}
        ];
        var result = filterItems(items, ["A", "B", "C"], true);
        compare(result.length, 2);
    }
    function test_filter_no_passive() {
        var items = [
            {id: "A", status: "Active"},
            {id: "B", status: "Passive"}
        ];
        var result = filterItems(items, ["A", "B"], false);
        compare(result.length, 2);
    }

    // --- invert pin ---
    function test_invert_true() {
        var result = invertPinBehavior(["in"], ["not_in"], true);
        compare(result.pinned[0], "not_in");
        compare(result.unpinned[0], "in");
    }
    function test_invert_false() {
        var result = invertPinBehavior(["in"], ["not_in"], false);
        compare(result.pinned[0], "in");
        compare(result.unpinned[0], "not_in");
    }

    // --- tooltip ---
    function test_tooltip() {
        var item = {tooltipTitle: "VPN", title: "OpenVPN", tooltipDescription: "Connected", id: "openvpn"};
        var result = item.tooltipTitle.length > 0 ? item.tooltipTitle : item.title;
        if (item.tooltipDescription.length > 0) result += " • " + item.tooltipDescription;
        compare(result, "VPN • Connected");
    }
    function test_tooltip_no_tooltip_title() {
        var item = {tooltipTitle: "", title: "OpenVPN", tooltipDescription: "", id: "openvpn"};
        var result = item.tooltipTitle.length > 0 ? item.tooltipTitle : item.title;
        compare(result, "OpenVPN");
    }

    // --- empty tray ---
    function test_empty_tray() {
        compare(filterItems([], ["A"], true).length, 0);
    }
}
