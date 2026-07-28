import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

BarIcon {
    text: "coffee"
    active: Idle.inhibit
    activeColor: Appearance.m3colors.m3success
    onLeftClicked: Idle.toggleInhibit()
}
