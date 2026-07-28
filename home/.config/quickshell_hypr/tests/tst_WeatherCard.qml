import QtQuick
import QtTest

TestCase {
    name: "WeatherCard"

    function formatTemp(celsius) {
        return `${Math.round(celsius)}°C`;
    }

    function windDirection(degrees) {
        if (degrees < 22.5) return "N";
        if (degrees < 67.5) return "NE";
        if (degrees < 112.5) return "E";
        if (degrees < 157.5) return "SE";
        if (degrees < 202.5) return "S";
        if (degrees < 247.5) return "SW";
        if (degrees < 292.5) return "W";
        if (degrees < 337.5) return "NW";
        return "N";
    }

    function formatHumidity(percent) {
        return `${Math.round(Math.max(0, Math.min(100, percent)))}%`;
    }

    // --- temperature ---
    function test_temp_positive() { compare(formatTemp(22), "22°C"); }
    function test_temp_negative() { compare(formatTemp(-5), "-5°C"); }
    function test_temp_zero() { compare(formatTemp(0), "0°C"); }
    function test_temp_decimal() { compare(formatTemp(22.7), "23°C"); }
    function test_temp_large() { compare(formatTemp(42.3), "42°C"); }

    // --- wind direction ---
    function test_wind_north() { compare(windDirection(0), "N"); }
    function test_wind_east() { compare(windDirection(90), "E"); }
    function test_wind_south() { compare(windDirection(180), "S"); }
    function test_wind_west() { compare(windDirection(270), "W"); }
    function test_wind_northeast() { compare(windDirection(45), "NE"); }
    function test_wind_southeast() { compare(windDirection(135), "SE"); }
    function test_wind_southwest() { compare(windDirection(225), "SW"); }
    function test_wind_northwest() { compare(windDirection(315), "NW"); }
    function test_wind_360() { compare(windDirection(360), "N"); }

    // --- humidity ---
    function test_humidity_normal() { compare(formatHumidity(65), "65%"); }
    function test_humidity_zero() { compare(formatHumidity(0), "0%"); }
    function test_humidity_100() { compare(formatHumidity(100), "100%"); }
    function test_humidity_over() { compare(formatHumidity(120), "100%"); }
    function test_humidity_negative() { compare(formatHumidity(-10), "0%"); }
    function test_humidity_decimal() { compare(formatHumidity(65.7), "66%"); }

    // --- empty/null fallback ---
    function test_empty_weather() {
        var text = "";
        var display = text || "No data";
        compare(display, "No data");
    }
    function test_null_weather() {
        var text = null;
        var display = text || "No data";
        compare(display, "No data");
    }
}
