import QtQuick
import QtQuick.Layouts
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

RowLayout {
    spacing: 2

    MaterialSymbol {
        text: Notifications.unread > 0 ? "notifications_active" : "notifications"
        iconSize: Appearance.sizes.barMaterialIconSize
        fill: Notifications.unread > 0 ? 1 : 0
    }

    StyledText {
        text: Notifications.unread > 0 ? String(Notifications.unread) : ""
        font.pixelSize: Appearance.font.pixelSize.smallest
        visible: Notifications.unread > 0
    }
}
