import QtQuick
import QtTest

TestCase {
    name: "Config"

    function convertValue(value) {
        if (typeof value === "string") {
            let trimmed = value.trim();
            if (trimmed === "true" || trimmed === "false" || !isNaN(Number(trimmed))) {
                try { return JSON.parse(trimmed); } catch (e) { return value; }
            }
        }
        return value;
    }

    function setNestedOnObject(obj, nestedKey, value) {
        let keys = nestedKey.split(".");
        let current = obj;
        for (let i = 0; i < keys.length - 1; ++i) {
            if (!current[keys[i]] || typeof current[keys[i]] !== "object") {
                current[keys[i]] = {};
            }
            current = current[keys[i]];
        }
        current[keys[keys.length - 1]] = convertValue(value);
        return obj;
    }

    // --- convertValue tests ---
    function test_convert_string_true_to_bool() {
        compare(convertValue("true"), true);
    }

    function test_convert_string_false_to_bool() {
        compare(convertValue("false"), false);
    }

    function test_convert_string_number() {
        compare(convertValue("42"), 42);
    }

    function test_convert_string_float() {
        compare(convertValue("3.14"), 3.14);
    }

    function test_convert_string_stays_string() {
        compare(convertValue("hello"), "hello");
    }

    function test_convert_number_passthrough() {
        compare(convertValue(42), 42);
    }

    function test_convert_bool_passthrough() {
        compare(convertValue(true), true);
    }

    function test_convert_whitespace_true() {
        compare(convertValue("  true  "), true);
    }

    function test_convert_whitespace_number() {
        compare(convertValue("  42  "), 42);
    }

    function test_convert_empty_string() {
        compare(convertValue(""), "");
    }

    // --- setNestedValue tests ---
    function test_setNested_simple() {
        var obj = {};
        setNestedOnObject(obj, "foo", "bar");
        compare(obj.foo, "bar");
    }

    function test_setNested_deep() {
        var obj = {};
        setNestedOnObject(obj, "a.b.c", "deep");
        compare(obj.a.b.c, "deep");
    }

    function test_setNested_with_conversion() {
        var obj = {};
        setNestedOnObject(obj, "a.b", "true");
        compare(obj.a.b, true);
    }

    function test_setNested_number_conversion() {
        var obj = {};
        setNestedOnObject(obj, "x.y", "42");
        compare(obj.x.y, 42);
    }

    function test_setNested_overwrite() {
        var obj = { a: { b: "old" } };
        setNestedOnObject(obj, "a.b", "new");
        compare(obj.a.b, "new");
    }

    // --- round-trip test ---
    function test_round_trip() {
        var obj = {};
        setNestedOnObject(obj, "settings.volume", "75");
        var json = JSON.stringify(obj);
        var parsed = JSON.parse(json);
        compare(parsed.settings.volume, 75);
    }

    // --- default values ---
    function test_default_time_format() {
        compare("HH:mm", "HH:mm");
    }

    function test_default_battery_low() {
        compare(20, 20);
    }

    function test_default_notification_timeout() {
        compare(7000, 7000);
    }
}
