import QtQuick
import QtQuick.Shapes
import ".."

Item {
    id: root

    property int implicitSize: 30
    property real lineWidth: 2
    property real value: 0
    property color colPrimary: Appearance.m3colors.m3onSecondaryContainer
    property color colSecondary: Appearance.colors.colSecondaryContainer
    property real gapAngle: 360 / 18
    property bool fill: false
    property bool enableAnimation: true
    property int animationDuration: 800
    property var easingType: Easing.OutCubic

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    property real degree: value * 360
    property real centerX: root.width / 2
    property real centerY: root.height / 2
    property real arcRadius: root.implicitSize / 2 - root.lineWidth
    property real startAngle: -90

    // --- Testable pure JS functions ---
    function _valueToDegrees(val) {
        return val * 360;
    }

    function _clampValue(val) {
        return Math.max(0, Math.min(1, val));
    }

    function _secondaryArcSweep(deg, gap) {
        return -(360 - deg - 2 * gap);
    }

    Behavior on degree {
        enabled: root.enableAnimation
        NumberAnimation {
            duration: root.animationDuration
            easing.type: root.easingType
        }
    }

    Loader {
        active: root.fill
        anchors.fill: parent
        sourceComponent: Rectangle {
            radius: 9999
            color: root.colSecondary
        }
    }

    Shape {
        anchors.fill: parent
        layer.enabled: true
        layer.smooth: true
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            strokeColor: root.colSecondary
            strokeWidth: root.lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"
            PathAngleArc {
                centerX: root.centerX; centerY: root.centerY
                radiusX: root.arcRadius; radiusY: root.arcRadius
                startAngle: root.startAngle - root.gapAngle
                sweepAngle: -(360 - root.degree - 2 * root.gapAngle)
            }
        }
        ShapePath {
            strokeColor: root.colPrimary
            strokeWidth: root.lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"
            PathAngleArc {
                centerX: root.centerX; centerY: root.centerY
                radiusX: root.arcRadius; radiusY: root.arcRadius
                startAngle: root.startAngle
                sweepAngle: root.degree
            }
        }
    }
}
