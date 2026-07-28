import QtQuick
import "../../services"

QuickToggleButton {
    model: QuickToggleModel {
        name: "Microphone"
        icon: Audio.source?.audio.muted ? "mic_off" : "mic"
        toggled: !(Audio.source?.audio.muted ?? true)
        mainAction: function() { Audio.toggleMicMute(); }
    }
}
