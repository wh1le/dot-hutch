import QtQuick
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

Revealer {
    reveal: Submap.activeSubmap !== ""

    StyledText {
        text: Submap.activeSubmap
        color: Appearance.m3colors.m3error
        font.pixelSize: Appearance.font.pixelSize.smaller
    }
}
