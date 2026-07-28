import QtQuick
import QtTest

TestCase {
    name: "MaterialThemeLoader"

    function snakeToCamel(str) {
        return str.replace(/_([a-z])/g, (g) => g[1].toUpperCase());
    }

    function parseThemeJson(jsonString) {
        try {
            const json = JSON.parse(jsonString);
            const result = {};
            for (const key in json) {
                if (json.hasOwnProperty(key)) {
                    const camelCaseKey = snakeToCamel(key);
                    result[`m3${camelCaseKey}`] = json[key];
                }
            }
            return result;
        } catch (e) {
            return null;
        }
    }

    // --- snakeToCamel tests ---
    function test_snake_to_camel_primary_container() {
        compare(snakeToCamel("primary_container"), "primaryContainer");
    }

    function test_snake_to_camel_on_error_container() {
        compare(snakeToCamel("on_error_container"), "onErrorContainer");
    }

    function test_snake_to_camel_single_word() {
        compare(snakeToCamel("primary"), "primary");
    }

    function test_snake_to_camel_surface_container_highest() {
        compare(snakeToCamel("surface_container_highest"), "surfaceContainerHighest");
    }

    function test_snake_to_camel_already_camel() {
        compare(snakeToCamel("alreadyCamel"), "alreadyCamel");
    }

    // --- parseThemeJson tests ---
    function test_parse_valid_json() {
        var result = parseThemeJson('{"primary": "#cbc4cb", "on_primary": "#322f34"}');
        compare(result["m3primary"], "#cbc4cb");
        compare(result["m3onPrimary"], "#322f34");
    }

    function test_parse_empty_json() {
        var result = parseThemeJson('{}');
        compare(Object.keys(result).length, 0);
    }

    function test_parse_malformed_json() {
        var result = parseThemeJson('not json at all');
        compare(result, null);
    }

    function test_parse_incomplete_json() {
        var result = parseThemeJson('{"key": ');
        compare(result, null);
    }

    function test_parse_color_property_mapping() {
        var result = parseThemeJson('{"surface_container_low": "#1c1b1c"}');
        compare(result["m3surfaceContainerLow"], "#1c1b1c");
    }

    function test_parse_missing_keys() {
        var result = parseThemeJson('{"background": "#141313"}');
        compare(result["m3background"], "#141313");
        compare(result["m3primary"], undefined);
    }

    function test_parse_empty_string() {
        var result = parseThemeJson('');
        compare(result, null);
    }

    function test_m3_prefix() {
        var result = parseThemeJson('{"error": "#ffb4ab"}');
        verify(result.hasOwnProperty("m3error"));
        verify(!result.hasOwnProperty("error"));
    }
}
