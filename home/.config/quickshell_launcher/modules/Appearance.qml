import QtQuick
import Quickshell
import ".."
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root

    readonly property QtObject m3colors: Colors.m3colors
    readonly property QtObject colors: Colors.colors

    property QtObject animation
    property QtObject rounding

    rounding: QtObject {
        property int verysmall: 8
    }

    animation: QtObject {
        // Only elementMoveFast (duration/type/bezierCurve) is used by the launcher.
        property QtObject elementMoveFast: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: [0.34, 0.80, 0.34, 1.00, 1, 1]
        }
    }
}
