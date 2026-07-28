import Quickshell
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

BarIcon {
    text: {
        if (!Audio.sink) return "volume_off";
        if (Audio.sink.audio.muted) return "volume_off";
        if (Audio.value > 0.66) return "volume_up";
        if (Audio.value > 0.33) return "volume_down";
        if (Audio.value > 0) return "volume_mute";
        return "volume_off";
    }
    active: Audio.sink && !Audio.sink.audio.muted
    onLeftClicked: Quickshell.execDetached(["kitty", "--class", "launcher", "wiremix"])
    onRightClicked: Audio.toggleMute()
}
