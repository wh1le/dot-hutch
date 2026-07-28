import QtQuick
import QtTest

TestCase {
    name: "HyprlandXkb"

    function parseLayoutLine(line, targetDescription) {
        if (!line.trim() || line.trim().startsWith('!')) return null;
        const matchLayout = line.match(/^\s*(\S+)\s+(.+)$/);
        if (matchLayout && matchLayout[2] === targetDescription) return matchLayout[1];
        const matchVariant = line.match(/^\s*(\S+)\s+(\S+)\s+(.+)$/);
        if (matchVariant && matchVariant[3] === targetDescription) return matchVariant[2] + matchVariant[1];
        return null;
    }

    function layoutNameToCode(name) {
        if (!name || name.length === 0) return "??";
        return name.substring(0, 2).toLowerCase();
    }

    // --- layout line parsing ---
    function test_parse_english_us() {
        compare(parseLayoutLine("  us              English (US)", "English (US)"), "us");
    }
    function test_parse_portuguese() {
        compare(parseLayoutLine("  pt              Portuguese", "Portuguese"), "pt");
    }
    function test_parse_comment_line() {
        compare(parseLayoutLine("! layout", "English (US)"), null);
    }
    function test_parse_empty_line() {
        compare(parseLayoutLine("   ", "English (US)"), null);
    }
    function test_parse_no_match() {
        compare(parseLayoutLine("  de              German", "English (US)"), null);
    }
    function test_parse_variant() {
        compare(parseLayoutLine("  dvorak          us              English (Dvorak)", "English (Dvorak)"), "usdvorak");
    }

    // --- name to code ---
    function test_code_english() { compare(layoutNameToCode("English"), "en"); }
    function test_code_portuguese() { compare(layoutNameToCode("Portuguese"), "po"); }
    function test_code_empty() { compare(layoutNameToCode(""), "??"); }
    function test_code_null() { compare(layoutNameToCode(null), "??"); }
    function test_code_short() { compare(layoutNameToCode("A"), "a"); }
}
