pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "../../services"
import "../../modules/common"

Singleton {
    id: root

    readonly property string workspace: "special:quickshell-tray"
    readonly property var trayApps: Config.options.tray.trayApps ?? []

    property ListModel items: ListModel {}

    function _isTrayApp(appId) {
        const id = appId.toLowerCase();
        return trayApps.some(a => id.includes(a.toLowerCase()));
    }

    Component.onCompleted: _rescan()

    function _rescan() {
        rescanProc.running = true;
    }

    Process {
        id: rescanProc
        running: false
        command: ["hyprctl", "clients", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const clients = JSON.parse(text);
                    for (const c of clients) {
                        const appId = c.class ?? "";
                        const addr = c.address.replace(/^0x/, "");
                        if (c.workspace?.name === root.workspace) {
                            root._addItem(addr, appId, c.title ?? "", true,
                                c.floating ?? false, c.at?.[0] ?? 0, c.at?.[1] ?? 0);
                        } else if (root._isTrayApp(appId)) {
                            root._addItem(addr, appId, c.title ?? "", false, false, 0, 0);
                        }
                    }
                } catch(e) {}
            }
        }
    }

    function _addItem(address, appId, title, hidden, floating, x, y) {
        for (let i = 0; i < items.count; i++) {
            if (items.get(i).address === address) return;
        }
        items.append({
            address: address,
            appId: appId,
            title: title,
            icon: AppIcons.guessIcon(appId),
            hidden: hidden,
            floating: floating,
            x: x, y: y
        });
    }

    function smartClose() {
        console.log("[MinimizeTray] smartClose called");
        hideProc.running = true;
    }

    function hide() {
        hideProc._forceHide = true;
        hideProc.running = true;
    }

    Process {
        id: hideProc
        running: false
        property bool _forceHide: false
        command: ["hyprctl", "activewindow", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const w = JSON.parse(text);
                    const addr = w.address.replace(/^0x/, "");
                    const appId = w.class ?? "";
                    console.log("[MinimizeTray] activewindow class=" + appId + " isTrayApp=" + root._isTrayApp(appId) + " forceHide=" + hideProc._forceHide);

                    if (!hideProc._forceHide && !root._isTrayApp(appId)) {
                        Hyprland.dispatch("killactive");
                        return;
                    }
                    hideProc._forceHide = false;

                    // Update existing item or add new
                    for (let i = 0; i < root.items.count; i++) {
                        if (root.items.get(i).address === addr) {
                            root.items.setProperty(i, "hidden", true);
                            root.items.setProperty(i, "floating", w.floating ?? false);
                            root.items.setProperty(i, "x", w.at?.[0] ?? 0);
                            root.items.setProperty(i, "y", w.at?.[1] ?? 0);
                            Hyprland.dispatch("movetoworkspacesilent " + root.workspace + ",address:0x" + addr);
                            return;
                        }
                    }
                    root._addItem(addr, appId, w.title ?? "", true,
                        w.floating ?? false, w.at?.[0] ?? 0, w.at?.[1] ?? 0);
                    Hyprland.dispatch("movetoworkspacesilent " + root.workspace + ",address:0x" + addr);
                } catch(e) {}
            }
        }
    }

    function restore(address) {
        for (let i = 0; i < items.count; i++) {
            const item = items.get(i);
            if (item.address === address) {
                if (!item.hidden) {
                    // App is visible, just focus it
                    Hyprland.dispatch("focuswindow address:0x" + address);
                    return;
                }
                Hyprland.dispatch("movetoworkspacesilent e+0,address:0x" + address);
                if (item.floating) {
                    Hyprland.dispatch("movewindowpixel exact " + item.x + " " + item.y + ",address:0x" + address);
                }
                Hyprland.dispatch("focuswindow address:0x" + address);
                items.setProperty(i, "hidden", false);
                return;
            }
        }
    }

    function closeWindow(address) {
        Hyprland.dispatch("closewindow address:0x" + address);
        _remove(address);
    }

    function _remove(address) {
        for (let i = 0; i < items.count; i++) {
            if (items.get(i).address === address) {
                items.remove(i);
                return;
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "closewindow") {
                root._remove(event.data);
            } else if (event.name === "openwindow") {
                // format: addr,workspace,class,title
                const parts = event.data.split(",");
                const addr = parts[0];
                const appId = parts[2] ?? "";
                const title = parts.slice(3).join(",");
                if (root._isTrayApp(appId)) {
                    root._addItem(addr, appId, title, false, false, 0, 0);
                }
            }
        }
    }
}
