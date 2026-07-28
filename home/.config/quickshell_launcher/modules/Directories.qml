pragma Singleton
pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import Quickshell

Singleton {
    // XDG dirs (with "file://" prefix from StandardPaths)
    readonly property string home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]

    // Bootstrap location of config.yaml (cannot live inside the config itself).
    property string shellConfig: `${config}/quickshell_launcher`.replace("file://", "")
    property string shellConfigName: "config.yaml"
    property string shellConfigPath: `${shellConfig}/${shellConfigName}`

    Component.onCompleted: {
        Quickshell.execDetached(["mkdir", "-p", shellConfig])
    }
}
