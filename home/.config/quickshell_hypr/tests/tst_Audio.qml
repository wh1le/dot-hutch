import QtQuick
import QtTest

TestCase {
    name: "Audio"

    function computeStep(currentVolume) {
        return currentVolume < 0.1 ? 0.01 : 0.02;
    }

    function incrementVolume(currentVolume) {
        return Math.min(1, currentVolume + computeStep(currentVolume));
    }

    function decrementVolume(currentVolume) {
        return Math.max(0, currentVolume - computeStep(currentVolume));
    }

    function shouldProtect(lastVolume, newVolume, maxAllowedIncrease, maxAllowed) {
        if (newVolume - lastVolume > maxAllowedIncrease) return "increment";
        if (newVolume > maxAllowed) return "exceeded";
        return "ok";
    }

    // --- step sizes ---
    function test_step_low_volume() { compare(computeStep(0.05), 0.01); }
    function test_step_normal_volume() { compare(computeStep(0.5), 0.02); }
    function test_step_boundary() { compare(computeStep(0.1), 0.02); }
    function test_step_zero() { compare(computeStep(0), 0.01); }

    // --- increment ---
    function test_increment_normal() { fuzzyCompare(incrementVolume(0.5), 0.52, 0.001); }
    function test_increment_low() { fuzzyCompare(incrementVolume(0.05), 0.06, 0.001); }
    function test_increment_clamp_at_1() { compare(incrementVolume(0.99), 1); }
    function test_increment_at_1() { compare(incrementVolume(1.0), 1); }

    // --- decrement ---
    function test_decrement_normal() { fuzzyCompare(decrementVolume(0.5), 0.48, 0.001); }
    function test_decrement_low() { fuzzyCompare(decrementVolume(0.05), 0.04, 0.001); }
    function test_decrement_clamp_at_0() { compare(decrementVolume(0.01), 0); }
    function test_decrement_at_0() { compare(decrementVolume(0), 0); }

    // --- protection ---
    function test_protect_normal_change() { compare(shouldProtect(0.5, 0.52, 0.1, 0.99), "ok"); }
    function test_protect_sudden_jump() { compare(shouldProtect(0.5, 0.8, 0.1, 0.99), "increment"); }
    function test_protect_exceeded_max() { compare(shouldProtect(0.5, 1.0, 0.5, 0.99), "exceeded"); }
    function test_protect_decrease_ok() { compare(shouldProtect(0.5, 0.3, 0.1, 0.99), "ok"); }

    // --- mute toggle ---
    function test_mute_toggle() {
        var muted = false;
        muted = !muted; verify(muted);
        muted = !muted; verify(!muted);
        muted = !muted; verify(muted);
    }
}
