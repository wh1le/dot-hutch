pragma ComponentBehavior: Bound
import QtQuick
import ".."

Item {
    id: root

    property int currentIndex: 0
    property alias model: repeater.model
    property Component delegate
    property int animDuration: 150

    clip: true

    Repeater {
        id: repeater

        Loader {
            id: popout
            required property var modelData
            required property int index

            readonly property bool shouldBeActive: index === root.currentIndex

            anchors.fill: parent
            opacity: 0
            active: false
            sourceComponent: root.delegate

            states: State {
                name: "active"
                when: popout.shouldBeActive

                PropertyChanges {
                    popout.active: true
                    popout.opacity: 1
                }
            }

            transitions: [
                Transition {
                    from: "active"
                    to: ""

                    SequentialAnimation {
                        NumberAnimation {
                            properties: "opacity"
                            duration: root.animDuration
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.animationCurves.standardAccel
                        }
                        PropertyAction {
                            target: popout
                            property: "active"
                        }
                    }
                },
                Transition {
                    from: ""
                    to: "active"

                    SequentialAnimation {
                        PropertyAction {
                            target: popout
                            property: "active"
                        }
                        NumberAnimation {
                            properties: "opacity"
                            duration: root.animDuration
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.animationCurves.standardDecel
                        }
                    }
                }
            ]
        }
    }
}
