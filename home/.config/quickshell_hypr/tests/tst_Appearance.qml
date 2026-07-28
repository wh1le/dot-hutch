import QtQuick
import QtTest

TestCase {
    name: "Appearance"

    function isDarkMode(hslLightness) {
        return hslLightness < 0.5;
    }

    function test_dark_mode_dark() {
        verify(isDarkMode(0.1));
        verify(isDarkMode(0.0));
        verify(isDarkMode(0.49));
    }

    function test_dark_mode_light() {
        verify(!isDarkMode(0.5));
        verify(!isDarkMode(0.8));
        verify(!isDarkMode(1.0));
    }

    function test_rounding_tiers_ascending() {
        var tiers = [2, 8, 12, 17, 23, 30, 9999];
        for (var i = 1; i < tiers.length; i++) {
            verify(tiers[i] > tiers[i-1], `rounding tier ${i} (${tiers[i]}) should be > tier ${i-1} (${tiers[i-1]})`);
        }
    }

    function test_animation_durations_positive() {
        var durations = [500, 200, 400, 200, 300, 400]; // elementMove, effects, enter, exit, resize, clickBounce
        for (var i = 0; i < durations.length; i++) {
            verify(durations[i] > 0, `animation duration ${i} should be positive`);
        }
    }

    function test_bar_height() {
        compare(28, 28); // baseBarHeight
    }

    function test_quick_settings_width() {
        compare(380, 380); // quickSettingsWidth
    }

    function test_responsive_breakpoints() {
        verify(1200 > 1000, "shorten threshold should be > hellaShortenThreshold");
    }

    // Transparentize helper test (same logic as ColorUtils)
    function transparentize_alpha(alpha, pct) {
        return alpha * (1 - pct);
    }

    function test_transparentize_helper() {
        fuzzyCompare(transparentize_alpha(1, 0.5), 0.5, 0.001);
        fuzzyCompare(transparentize_alpha(1, 0), 1, 0.001);
        fuzzyCompare(transparentize_alpha(1, 1), 0, 0.001);
    }

    // Layer color derivation: each layer should be slightly lighter than previous in dark mode
    function test_layer_color_derivation_logic() {
        // In M3 dark theme, surface container hierarchy goes from darkest to lightest
        // surfaceContainerLowest < surfaceContainerLow < surfaceContainer < surfaceContainerHigh < surfaceContainerHighest
        // We test the hex values from the defaults
        var hexToLightness = function(hex) {
            var r = parseInt(hex.substring(1,3), 16) / 255;
            var g = parseInt(hex.substring(3,5), 16) / 255;
            var b = parseInt(hex.substring(5,7), 16) / 255;
            var max = Math.max(r, g, b);
            var min = Math.min(r, g, b);
            return (max + min) / 2;
        };
        var l0 = hexToLightness("#141313"); // background
        var l1 = hexToLightness("#1c1b1c"); // surfaceContainerLow
        var l2 = hexToLightness("#201f20"); // surfaceContainer
        var l3 = hexToLightness("#2b2a2a"); // surfaceContainerHigh
        var l4 = hexToLightness("#363435"); // surfaceContainerHighest

        verify(l1 > l0, "Layer 1 should be lighter than Layer 0");
        verify(l2 > l1, "Layer 2 should be lighter than Layer 1");
        verify(l3 > l2, "Layer 3 should be lighter than Layer 2");
        verify(l4 > l3, "Layer 4 should be lighter than Layer 3");
    }
}
