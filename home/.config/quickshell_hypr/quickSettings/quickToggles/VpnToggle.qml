import QtQuick
import Quickshell
import "../../services"

QuickToggleButton {
    model: QuickToggleModel {
        name: "VPN"
        icon: "vpn_lock"
        toggled: Wireguard.connected
        mainAction: function() { Quickshell.execDetached(["bash", "-c", "fzm wg-manage"]); }
    }
}
