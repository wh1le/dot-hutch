import QtQuick
import "../../services"

QuickToggleButton {
    model: QuickToggleModel {
        name: "Caffeine"
        icon: "coffee"
        toggled: Idle.inhibit
        mainAction: function() { Idle.toggleInhibit(); }
    }
}
