import QtQuick
import Quickshell
import "../../services"

QuickToggleButton {
    model: QuickToggleModel {
        name: Network.networkName || "Wi-Fi"
        icon: Network.materialSymbol
        toggled: Network.wifiEnabled
        mainAction: function() { Network.toggleWifi(); }
        secondaryAction: function() { Quickshell.execDetached(["bash", "-c", "fzm wifi-connect"]); }
    }
}
