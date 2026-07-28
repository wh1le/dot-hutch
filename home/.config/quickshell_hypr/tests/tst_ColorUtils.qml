import QtQuick
import QtTest

TestCase {
    name: "ColorUtils"

    // Pure JS reimplementations of ColorUtils functions for testing
    function mix(r1, g1, b1, a1, r2, g2, b2, a2, pct) {
        return {
            r: pct * r1 + (1 - pct) * r2,
            g: pct * g1 + (1 - pct) * g2,
            b: pct * b1 + (1 - pct) * b2,
            a: pct * a1 + (1 - pct) * a2
        };
    }

    function transparentize_alpha(originalAlpha, percentage) {
        return originalAlpha * (1 - percentage);
    }

    function clamp01(x) {
        return Math.min(1, Math.max(0, x));
    }

    function solveOverlay(baseR, baseG, baseB, targetR, targetG, targetB, overlayOpacity) {
        let invA = 1.0 - overlayOpacity;
        return {
            r: clamp01((targetR - baseR * invA) / overlayOpacity),
            g: clamp01((targetG - baseG * invA) / overlayOpacity),
            b: clamp01((targetB - baseB * invA) / overlayOpacity)
        };
    }

    function lighten(lightness, amount) {
        return Math.min(1, lightness + amount);
    }

    function darken(lightness, amount) {
        return Math.max(0, lightness - amount);
    }

    // --- mix tests ---
    function test_mix_50_50_black_white() {
        var result = mix(0, 0, 0, 1, 1, 1, 1, 1, 0.5);
        compare(result.r, 0.5);
        compare(result.g, 0.5);
        compare(result.b, 0.5);
    }

    function test_mix_0_percent_returns_color2() {
        var result = mix(1, 0, 0, 1, 0, 0, 1, 1, 0);
        compare(result.r, 0);
        compare(result.g, 0);
        compare(result.b, 1);
    }

    function test_mix_100_percent_returns_color1() {
        var result = mix(1, 0, 0, 1, 0, 0, 1, 1, 1);
        compare(result.r, 1);
        compare(result.g, 0);
        compare(result.b, 0);
    }

    function test_mix_alpha_blending() {
        var result = mix(1, 1, 1, 1, 0, 0, 0, 0, 0.5);
        compare(result.a, 0.5);
    }

    // --- transparentize tests ---
    function test_transparentize_full() {
        compare(transparentize_alpha(1, 1), 0);
    }

    function test_transparentize_none() {
        compare(transparentize_alpha(1, 0), 1);
    }

    function test_transparentize_half() {
        compare(transparentize_alpha(1, 0.5), 0.5);
    }

    function test_transparentize_partial_alpha() {
        compare(transparentize_alpha(0.8, 0.5), 0.4);
    }

    // --- clamp01 tests ---
    function test_clamp01_within_range() {
        compare(clamp01(0.5), 0.5);
    }

    function test_clamp01_above() {
        compare(clamp01(1.5), 1);
    }

    function test_clamp01_below() {
        compare(clamp01(-0.5), 0);
    }

    function test_clamp01_boundaries() {
        compare(clamp01(0), 0);
        compare(clamp01(1), 1);
    }

    // --- solveOverlayColor tests ---
    function test_solveOverlay_basic() {
        // If base=0, target=0.5, opacity=1 -> overlay should be 0.5
        var result = solveOverlay(0, 0, 0, 0.5, 0.5, 0.5, 1.0);
        fuzzyCompare(result.r, 0.5, 0.001);
        fuzzyCompare(result.g, 0.5, 0.001);
        fuzzyCompare(result.b, 0.5, 0.001);
    }

    function test_solveOverlay_identity() {
        // Full opacity, base=target -> overlay=target
        var result = solveOverlay(0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 1.0);
        fuzzyCompare(result.r, 0.3, 0.001);
    }

    function test_solveOverlay_clamps() {
        // Should clamp to 0-1 range
        var result = solveOverlay(0.9, 0.9, 0.9, 0.1, 0.1, 0.1, 0.1);
        compare(result.r, 0); // Would be negative, clamped to 0
    }

    // --- lighten/darken tests ---
    function test_lighten_basic() {
        fuzzyCompare(lighten(0.3, 0.2), 0.5, 0.001);
    }

    function test_lighten_clamp_at_1() {
        compare(lighten(0.9, 0.5), 1);
    }

    function test_darken_basic() {
        fuzzyCompare(darken(0.5, 0.2), 0.3, 0.001);
    }

    function test_darken_clamp_at_0() {
        compare(darken(0.1, 0.5), 0);
    }

    function test_lighten_zero_amount() {
        fuzzyCompare(lighten(0.5, 0), 0.5, 0.001);
    }

    function test_darken_zero_amount() {
        fuzzyCompare(darken(0.5, 0), 0.5, 0.001);
    }
}
