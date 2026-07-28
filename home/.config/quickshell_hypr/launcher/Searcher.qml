// Replaced by fzf --filter Process in services/Apps.qml
// Kept as empty file to avoid QML import errors if referenced
import QtQuick
import Quickshell

Singleton {
    id: root
    property list<QtObject> list: []
    property string key: "name"

    function query(search) {
        return [...list];
    }
}
