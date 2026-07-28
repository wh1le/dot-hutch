import QtQuick
import "../../modules/common"
import "../../modules/common/functions"
import "../../services"

Text {
    property string emoji: DateUtils.monthEmoji(DateTime.clock.date.getMonth() + 1)
    text: `<span style="font-family: 'Twitter Color Emoji', 'Noto Color Emoji';">${emoji}</span>`
    textFormat: Text.RichText
    font.pixelSize: 12
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
}
