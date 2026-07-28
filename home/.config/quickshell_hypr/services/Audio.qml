pragma Singleton
pragma ComponentBehavior: Bound
import "../modules/common"
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root
    property bool ready: Pipewire.defaultAudioSink?.ready ?? false
    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource
    readonly property real hardMaxValue: 2.00
    property real value: sink?.audio.volume ?? 0

    function friendlyDeviceName(node) {
        return (node.nickname || node.description || "Unknown");
    }

    function toggleMute() { Audio.sink.audio.muted = !Audio.sink.audio.muted }
    function toggleMicMute() { Audio.source.audio.muted = !Audio.source.audio.muted }

    function incrementVolume() {
        const currentVolume = Audio.value;
        const step = currentVolume < 0.1 ? 0.01 : 0.02;
        Audio.sink.audio.volume = Math.min(1, Audio.sink.audio.volume + step);
    }

    function decrementVolume() {
        const currentVolume = Audio.value;
        const step = currentVolume < 0.1 ? 0.01 : 0.02;
        Audio.sink.audio.volume = Math.max(0, Audio.sink.audio.volume - step);
    }

    function setDefaultSink(node) { Pipewire.preferredDefaultAudioSink = node; }
    function setDefaultSource(node) { Pipewire.preferredDefaultAudioSource = node; }

    PwObjectTracker { objects: [sink, source] }

    Timer {
        id: volumeSoundDebounce
        interval: 60
        onTriggered: SoundService.play("button-pressed")
    }

    Connections {
        target: sink?.audio ?? null
        property bool lastReady: false
        property real lastVolume: 0
        function onVolumeChanged() {
            if (!Config.options.audio.protection.enable) {
                if (lastReady) volumeSoundDebounce.restart();
                else lastReady = true;
                return;
            }
            const newVolume = sink.audio.volume;
            if (isNaN(newVolume) || newVolume === undefined || newVolume === null) { lastReady = false; lastVolume = 0; return; }
            if (!lastReady) { lastVolume = newVolume; lastReady = true; return; }
            volumeSoundDebounce.restart();
            const maxAllowedIncrease = Config.options.audio.protection.maxAllowedIncrease / 100;
            const maxAllowed = Config.options.audio.protection.maxAllowed / 100;
            if (newVolume - lastVolume > maxAllowedIncrease) {
                sink.audio.volume = lastVolume;
            } else if (newVolume > maxAllowed || newVolume > root.hardMaxValue) {
                sink.audio.volume = Math.min(lastVolume, maxAllowed);
            }
            lastVolume = sink.audio.volume;
        }
        function onMutedChanged() { if (lastReady) volumeSoundDebounce.restart() }
    }

    // --- Testable pure JS functions ---
    function _computeStep(currentVolume) {
        return currentVolume < 0.1 ? 0.01 : 0.02;
    }

    function _incrementVolume(currentVolume) {
        const step = _computeStep(currentVolume);
        return Math.min(1, currentVolume + step);
    }

    function _decrementVolume(currentVolume) {
        const step = _computeStep(currentVolume);
        return Math.max(0, currentVolume - step);
    }

    function _shouldProtect(lastVolume, newVolume, maxAllowedIncrease, maxAllowed) {
        if (newVolume - lastVolume > maxAllowedIncrease) return "increment";
        if (newVolume > maxAllowed) return "exceeded";
        return "ok";
    }
}
