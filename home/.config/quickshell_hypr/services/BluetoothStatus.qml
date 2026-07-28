pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Bluetooth
import QtQuick

Singleton {
    id: root

    readonly property bool available: Bluetooth.adapters.values.length > 0
    readonly property bool enabled: Bluetooth.defaultAdapter?.enabled ?? false
    readonly property BluetoothDevice firstActiveDevice: Bluetooth.defaultAdapter?.devices.values.find(device => device.connected) ?? null
    readonly property int activeDeviceCount: Bluetooth.defaultAdapter?.devices.values.filter(device => device.connected).length ?? 0
    readonly property bool connected: Bluetooth.devices.values.some(d => d.connected)

    function sortFunction(a, b) {
        const macRegex = /^([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}$/;
        const aIsMac = macRegex.test(a.name);
        const bIsMac = macRegex.test(b.name);
        if (aIsMac !== bIsMac) return aIsMac ? 1 : -1;
        return a.name.localeCompare(b.name);
    }

    property list<var> connectedDevices: Bluetooth.devices.values.filter(d => d.connected).sort(sortFunction)
    property list<var> pairedButNotConnectedDevices: Bluetooth.devices.values.filter(d => d.paired && !d.connected).sort(sortFunction)
    property list<var> unpairedDevices: Bluetooth.devices.values.filter(d => !d.paired && !d.connected).sort(sortFunction)
    property list<var> friendlyDeviceList: [...connectedDevices, ...pairedButNotConnectedDevices, ...unpairedDevices]

    // --- Testable pure JS functions ---
    function _sortDevices(devices) {
        const macRegex = /^([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}$/;
        return [...devices].sort((a, b) => {
            const aIsMac = macRegex.test(a.name);
            const bIsMac = macRegex.test(b.name);
            if (aIsMac !== bIsMac) return aIsMac ? 1 : -1;
            return a.name.localeCompare(b.name);
        });
    }

    function _filterByState(devices, state) {
        if (state === "connected") return devices.filter(d => d.connected);
        if (state === "paired") return devices.filter(d => d.paired && !d.connected);
        if (state === "unpaired") return devices.filter(d => !d.paired && !d.connected);
        return devices;
    }
}
