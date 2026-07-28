import QtQuick
import QtQuick.Layouts
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

RowLayout {
    spacing: 2
    visible: Battery.available

    CircularProgress {
        implicitSize: 14
        lineWidth: 1.5
        value: Battery.percentage
        colPrimary: Battery.isCharging ? Appearance.m3colors.m3success
            : Battery.isCritical ? Appearance.m3colors.m3error
            : Battery.isLow ? Appearance.m3colors.m3tertiary
            : Appearance.m3colors.m3onSecondaryContainer
    }

    StyledText {
        text: `${Math.round(Battery.percentage * 100)}%`
        font.pixelSize: Appearance.font.pixelSize.smallest
    }
}
