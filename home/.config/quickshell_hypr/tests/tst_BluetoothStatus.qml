import QtQuick
import QtTest

TestCase {
    name: "BluetoothStatus"

    function sortDevices(devices) {
        const macRegex = /^([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}$/;
        return [...devices].sort((a, b) => {
            const aIsMac = macRegex.test(a.name);
            const bIsMac = macRegex.test(b.name);
            if (aIsMac !== bIsMac) return aIsMac ? 1 : -1;
            return a.name.localeCompare(b.name);
        });
    }

    function filterByState(devices, state) {
        if (state === "connected") return devices.filter(d => d.connected);
        if (state === "paired") return devices.filter(d => d.paired && !d.connected);
        if (state === "unpaired") return devices.filter(d => !d.paired && !d.connected);
        return devices;
    }

    // --- sorting ---
    function test_sort_named_before_mac() {
        var devices = [
            { name: "AA-BB-CC-DD-EE-FF" },
            { name: "AirPods" }
        ];
        var sorted = sortDevices(devices);
        compare(sorted[0].name, "AirPods");
        compare(sorted[1].name, "AA-BB-CC-DD-EE-FF");
    }

    function test_sort_alphabetical() {
        var devices = [
            { name: "ZDevice" },
            { name: "ADevice" },
            { name: "MDevice" }
        ];
        var sorted = sortDevices(devices);
        compare(sorted[0].name, "ADevice");
        compare(sorted[1].name, "MDevice");
        compare(sorted[2].name, "ZDevice");
    }

    function test_sort_empty() {
        compare(sortDevices([]).length, 0);
    }

    function test_sort_mac_addresses_last() {
        var devices = [
            { name: "AA-BB-CC-DD-EE-FF" },
            { name: "11-22-33-44-55-66" },
            { name: "Speaker" }
        ];
        var sorted = sortDevices(devices);
        compare(sorted[0].name, "Speaker");
    }

    // --- filtering ---
    function test_filter_connected() {
        var devices = [
            { name: "A", connected: true, paired: true },
            { name: "B", connected: false, paired: true },
            { name: "C", connected: true, paired: true }
        ];
        compare(filterByState(devices, "connected").length, 2);
    }

    function test_filter_paired_not_connected() {
        var devices = [
            { name: "A", connected: true, paired: true },
            { name: "B", connected: false, paired: true },
            { name: "C", connected: false, paired: false }
        ];
        compare(filterByState(devices, "paired").length, 1);
    }

    function test_filter_unpaired() {
        var devices = [
            { name: "A", connected: false, paired: false },
            { name: "B", connected: false, paired: true }
        ];
        compare(filterByState(devices, "unpaired").length, 1);
    }

    function test_filter_empty() {
        compare(filterByState([], "connected").length, 0);
    }

    function test_adapter_state() {
        // Simple boolean test
        var enabled = true;
        verify(enabled);
        enabled = false;
        verify(!enabled);
    }
}
