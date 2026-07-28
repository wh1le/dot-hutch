pragma Singleton
import QtQuick
import "../modules/common"
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    signal gammaChangeAttempt()

    readonly property real gammaLowerLimit: 25
    property string from: Config.options?.light?.night?.from ?? "19:00"
    property string to: Config.options?.light?.night?.to ?? "06:30"
    property bool automatic: Config.options?.light?.night?.automatic && (Config?.ready ?? true)
    property int colorTemperature: Config.options?.light?.night?.colorTemperature ?? 5000
    property int gamma: 100
    property bool shouldBeOn
    property bool firstEvaluation: true
    property bool temperatureActive: false

    property int fromHour: Number(from.split(":")[0])
    property int fromMinute: Number(from.split(":")[1])
    property int toHour: Number(to.split(":")[0])
    property int toMinute: Number(to.split(":")[1])

    property int clockHour: DateTime.clock.hours
    property int clockMinute: DateTime.clock.minutes

    property var manualActive
    property int manualActiveHour
    property int manualActiveMinute

    onClockMinuteChanged: reEvaluate()
    onAutomaticChanged: { root.manualActive = undefined; root.firstEvaluation = true; reEvaluate(); }

    function inBetween(t, from, to) {
        if (from < to) return (t >= from && t <= to);
        return (t >= from || t <= to);
    }

    function reEvaluate() {
        const t = clockHour * 60 + clockMinute;
        const f = fromHour * 60 + fromMinute;
        const to_ = toHour * 60 + toMinute;
        const ma = manualActiveHour * 60 + manualActiveMinute;
        if (root.manualActive !== undefined && (inBetween(f, ma, t) || inBetween(to_, ma, t))) root.manualActive = undefined;
        root.shouldBeOn = inBetween(t, f, to_);
        if (firstEvaluation) { firstEvaluation = false; root.ensureState(); }
    }

    onShouldBeOnChanged: ensureState()
    function ensureState() {
        if (!root.automatic || root.manualActive !== undefined) return;
        if (root.shouldBeOn) root.enableTemperature();
        else root.disableTemperature();
    }

    function load() {
        Quickshell.execDetached(["bash", "-c", "pidof hyprsunset || hyprsunset"]);
        root.ensureState();
    }

    function enableTemperature() {
        root.temperatureActive = true;
        Quickshell.execDetached(["bash", "-c", "pidof hyprsunset || hyprsunset"]);
        Quickshell.execDetached(["bash", "-c", `hyprctl hyprsunset temperature ${root.colorTemperature}`]);
    }

    function disableTemperature() {
        root.temperatureActive = false;
        Quickshell.execDetached(["hyprctl", "hyprsunset", "identity"]);
    }

    function setGamma(gamma) {
        root.gamma = Math.max(root.gammaLowerLimit, Math.min(100, gamma));
        root.gammaChangeAttempt();
        Quickshell.execDetached(["bash", "-c", `hyprctl hyprsunset gamma ${root.gamma}`]);
    }

    function toggleTemperature(active = undefined) {
        if (root.manualActive === undefined) {
            root.manualActive = root.temperatureActive;
            root.manualActiveHour = root.clockHour;
            root.manualActiveMinute = root.clockMinute;
        }
        root.manualActive = active !== undefined ? active : !root.manualActive;
        if (root.manualActive) root.enableTemperature();
        else root.disableTemperature();
    }

    // --- Testable pure JS functions ---
    function _inBetween(t, from, to) {
        if (from < to) return (t >= from && t <= to);
        return (t >= from || t <= to);
    }

    function _clampGamma(gamma) {
        return Math.max(25, Math.min(100, gamma));
    }
}
