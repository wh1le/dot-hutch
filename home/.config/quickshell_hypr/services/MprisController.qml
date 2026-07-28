pragma Singleton
pragma ComponentBehavior: Bound

import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import "../modules/common"
import ".."

Singleton {
    id: root
    property list<MprisPlayer> players: GlobalStates.mediaControlsOpen ? _frozenPlayers : _sortedPlayers
    property list<MprisPlayer> _frozenPlayers: []
    property int _sortTrigger: 0
    property list<MprisPlayer> _sortedPlayers: {
        void root._sortTrigger; // force re-evaluation
        const filtered = Mpris.players.values.filter(player => isRealPlayer(player));
        const seen = {};
        const deduped = filtered.filter(p => {
            const base = p.dbusName.replace(/\.instance\d+$/, '');
            if (seen[base]) return false;
            seen[base] = true;
            return true;
        });
        return deduped.sort((a, b) => {
            const playing = MprisPlaybackState.Playing;
            const paused = MprisPlaybackState.Paused;
            const isMpdA = a.dbusName.includes('mpd');
            const isMpdB = b.dbusName.includes('mpd');
            const stateA = a.playbackState === playing ? 2 : a.playbackState === paused ? 1 : 0;
            const stateB = b.playbackState === playing ? 2 : b.playbackState === paused ? 1 : 0;
            if (stateA === 2 && stateB === 2) {
                if (isMpdA && !isMpdB) return -1;
                if (isMpdB && !isMpdA) return 1;
            }
            return stateB - stateA;
        });
    }

    property bool _popupOpen: GlobalStates.mediaControlsOpen
    on_PopupOpenChanged: {
        if (_popupOpen)
            _frozenPlayers = _sortedPlayers;
    }
    property MprisPlayer trackedPlayer: null
    property MprisPlayer activePlayer: trackedPlayer && isRealPlayer(trackedPlayer) ? trackedPlayer : (_sortedPlayers[0] ?? null)
    signal trackChanged(reverse: bool)
    property bool __reverse: false
    property var activeTrack

    function isRealPlayer(player) {
        if (!player?.dbusName) return false;
        // playerctld mirrors other players, always a duplicate
        if (player.dbusName.startsWith('org.mpris.MediaPlayer2.playerctld')) return false;
        return true;
    }

    Instantiator {
        model: Mpris.players
        Connections {
            required property MprisPlayer modelData
            target: modelData
            Component.onCompleted: {
                if (!root.isRealPlayer(modelData)) return;
                if (root.trackedPlayer == null || modelData.isPlaying) root.trackedPlayer = modelData;
            }
            Component.onDestruction: {
                if (!root.isRealPlayer(modelData)) return;
                if (root.trackedPlayer == null || !root.trackedPlayer.isPlaying) {
                    for (const player of root.players) {
                        if (player.isPlaying) { root.trackedPlayer = player; return; }
                    }
                    root.trackedPlayer = root.players[0] ?? null;
                }
            }
            function onPlaybackStateChanged() {
                if (!root.isRealPlayer(modelData)) return;
                root._sortTrigger++;
                if (modelData.isPlaying) {
                    root.trackedPlayer = modelData;
                } else if (root.trackedPlayer === modelData) {
                    root.trackedPlayer = null;
                }
            }
        }
    }

    Connections {
        target: activePlayer
        enabled: activePlayer !== null
        function onPostTrackChanged() { root.updateTrack(); }
        function onTrackArtUrlChanged() {
            if (root.activePlayer && root.activeTrack &&
                root.activePlayer.uniqueId == root.activeTrack.uniqueId &&
                root.activePlayer.trackArtUrl != root.activeTrack.artUrl) {
                const r = root.__reverse; root.updateTrack(); root.__reverse = r;
            }
        }
    }

    onActivePlayerChanged: this.updateTrack()
    function updateTrack() {
        this.activeTrack = {
            uniqueId: this.activePlayer?.uniqueId ?? 0,
            artUrl: this.activePlayer?.trackArtUrl ?? "",
            title: this.activePlayer?.trackTitle || "Unknown Title",
            artist: this.activePlayer?.trackArtist || "Unknown Artist",
            album: this.activePlayer?.trackAlbum || "Unknown Album",
        };
        this.trackChanged(__reverse);
        this.__reverse = false;
    }

    property bool isPlaying: this.activePlayer && this.activePlayer.isPlaying
    property bool canTogglePlaying: this.activePlayer?.canTogglePlaying ?? false
    function togglePlaying() { if (this.canTogglePlaying) this.activePlayer.togglePlaying(); }

    property bool canGoPrevious: this.activePlayer?.canGoPrevious ?? false
    function previous() { if (this.canGoPrevious) { this.__reverse = true; this.activePlayer.previous(); } }

    property bool canGoNext: this.activePlayer?.canGoNext ?? false
    function next() { if (this.canGoNext) { this.__reverse = false; this.activePlayer.next(); } }

    property var loopState: this.activePlayer?.loopState ?? MprisLoopState.None
    property bool hasShuffle: this.activePlayer?.shuffle ?? false

    // --- Testable pure JS functions ---
    function _isRealPlayer(dbusName, hasPlasmaIntegration) {
        if (!dbusName) return false;
        if (hasPlasmaIntegration && dbusName.startsWith('org.mpris.MediaPlayer2.firefox')) return false;
        if (hasPlasmaIntegration && dbusName.startsWith('org.mpris.MediaPlayer2.chromium')) return false;
        if (dbusName.startsWith('org.mpris.MediaPlayer2.playerctld')) return false;
        if (dbusName.startsWith('org.mpris.MediaPlayer2.Blanket')) return false;
        if (dbusName.endsWith('.mpd') && !dbusName.endsWith('MediaPlayer2.mpd')) return false;
        return true;
    }

    function _selectActivePlayer(players) {
        var playing = players.find(p => p.isPlaying);
        if (playing) return playing;
        var paused = players.find(p => p.playbackState === "Paused");
        if (paused) return paused;
        return players[0] || null;
    }
}
