import QtQuick
import QtTest

TestCase {
    name: "MicActivity"

    function parsePactlOutput(text, appList) {
        var lower = text.toLowerCase();
        for (var i = 0; i < appList.length; i++) {
            if (lower.includes(appList[i])) return true;
        }
        return false;
    }

    property var apps: ["firefox", "zoom", "chromium"]

    function test_firefox_active() {
        verify(parsePactlOutput("Source Output #45\n\tapplication.name = \"Firefox\"", apps));
    }
    function test_zoom_active() {
        verify(parsePactlOutput("Source Output #12\n\tapplication.name = \"zoom\"", apps));
    }
    function test_chromium_active() {
        verify(parsePactlOutput("Source Output #3\n\tapplication.name = \"Chromium\"", apps));
    }
    function test_spotify_not_matched() {
        verify(!parsePactlOutput("Source Output #5\n\tapplication.name = \"Spotify\"", apps));
    }
    function test_no_source_outputs() {
        verify(!parsePactlOutput("", apps));
    }
    function test_multiple_matching() {
        verify(parsePactlOutput("firefox\nzoom\nchromium", apps));
    }
    function test_case_insensitive() {
        verify(parsePactlOutput("FIREFOX", apps));
    }
}
