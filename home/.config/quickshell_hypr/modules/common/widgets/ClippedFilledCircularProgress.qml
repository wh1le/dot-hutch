import ".."
import "../functions"
import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property int implicitSize: 18
    property int lineWidth: 2
    property real value: 0
    property color colPrimary: Appearance?.colors.colOnSecondaryContainer ?? "#685496"
    property color colSecondary: ColorUtils.transparentize(colPrimary, 0.5)
    property bool fill: true
    property bool enableAnimation: true
    property int animationDuration: 800
    property var easingType: Easing.OutCubic

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    property real degree: value * 360
    property real centerX: root.width / 2
    property real centerY: root.height / 2
    property real arcRadius: root.implicitSize / 2 - root.lineWidth / 2 - 0.5
    property real startAngle: -90

    Behavior on degree {
        enabled: root.enableAnimation
        NumberAnimation {
            duration: root.animationDuration
            easing.type: root.easingType
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: implicitSize / 2
        color: root.colSecondary

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                id: primaryPath
                strokeColor: root.colPrimary
                strokeWidth: root.lineWidth
                capStyle: ShapePath.RoundCap
                fillColor: root.colPrimary
                startX: root.centerX
                startY: root.centerY
                PathAngleArc {
                    moveToStart: false
                    centerX: root.centerX
                    centerY: root.centerY
                    radiusX: root.arcRadius
                    radiusY: root.arcRadius
                    startAngle: root.startAngle
                    sweepAngle: root.degree
                }
                PathLine {
                    x: primaryPath.startX
                    y: primaryPath.startY
                }
            }
        }
    }
}
