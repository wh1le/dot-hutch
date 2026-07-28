import Quickshell
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

BarIcon {
    text: Network.materialSymbol
    active: Network.networkName !== ""
    onLeftClicked: Quickshell.execDetached(["fzm", "-o", "wifi-connect"])
}
