import QtQuick
import QtTest

TestCase {
    name: "Battery"

    function deriveState(percentage, isCharging, lowThreshold, criticalThreshold, fullThreshold) {
        if (isCharging) return "charging";
        if (percentage <= criticalThreshold) return "critical";
        if (percentage <= lowThreshold) return "low";
        if (percentage >= fullThreshold) return "full";
        return "discharging";
    }

    function healthPercent(hp) {
        if (hp === 0) return 0.01;
        if (hp < 1) return hp * 100;
        return hp;
    }

    function iconForState(state, percentage) {
        if (state === "charging") return "battery_charging_full";
        if (state === "critical") return "battery_alert";
        if (state === "low") return "battery_2_bar";
        if (state === "full") return "battery_full";
        if (percentage > 0.75) return "battery_5_bar";
        if (percentage > 0.50) return "battery_4_bar";
        if (percentage > 0.25) return "battery_3_bar";
        return "battery_2_bar";
    }

    function formatTime(seconds) {
        if (seconds <= 0) return "";
        var h = Math.floor(seconds / 3600);
        var m = Math.floor((seconds % 3600) / 60);
        if (h === 0 && m === 0) return "< 1m";
        if (h === 0) return `${m}m`;
        return `${h}h ${m}m`;
    }

    // --- state derivation ---
    function test_state_critical() { compare(deriveState(0.05, false, 0.20, 0.05, 1.01), "critical"); }
    function test_state_low() { compare(deriveState(0.15, false, 0.20, 0.05, 1.01), "low"); }
    function test_state_full() { compare(deriveState(1.0, false, 0.20, 0.05, 1.0), "full"); }
    function test_state_charging() { compare(deriveState(0.50, true, 0.20, 0.05, 1.01), "charging"); }
    function test_state_discharging() { compare(deriveState(0.50, false, 0.20, 0.05, 1.01), "discharging"); }
    function test_state_charging_overrides() { compare(deriveState(0.05, true, 0.20, 0.05, 1.01), "charging"); }

    // --- health ---
    function test_health_zero() { compare(healthPercent(0), 0.01); }
    function test_health_decimal() { compare(healthPercent(0.85), 85); }
    function test_health_whole() { compare(healthPercent(92), 92); }
    function test_health_full() { compare(healthPercent(100), 100); }

    // --- icon selection ---
    function test_icon_charging() { compare(iconForState("charging", 0.5), "battery_charging_full"); }
    function test_icon_critical() { compare(iconForState("critical", 0.03), "battery_alert"); }
    function test_icon_low() { compare(iconForState("low", 0.15), "battery_2_bar"); }
    function test_icon_full() { compare(iconForState("full", 1.0), "battery_full"); }
    function test_icon_high() { compare(iconForState("discharging", 0.80), "battery_5_bar"); }
    function test_icon_mid() { compare(iconForState("discharging", 0.55), "battery_4_bar"); }
    function test_icon_low_mid() { compare(iconForState("discharging", 0.30), "battery_3_bar"); }
    function test_icon_very_low() { compare(iconForState("discharging", 0.20), "battery_2_bar"); }

    // --- time format ---
    function test_time_1h30m() { compare(formatTime(5400), "1h 30m"); }
    function test_time_less_than_1m() { compare(formatTime(30), "< 1m"); }
    function test_time_zero() { compare(formatTime(0), ""); }
    function test_time_negative() { compare(formatTime(-100), ""); }
    function test_time_minutes_only() { compare(formatTime(300), "5m"); }
    function test_time_hours_only() { compare(formatTime(7200), "2h 0m"); }
}
