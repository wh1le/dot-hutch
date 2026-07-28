import QtQuick
import QtQuick.Layouts
import "../modules/common"
import "../modules/common/widgets"
import "../services"

ColumnLayout {
    spacing: 8

    // Volume slider
    RowLayout {
        spacing: 8
        MaterialSymbol {
            text: Audio.sink?.audio.muted ? "volume_off" : "volume_up"
            iconSize: 18
        }
        StyledSlider {
            Layout.fillWidth: true
            from: 0; to: 1
            value: Audio.value
            onMoved: { if (Audio.sink) Audio.sink.audio.volume = value; }
        }
    }

    // Mic slider
    RowLayout {
        spacing: 8
        MaterialSymbol {
            text: Audio.source?.audio.muted ? "mic_off" : "mic"
            iconSize: 18
        }
        StyledSlider {
            Layout.fillWidth: true
            from: 0; to: 1
            value: Audio.source?.audio.volume ?? 0
            onMoved: { if (Audio.source) Audio.source.audio.volume = value; }
        }
    }
}
