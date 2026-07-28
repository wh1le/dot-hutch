import Quickshell
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

BarIcon {
    text: BluetoothStatus.connected ? "bluetooth_connected" : (BluetoothStatus.enabled ? "bluetooth" : "bluetooth_disabled")
    active: BluetoothStatus.connected || BluetoothStatus.enabled
    clickable: true
    onLeftClicked: Quickshell.execDetached(["kitty", "--class", "launcher", "bluetui"])
}
