import QtQuick
import QtTest

TestCase {
    name: "DateUtils"

    function monthEmoji(month) {
        var m = parseInt(month);
        if (isNaN(m) || m < 1 || m > 12) return "\u{1F4C5}";
        var emojis = [
            "\u2744\uFE0F",       // 1:  ❄️
            "\u{1F475}\u{1F3FB}", // 2:  👵🏻
            "\u{1F469}\u{1F3FB}", // 3:  👩🏻
            "\u{1FABB}",          // 4:  🪻
            "\u{1F33C}",          // 5:  🌼
            "\u2600\uFE0F",       // 6:  ☀️
            "\u{1F382}",          // 7:  🎂
            "\u{1F349}",          // 8:  🍉
            "\u{1F342}",          // 9:  🍂
            "\u{1FAD6}",          // 10: 🫖
            "\u2603\uFE0F",       // 11: ☃️
            "\u{1F384}"           // 12: 🎄
        ];
        return emojis[m - 1];
    }

    function test_january()  { compare(monthEmoji(1), "\u2744\uFE0F"); }
    function test_february() { compare(monthEmoji(2), "\u{1F475}\u{1F3FB}"); }
    function test_march()    { compare(monthEmoji(3), "\u{1F469}\u{1F3FB}"); }
    function test_april()    { compare(monthEmoji(4), "\u{1FABB}"); }
    function test_may()      { compare(monthEmoji(5), "\u{1F33C}"); }
    function test_june()     { compare(monthEmoji(6), "\u2600\uFE0F"); }
    function test_july()     { compare(monthEmoji(7), "\u{1F382}"); }
    function test_august()   { compare(monthEmoji(8), "\u{1F349}"); }
    function test_september(){ compare(monthEmoji(9), "\u{1F342}"); }
    function test_october()  { compare(monthEmoji(10), "\u{1FAD6}"); }
    function test_november() { compare(monthEmoji(11), "\u2603\uFE0F"); }
    function test_december() { compare(monthEmoji(12), "\u{1F384}"); }

    // Edge cases
    function test_month_0()        { compare(monthEmoji(0), "\u{1F4C5}"); }
    function test_month_13()       { compare(monthEmoji(13), "\u{1F4C5}"); }
    function test_month_negative() { compare(monthEmoji(-1), "\u{1F4C5}"); }
    function test_month_null()     { compare(monthEmoji(null), "\u{1F4C5}"); }
    function test_month_undefined(){ compare(monthEmoji(undefined), "\u{1F4C5}"); }
    function test_month_string()   { compare(monthEmoji("3"), "\u{1F469}\u{1F3FB}"); }
}
