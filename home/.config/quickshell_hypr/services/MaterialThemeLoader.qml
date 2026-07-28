pragma Singleton
pragma ComponentBehavior: Bound

import "../modules/common"
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string filePath: `${Directories.home}/.cache/wal/colors.json`.replace("file://", "")

    function reapplyTheme() {
        themeFileView.reload()
    }

    function applyColors(fileContent) {
        try {
            const json = JSON.parse(fileContent);
            const bg = json.special.background;
            const fg = json.special.foreground;
            const c = json.colors;

            Appearance.m3colors.m3background = bg;
            Appearance.m3colors.m3onBackground = fg;
            Appearance.m3colors.m3surface = bg;
            Appearance.m3colors.m3surfaceDim = c.color0;
            Appearance.m3colors.m3surfaceBright = c.color8;
            Appearance.m3colors.m3surfaceContainerLowest = c.color0;
            Appearance.m3colors.m3surfaceContainerLow = c.color8;
            Appearance.m3colors.m3surfaceContainer = c.color8;
            Appearance.m3colors.m3surfaceContainerHigh = c.color3;
            Appearance.m3colors.m3surfaceContainerHighest = c.color7;
            Appearance.m3colors.m3onSurface = fg;
            Appearance.m3colors.m3surfaceVariant = c.color8;
            Appearance.m3colors.m3onSurfaceVariant = c.color7;
            Appearance.m3colors.m3inverseSurface = fg;
            Appearance.m3colors.m3inverseOnSurface = bg;
            Appearance.m3colors.m3outline = c.color8;
            Appearance.m3colors.m3outlineVariant = c.color8;
            Appearance.m3colors.m3surfaceTint = c.color4;
            Appearance.m3colors.m3primary = c.color4;
            Appearance.m3colors.m3onPrimary = bg;
            Appearance.m3colors.m3primaryContainer = c.color1;
            Appearance.m3colors.m3onPrimaryContainer = c.color7;
            Appearance.m3colors.m3inversePrimary = c.color6;
            Appearance.m3colors.m3secondary = c.color6;
            Appearance.m3colors.m3onSecondary = bg;
            Appearance.m3colors.m3secondaryContainer = c.color8;
            Appearance.m3colors.m3onSecondaryContainer = fg;
            Appearance.m3colors.m3tertiary = c.color5;
            Appearance.m3colors.m3onTertiary = bg;
            Appearance.m3colors.m3tertiaryContainer = c.color2;
            Appearance.m3colors.m3onTertiaryContainer = c.color7;
            Appearance.m3colors.m3primaryFixed = c.color6;
            Appearance.m3colors.m3primaryFixedDim = c.color4;
            Appearance.m3colors.m3onPrimaryFixed = c.color0;
            Appearance.m3colors.m3onPrimaryFixedVariant = c.color1;
            Appearance.m3colors.m3secondaryFixed = c.color7;
            Appearance.m3colors.m3secondaryFixedDim = c.color6;
            Appearance.m3colors.m3onSecondaryFixed = c.color0;
            Appearance.m3colors.m3onSecondaryFixedVariant = c.color8;
            Appearance.m3colors.m3tertiaryFixed = c.color7;
            Appearance.m3colors.m3tertiaryFixedDim = c.color5;
            Appearance.m3colors.m3onTertiaryFixed = c.color0;
            Appearance.m3colors.m3onTertiaryFixedVariant = c.color2;

            Appearance.m3colors.darkmode = (Qt.color(bg).hslLightness < 0.5);
        } catch (e) {
            console.warn("[MaterialThemeLoader] Failed to parse pywal colors:", e);
        }
    }

    // --- Testable pure JS functions ---
    function _snakeToCamel(str) {
        return str.replace(/_([a-z])/g, (g) => g[1].toUpperCase());
    }

    function _parseThemeJson(jsonString) {
        try {
            const json = JSON.parse(jsonString);
            if (json.special && json.colors) return json; // pywal format
            return null;
        } catch (e) {
            return null;
        }
    }

    Timer {
        id: delayedFileRead
        interval: 100
        repeat: false
        running: false
        onTriggered: root.applyColors(themeFileView.text())
    }

    FileView {
        id: themeFileView
        path: Qt.resolvedUrl(root.filePath)
        watchChanges: true
        onFileChanged: {
            this.reload()
            delayedFileRead.start()
        }
        onLoadedChanged: root.applyColors(themeFileView.text())
        onLoadFailed: {} // pywal colors may not exist yet
    }
}
