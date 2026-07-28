import QtQuick
import "../../modules/common"
import "../../modules/common/widgets"
import "../../services"

Text {
    text: Weather.displayText
    textFormat: Text.RichText
    font.family: Appearance.font.family.monospace
    font.pixelSize: Appearance.font.pixelSize.smallest
    color: Appearance.m3colors.m3onBackground
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    visible: Weather.displayText !== ""
}
