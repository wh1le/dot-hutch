import QtQuick
import "../../services"

QuickToggleButton {
    model: QuickToggleModel {
        name: BluetoothStatus.firstActiveDevice?.name ?? "Bluetooth"
        icon: BluetoothStatus.connected ? "bluetooth_connected" : "bluetooth"
        toggled: BluetoothStatus.enabled
    }
}
