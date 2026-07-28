import QtQuick
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

Revealer {
    reveal: MicActivity.active

    StyledText {
        text: "AIR"
        color: Appearance.m3colors.m3error
        font.pixelSize: Appearance.font.pixelSize.smaller
        font.weight: Font.Bold
    }
}
