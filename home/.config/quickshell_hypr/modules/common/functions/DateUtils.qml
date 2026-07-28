pragma Singleton
import Quickshell

Singleton {
    id: root

    // Month number (1-12) to emoji mapping, matching ironbar date-emoji script
    function monthEmoji(month) {
        var m = parseInt(month);
        if (isNaN(m) || m < 1 || m > 12) return "\u{1F4C5}"; // fallback: 📅
        var emojis = [
            "\u2744\uFE0F",   // 1:  ❄️
            "\u{1F475}\u{1F3FB}", // 2: 👵🏻
            "\u{1F469}\u{1F3FB}", // 3: 👩🏻
            "\u{1FABB}",      // 4:  🪻
            "\u{1F33C}",      // 5:  🌼
            "\u2600\uFE0F",   // 6:  ☀️
            "\u{1F382}",      // 7:  🎂
            "\u{1F349}",      // 8:  🍉
            "\u{1F342}",      // 9:  🍂
            "\u{1FAD6}",      // 10: 🫖
            "\u2603\uFE0F",   // 11: ☃️
            "\u{1F384}"       // 12: 🎄
        ];
        return emojis[m - 1];
    }
}
