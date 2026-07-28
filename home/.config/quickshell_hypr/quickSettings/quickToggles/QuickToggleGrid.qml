import QtQuick
import QtQuick.Layouts
import "../../modules/common"

GridLayout {
    columns: 2
    columnSpacing: 8
    rowSpacing: 8

    CaffeineToggle {}
    NightLightToggle {}
    NetworkToggle {}
    BluetoothToggle {}
    VpnToggle {}
    MicToggle {}
}
