import QtQuick
import "../../services"

QuickToggleButton {
    model: QuickToggleModel {
        name: "Night Light"
        icon: "nightlight"
        toggled: Hyprsunset.temperatureActive
        mainAction: function() { Hyprsunset.toggleTemperature(); }
    }
}
