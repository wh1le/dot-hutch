pragma Singleton
import "../modules/common"
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    id: root
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice?.percentage ?? 1

    property bool isLow: available && (percentage <= Config.options.battery.low / 100)
    property bool isCritical: available && (percentage <= Config.options.battery.critical / 100)
    property bool isFull: available && (percentage >= Config.options.battery.full / 100)

    property real energyRate: UPower.displayDevice.changeRate
    property real timeToEmpty: UPower.displayDevice.timeToEmpty
    property real timeToFull: UPower.displayDevice.timeToFull

    property real health: (function() {
        const devList = UPower.devices.values;
        for (let i = 0; i < devList.length; ++i) {
            const dev = devList[i];
            if (dev.isLaptopBattery && dev.healthSupported) {
                const h = dev.healthPercentage;
                if (h === 0) return 0.01;
                else if (h < 1) return h * 100;
                else return h;
            }
        }
        return 0;
    })()

    onIsLow: {
        if (!root.available || !isLow || isCharging) return;
        Quickshell.execDetached(["notify-send", "Low battery", "Consider plugging in your device", "-u", "critical", "-a", "Shell", "--hint=int:transient:1"])
    }

    onIsCritical: {
        if (!root.available || !isCritical || isCharging) return;
        if (Config.options.battery.automaticSuspend && percentage <= Config.options.battery.suspend / 100)
            Quickshell.execDetached(["bash", "-c", "systemctl suspend || loginctl suspend"]);
    }

    // --- Testable pure JS functions ---
    function _deriveState(percentage, isCharging, lowThreshold, criticalThreshold, fullThreshold) {
        if (isCharging) return "charging";
        if (percentage <= criticalThreshold) return "critical";
        if (percentage <= lowThreshold) return "low";
        if (percentage >= fullThreshold) return "full";
        return "discharging";
    }

    function _healthPercent(healthPercentage) {
        if (healthPercentage === 0) return 0.01;
        if (healthPercentage < 1) return healthPercentage * 100;
        return healthPercentage;
    }

    function _iconForState(state, percentage) {
        if (state === "charging") return "battery_charging_full";
        if (state === "critical") return "battery_alert";
        if (state === "low") return "battery_2_bar";
        if (state === "full") return "battery_full";
        if (percentage > 0.75) return "battery_5_bar";
        if (percentage > 0.50) return "battery_4_bar";
        if (percentage > 0.25) return "battery_3_bar";
        return "battery_2_bar";
    }

    function _formatTime(seconds) {
        if (seconds <= 0) return "";
        var h = Math.floor(seconds / 3600);
        var m = Math.floor((seconds % 3600) / 60);
        if (h === 0 && m === 0) return "< 1m";
        if (h === 0) return `${m}m`;
        return `${h}h ${m}m`;
    }
}
