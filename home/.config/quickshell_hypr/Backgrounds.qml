import QtQuick
import QtQuick.Shapes
import "modules/common"

Shape {
    id: root
    anchors.fill: parent
    preferredRendererType: Shape.CurveRenderer

    required property Item panels
    required property real borderWidth
    required property real cornerRadius
    property color bgColor: Appearance.colors.colBarBg

    // Dynamic layout values
    property real bw: borderWidth
    property real barH: Appearance.sizes.barHeight
    property real r: cornerRadius

    // Media controls popup background
    ShapePath {
        id: mcPath
        fillColor: GlobalStates.mediaControlsOpen ? root.bgColor : "transparent"
        strokeWidth: -1

        property real pw: root.panels.mediaControlsWidth
        property real ph: root.panels.mediaControlsHeight
        property real left: root.bw
        property real top: root.barH
        property real right: left + pw
        property real bottom: top + ph

        startX: left
        startY: top
        PathLine { x: mcPath.right;          y: mcPath.top }
        PathLine { x: mcPath.right;          y: mcPath.bottom - root.r }
        PathArc  { x: mcPath.right - root.r; y: mcPath.bottom; radiusX: root.r; radiusY: root.r }
        PathLine { x: mcPath.left;           y: mcPath.bottom }
        PathLine { x: mcPath.left;           y: mcPath.top }
    }

    // Quick settings popup background
    ShapePath {
        id: qsPath
        fillColor: GlobalStates.quickSettingsOpen ? root.bgColor : "transparent"
        strokeWidth: -1

        property real pw: root.panels.quickSettingsWidth
        property real ph: root.panels.quickSettingsHeight
        property real right: root.width - root.bw
        property real left: right - pw
        property real top: root.barH
        property real bottom: top + ph

        startX: qsPath.right
        startY: qsPath.top
        PathLine { x: qsPath.right;          y: qsPath.bottom }
        PathLine { x: qsPath.left + root.r;  y: qsPath.bottom }
        PathArc  { x: qsPath.left;           y: qsPath.bottom - root.r; radiusX: root.r; radiusY: root.r }
        PathLine { x: qsPath.left;           y: qsPath.top }
        PathLine { x: qsPath.right;          y: qsPath.top }
    }

    // Calendar popup background
    ShapePath {
        id: calPath
        fillColor: GlobalStates.calendarOpen ? root.bgColor : "transparent"
        strokeWidth: -1

        property real pw: root.panels.calendarWidth
        property real ph: root.panels.calendarHeight
        property real right: root.width - root.bw
        property real left: right - pw
        property real top: root.barH
        property real bottom: top + ph

        startX: calPath.right
        startY: calPath.top
        PathLine { x: calPath.right;          y: calPath.bottom }
        PathLine { x: calPath.left + root.r;  y: calPath.bottom }
        PathArc  { x: calPath.left;           y: calPath.bottom - root.r; radiusX: root.r; radiusY: root.r }
        PathLine { x: calPath.left;           y: calPath.top }
        PathLine { x: calPath.right;          y: calPath.top }
    }

    // App launcher popup background (flat bottom, rounded top)
    ShapePath {
        id: launcherPath
        fillColor: GlobalStates.appLauncherOpen ? root.bgColor : "transparent"
        strokeWidth: -1

        property real pw: root.panels.launcherWidth
        property real ph: root.panels.launcherHeight
        property real left: (root.width - pw) / 2
        property real right: left + pw
        property real bottom: root.height
        property real top: bottom - ph

        startX: launcherPath.left
        startY: launcherPath.bottom
        PathLine { x: launcherPath.right;           y: launcherPath.bottom }
        PathLine { x: launcherPath.right;           y: launcherPath.top + root.r }
        PathArc  { x: launcherPath.right - root.r;  y: launcherPath.top; radiusX: root.r; radiusY: root.r }
        PathLine { x: launcherPath.left + root.r;   y: launcherPath.top }
        PathArc  { x: launcherPath.left;             y: launcherPath.top + root.r; radiusX: root.r; radiusY: root.r }
        PathLine { x: launcherPath.left;             y: launcherPath.bottom }
    }
}
