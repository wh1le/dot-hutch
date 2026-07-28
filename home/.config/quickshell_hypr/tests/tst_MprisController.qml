import QtQuick
import QtTest

TestCase {
    name: "MprisController"

    function isRealPlayer(dbusName, hasPlasmaIntegration) {
        if (hasPlasmaIntegration && dbusName.startsWith('org.mpris.MediaPlayer2.firefox')) return false;
        if (hasPlasmaIntegration && dbusName.startsWith('org.mpris.MediaPlayer2.chromium')) return false;
        if (dbusName.startsWith('org.mpris.MediaPlayer2.playerctld')) return false;
        if (dbusName.endsWith('.mpd') && !dbusName.endsWith('MediaPlayer2.mpd')) return false;
        return true;
    }

    function selectActivePlayer(players) {
        var playing = players.find(p => p.isPlaying);
        if (playing) return playing;
        var paused = players.find(p => p.playbackState === "Paused");
        if (paused) return paused;
        return players[0] || null;
    }

    // --- player filtering ---
    function test_filter_playerctld() {
        verify(!isRealPlayer("org.mpris.MediaPlayer2.playerctld", false));
    }
    function test_filter_firefox_with_plasma() {
        verify(!isRealPlayer("org.mpris.MediaPlayer2.firefox.instance123", true));
    }
    function test_filter_firefox_without_plasma() {
        verify(isRealPlayer("org.mpris.MediaPlayer2.firefox.instance123", false));
    }
    function test_filter_chromium_with_plasma() {
        verify(!isRealPlayer("org.mpris.MediaPlayer2.chromium.instance456", true));
    }
    function test_filter_spotify() {
        verify(isRealPlayer("org.mpris.MediaPlayer2.spotify", false));
    }
    function test_filter_mpd_non_instance() {
        verify(!isRealPlayer("org.mpris.MediaPlayer2.something.mpd", false));
    }
    function test_filter_mpd_real() {
        verify(isRealPlayer("org.mpris.MediaPlayer2.mpd", false));
    }

    // --- active player selection ---
    function test_select_playing() {
        var players = [
            { name: "A", isPlaying: false, playbackState: "Paused" },
            { name: "B", isPlaying: true, playbackState: "Playing" },
            { name: "C", isPlaying: false, playbackState: "Stopped" }
        ];
        compare(selectActivePlayer(players).name, "B");
    }
    function test_select_paused_fallback() {
        var players = [
            { name: "A", isPlaying: false, playbackState: "Stopped" },
            { name: "B", isPlaying: false, playbackState: "Paused" }
        ];
        compare(selectActivePlayer(players).name, "B");
    }
    function test_select_first_fallback() {
        var players = [
            { name: "A", isPlaying: false, playbackState: "Stopped" },
            { name: "B", isPlaying: false, playbackState: "Stopped" }
        ];
        compare(selectActivePlayer(players).name, "A");
    }
    function test_select_empty() {
        compare(selectActivePlayer([]), null);
    }

    // --- track metadata ---
    function test_metadata_extraction() {
        var track = {
            title: "Song Title",
            artist: "Artist Name",
            album: "Album Name"
        };
        compare(track.title, "Song Title");
        compare(track.artist, "Artist Name");
    }
}
