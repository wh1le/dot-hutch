import QtQuick

QtObject {
    property string name: ""
    property string icon: ""
    property bool toggled: false
    property var mainAction: function() { toggled = !toggled; }
    property var secondaryAction: null

    // --- Testable pure JS functions ---
    function _toggleState(current) {
        return !current;
    }
}
