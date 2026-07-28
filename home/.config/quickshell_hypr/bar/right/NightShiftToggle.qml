import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

BarIcon {
    text: "nightlight"
    active: Hyprsunset.temperatureActive
    activeColor: Appearance.m3colors.m3tertiary
    onLeftClicked: Hyprsunset.toggleTemperature()
}
