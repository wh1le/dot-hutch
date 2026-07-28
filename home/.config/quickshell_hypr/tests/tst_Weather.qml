import QtQuick
import QtTest

TestCase {
    name: "Weather"

    function parseWeatherJson(text) {
        try {
            var json = JSON.parse(text.trim());
            return { text: json.text || "", tooltip: json.tooltip || "" };
        } catch (e) {
            return null;
        }
    }

    function test_valid_json() {
        var result = parseWeatherJson('{"text":"☀️ 22°","tooltip":"Sunny"}');
        compare(result.text, "☀️ 22°");
        compare(result.tooltip, "Sunny");
    }
    function test_malformed_json() {
        compare(parseWeatherJson("not json"), null);
    }
    function test_missing_text() {
        var result = parseWeatherJson('{"tooltip":"Sunny"}');
        compare(result.text, "");
        compare(result.tooltip, "Sunny");
    }
    function test_empty_string() {
        compare(parseWeatherJson(""), null);
    }
    function test_empty_json() {
        var result = parseWeatherJson('{}');
        compare(result.text, "");
        compare(result.tooltip, "");
    }
    function test_with_whitespace() {
        var result = parseWeatherJson('  {"text":"🌧 15°","tooltip":"Rain"}  ');
        compare(result.text, "🌧 15°");
    }
    function test_missing_tooltip() {
        var result = parseWeatherJson('{"text":"☁️ 18°"}');
        compare(result.tooltip, "");
    }
}
