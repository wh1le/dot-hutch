pragma Singleton
pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import Quickshell

Singleton {
    // XDG Dirs, with "file://"
    readonly property string home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
    readonly property string state: StandardPaths.standardLocations(StandardPaths.StateLocation)[0]
    readonly property string cache: StandardPaths.standardLocations(StandardPaths.CacheLocation)[0]

    // Shell paths
    property string shellConfig: `${config}/quickshell`.replace("file://", "")
    property string shellConfigName: "config.json"
    property string shellConfigPath: `${shellConfig}/${shellConfigName}`
    property string logPath: `${home}/.local/state/quickshell.log`.replace("file://", "")
    property string pywalColorsPath: `${home}/.cache/wal/colors.json`.replace("file://", "")
    property string notificationsPath: `${cache}/notifications/notifications.json`.replace("file://", "")

    Component.onCompleted: {
        Quickshell.execDetached(["mkdir", "-p", shellConfig])
    }
}
