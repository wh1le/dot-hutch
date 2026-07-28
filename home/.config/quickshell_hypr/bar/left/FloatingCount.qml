import QtQuick
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

Revealer {
    reveal: FloatingWindows.count > 0

    RippleButton {
        implicitHeight: 22
        buttonRadius: Appearance.rounding.small
        contentItem: StyledText {
            text: `󰖯 ${FloatingWindows.count}`
            font.pixelSize: Appearance.font.pixelSize.smaller
        }
    }
}
