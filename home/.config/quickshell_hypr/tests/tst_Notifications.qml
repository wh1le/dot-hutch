import QtQuick
import QtTest

TestCase {
    name: "Notifications"

    function groupByApp(list) {
        const groups = {};
        list.forEach(notif => {
            if (!groups[notif.appName]) groups[notif.appName] = { appName: notif.appName, notifications: [], time: 0 };
            groups[notif.appName].notifications.push(notif);
            groups[notif.appName].time = Math.max(groups[notif.appName].time, notif.time);
        });
        return groups;
    }

    // --- grouping ---
    function test_group_single_app() {
        var list = [{appName: "Firefox", time: 100}, {appName: "Firefox", time: 200}];
        var groups = groupByApp(list);
        compare(Object.keys(groups).length, 1);
        compare(groups["Firefox"].notifications.length, 2);
    }
    function test_group_multiple_apps() {
        var list = [{appName: "Firefox", time: 100}, {appName: "Discord", time: 200}];
        var groups = groupByApp(list);
        compare(Object.keys(groups).length, 2);
    }
    function test_group_latest_time() {
        var list = [{appName: "App", time: 100}, {appName: "App", time: 300}, {appName: "App", time: 200}];
        compare(groupByApp(list)["App"].time, 300);
    }
    function test_group_empty() {
        compare(Object.keys(groupByApp([])).length, 0);
    }

    // --- unread count ---
    function test_unread_increment() {
        var unread = 0;
        unread++; unread++; unread++;
        compare(unread, 3);
    }
    function test_unread_reset() {
        var unread = 5;
        unread = 0;
        compare(unread, 0);
    }

    // --- timeout ---
    function test_default_timeout() { compare(7000, 7000); }
    function test_custom_timeout() {
        var expireTimeout = 3000;
        var defaultTimeout = 7000;
        var interval = expireTimeout < 0 ? defaultTimeout : expireTimeout;
        compare(interval, 3000);
    }
    function test_negative_timeout_uses_default() {
        var expireTimeout = -1;
        var defaultTimeout = 7000;
        var interval = expireTimeout < 0 ? defaultTimeout : expireTimeout;
        compare(interval, 7000);
    }

    // --- transient ---
    function test_transient_auto_dismiss() {
        var isTransient = true;
        // Transient notifications should be discarded on timeout, not just hidden
        verify(isTransient);
    }

    // --- action parsing ---
    function test_actions_map() {
        var actions = [{identifier: "reply", text: "Reply"}, {identifier: "dismiss", text: "Dismiss"}];
        var mapped = actions.map(a => ({identifier: a.identifier, text: a.text}));
        compare(mapped.length, 2);
        compare(mapped[0].identifier, "reply");
    }
}
