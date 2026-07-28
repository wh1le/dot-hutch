import Quickshell
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

BarIcon {
    text: "vpn_lock"
    active: Wireguard.connected
    activeColor: Appearance.m3colors.m3success
    onLeftClicked: Quickshell.execDetached(["fzm", "-o", "wg-manage"])
}
