pragma Singleton
import Quickshell

Singleton {
    id: root

    function cleanMusicTitle(title) {
        if (!title) return "";
        title = title.replace(/^ *\([^)]*\) */g, " ");
        title = title.replace(/^ *\[[^\]]*\] */g, " ");
        title = title.replace(/^ *\{[^\}]*\} */g, " ");
        title = title.replace(/^ *【[^】]*】/, "");
        title = title.replace(/^ *《[^》]*》/, "");
        title = title.replace(/^ *「[^」]*」/, "");
        title = title.replace(/^ *『[^』]*』/, "");
        return title.trim();
    }

    function friendlyTimeForSeconds(seconds) {
        if (isNaN(seconds) || seconds < 0) return "0:00";
        seconds = Math.floor(seconds);
        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);
        const s = seconds % 60;
        if (h > 0) return `${h}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
        return `${m}:${s.toString().padStart(2, '0')}`;
    }
}
