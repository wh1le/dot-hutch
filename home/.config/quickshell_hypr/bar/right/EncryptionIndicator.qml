import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

BarIcon {
    text: "lock"
    active: Encryption.mounted
    activeColor: Appearance.m3colors.m3success
    clickable: false
}
