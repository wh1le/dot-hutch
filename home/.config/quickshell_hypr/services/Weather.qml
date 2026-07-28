pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "../modules/common"

Singleton {
    id: root
    property string displayText: ""
    property string tooltip: ""

    Component.onCompleted: fetchWeather.running = true

    Timer {
        interval: (Config.options?.bar?.weather?.fetchInterval ?? 30) * 60 * 1000
        running: true
        repeat: true
        onTriggered: fetchWeather.running = true
    }

    Process {
        id: fetchWeather
        command: ["/home/wh1le/.local/bin/public/waybar/weather-forecast", "waybar"]
        stdout: StdioCollector {
            id: weatherCollector
            onStreamFinished: {
                var parsed = root._parseWeatherJson(weatherCollector.text);
                if (parsed) {
                    root.displayText = parsed.text;
                    root.tooltip = parsed.tooltip;
                }
            }
        }
    }

    // --- Testable pure JS functions ---
    function _parseWeatherJson(text) {
        try {
            var json = JSON.parse(text.trim());
            return {
                text: json.text || "",
                tooltip: json.tooltip || ""
            };
        } catch (e) {
            return null;
        }
    }
}
