import QtQuick
import QtTest

TestCase {
    name: "HyprlandData"

    function filterWorkspaces(workspaces) {
        return workspaces.filter(ws => ws.id >= 1 && ws.id <= 100);
    }

    function filterFloatingClients(clients, workspaceId) {
        return clients.filter(c => c.floating === true && c.workspace.id === workspaceId);
    }

    function biggestWindow(clients) {
        return clients.reduce((maxWin, win) => {
            const maxArea = (maxWin?.size?.[0] ?? 0) * (maxWin?.size?.[1] ?? 0);
            const winArea = (win?.size?.[0] ?? 0) * (win?.size?.[1] ?? 0);
            return winArea > maxArea ? win : maxWin;
        }, null);
    }

    // --- workspace filtering ---
    function test_filter_valid() {
        var ws = [{id: 1}, {id: 5}, {id: 100}];
        compare(filterWorkspaces(ws).length, 3);
    }
    function test_filter_invalid_negative() {
        compare(filterWorkspaces([{id: -1}]).length, 0);
    }
    function test_filter_invalid_zero() {
        compare(filterWorkspaces([{id: 0}]).length, 0);
    }
    function test_filter_invalid_above_100() {
        compare(filterWorkspaces([{id: 101}]).length, 0);
    }
    function test_filter_lock_workspace() {
        compare(filterWorkspaces([{id: 2147483647}]).length, 0);
    }
    function test_filter_mixed() {
        var ws = [{id: -1}, {id: 0}, {id: 1}, {id: 50}, {id: 100}, {id: 101}];
        compare(filterWorkspaces(ws).length, 3);
    }

    // --- floating client filtering ---
    function test_floating_in_workspace() {
        var clients = [
            {floating: true, workspace: {id: 1}},
            {floating: false, workspace: {id: 1}},
            {floating: true, workspace: {id: 2}}
        ];
        compare(filterFloatingClients(clients, 1).length, 1);
    }
    function test_floating_none() {
        var clients = [{floating: false, workspace: {id: 1}}];
        compare(filterFloatingClients(clients, 1).length, 0);
    }
    function test_floating_wrong_workspace() {
        var clients = [{floating: true, workspace: {id: 2}}];
        compare(filterFloatingClients(clients, 1).length, 0);
    }
    function test_floating_empty() {
        compare(filterFloatingClients([], 1).length, 0);
    }

    // --- biggest window ---
    function test_biggest_window() {
        var clients = [
            {size: [100, 100]},
            {size: [200, 200]},
            {size: [150, 150]}
        ];
        var result = biggestWindow(clients);
        compare(result.size[0], 200);
    }
    function test_biggest_window_single() {
        var clients = [{size: [100, 100]}];
        compare(biggestWindow(clients).size[0], 100);
    }
    function test_biggest_window_empty() {
        compare(biggestWindow([]), null);
    }
}
