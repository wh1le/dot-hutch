import QtQuick
import QtTest

TestCase {
    name: "FloatingWindows"

    function countFloating(clients, workspaceId) {
        return clients.filter(c => c.floating === true && c.workspace.id === workspaceId).length;
    }

    function test_three_floating_two_tiled() {
        var clients = [
            {floating: true, workspace: {id: 1}},
            {floating: true, workspace: {id: 1}},
            {floating: true, workspace: {id: 1}},
            {floating: false, workspace: {id: 1}},
            {floating: false, workspace: {id: 1}}
        ];
        compare(countFloating(clients, 1), 3);
    }
    function test_zero_floating() {
        var clients = [
            {floating: false, workspace: {id: 1}},
            {floating: false, workspace: {id: 1}}
        ];
        compare(countFloating(clients, 1), 0);
    }
    function test_floating_wrong_workspace() {
        var clients = [
            {floating: true, workspace: {id: 2}},
            {floating: true, workspace: {id: 3}}
        ];
        compare(countFloating(clients, 1), 0);
    }
    function test_empty_clients() {
        compare(countFloating([], 1), 0);
    }
    function test_mixed_workspaces() {
        var clients = [
            {floating: true, workspace: {id: 1}},
            {floating: true, workspace: {id: 2}},
            {floating: true, workspace: {id: 1}},
            {floating: false, workspace: {id: 1}}
        ];
        compare(countFloating(clients, 1), 2);
        compare(countFloating(clients, 2), 1);
    }
}
