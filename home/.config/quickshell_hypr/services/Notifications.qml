pragma Singleton
pragma ComponentBehavior: Bound

import "../modules/common"
import QtQuick
import Quickshell
import Quickshell.Io

// Notification tracking without owning DBus name (swaync handles that)
Singleton {
    id: root

    property int unread: 0
    property list<var> list: []

    function markAllRead() { root.unread = 0; }
    function discardAllNotifications() { root.list = []; root.unread = 0; }

    // --- Testable pure JS functions ---
    function _groupByApp(list) {
        const groups = {};
        list.forEach((notif) => {
            if (!groups[notif.appName]) groups[notif.appName] = { appName: notif.appName, appIcon: notif.appIcon, notifications: [], time: 0 };
            groups[notif.appName].notifications.push(notif);
            groups[notif.appName].time = Math.max(groups[notif.appName].time, notif.time);
        });
        return groups;
    }

    function _unreadCount(list) { return list.filter(n => n.popup).length; }
}
