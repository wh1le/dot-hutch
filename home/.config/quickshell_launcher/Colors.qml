pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "modules"
import "modules/functions"

// Theme palette. m3colors holds the raw Material scheme; its default values are
// loaded from colors.yaml (Config.colors) and overridden at runtime by pywal
// (MaterialThemeLoader, which flips pywalApplied). colors are the derived roles
// the UI reads. Re-exposed through Appearance.m3colors / Appearance.colors.
Singleton {
    id: root
    property QtObject m3colors
    property QtObject colors

    // Set true by MaterialThemeLoader once pywal colors are applied; the yaml
    // defaults must not clobber pywal regardless of yq/pywal load order.
    property bool pywalApplied: false

    // Apply colors.yaml defaults into m3colors, unless pywal already won.
    function applyDefaults() {
        if (pywalApplied)
            return;
        const src = Config.colors ? Config.colors.m3colors : null;
        if (!src)
            return;
        for (const k in src)
            m3colors[k] = src[k];
    }

    Component.onCompleted: applyDefaults()

    Connections {
        target: Config
        function onColorsReadyChanged() { root.applyDefaults(); }
    }

    m3colors: QtObject {
        property bool darkmode: true
        property color m3background
        property color m3onBackground
        property color m3surface
        property color m3surfaceDim
        property color m3surfaceBright
        property color m3surfaceContainerLowest
        property color m3surfaceContainerLow
        property color m3surfaceContainer
        property color m3surfaceContainerHigh
        property color m3surfaceContainerHighest
        property color m3onSurface
        property color m3surfaceVariant
        property color m3onSurfaceVariant
        property color m3inverseSurface
        property color m3inverseOnSurface
        property color m3outline
        property color m3outlineVariant
        property color m3shadow
        property color m3scrim
        property color m3surfaceTint
        property color m3primary
        property color m3onPrimary
        property color m3primaryContainer
        property color m3onPrimaryContainer
        property color m3inversePrimary
        property color m3secondary
        property color m3onSecondary
        property color m3secondaryContainer
        property color m3onSecondaryContainer
        property color m3tertiary
        property color m3onTertiary
        property color m3tertiaryContainer
        property color m3onTertiaryContainer
        property color m3error
        property color m3onError
        property color m3errorContainer
        property color m3onErrorContainer
        property color m3primaryFixed
        property color m3primaryFixedDim
        property color m3onPrimaryFixed
        property color m3onPrimaryFixedVariant
        property color m3secondaryFixed
        property color m3secondaryFixedDim
        property color m3onSecondaryFixed
        property color m3onSecondaryFixedVariant
        property color m3tertiaryFixed
        property color m3tertiaryFixedDim
        property color m3onTertiaryFixed
        property color m3onTertiaryFixedVariant
        property color m3success
        property color m3onSuccess
        property color m3successContainer
        property color m3onSuccessContainer
    }

    colors: QtObject {
        property color colSubtext: m3colors.m3outline
        // Bar/panel background — adaptive: darkens on light themes, lightens slightly on very dark themes
        property color colBarBg: {
            var bg = Qt.color(m3colors.m3background);
            var l = bg.hslLightness;
            if (l < 0.08)
                return ColorUtils.lighten(m3colors.m3background, 0.03);
            else if (l < 0.20)
                return ColorUtils.darken(m3colors.m3background, 0.03);
            else
                return ColorUtils.darken(m3colors.m3background, 0.07);
        }
        // Layer 0
        property color colLayer0: m3colors.m3background
        property color colOnLayer0: m3colors.m3onBackground
        property color colLayer0Hover: ColorUtils.mix(colLayer0, colOnLayer0, 0.9)
        property color colLayer0Active: ColorUtils.mix(colLayer0, colOnLayer0, 0.8)
        // Layer 1
        property color colLayer1: m3colors.m3surfaceContainerLow
        property color colOnLayer1: m3colors.m3onSurfaceVariant
        property color colOnLayer1Inactive: ColorUtils.mix(colOnLayer1, colLayer1, 0.45)
        property color colLayer1Hover: ColorUtils.mix(colLayer1, colOnLayer1, 0.92)
        property color colLayer1Active: ColorUtils.mix(colLayer1, colOnLayer1, 0.85)
        // Layer 2
        property color colLayer2: m3colors.m3surfaceContainer
        property color colLayer2Hover: ColorUtils.mix(m3colors.m3surfaceContainer, m3colors.m3onSurface, 0.90)
        property color colLayer2Active: ColorUtils.mix(m3colors.m3surfaceContainer, m3colors.m3onSurface, 0.80)
        property color colOnLayer2: m3colors.m3onSurface
        // Layer 3
        property color colLayer3: m3colors.m3surfaceContainerHigh
        property color colLayer3Hover: ColorUtils.mix(m3colors.m3surfaceContainerHigh, m3colors.m3onSurface, 0.90)
        property color colLayer3Active: ColorUtils.mix(m3colors.m3surfaceContainerHigh, m3colors.m3onSurface, 0.80)
        property color colOnLayer3: m3colors.m3onSurface
        // Layer 4
        property color colLayer4: m3colors.m3surfaceContainerHighest
        property color colOnLayer4: m3colors.m3onSurface
        // Primary
        property color colPrimary: m3colors.m3primary
        property color colOnPrimary: m3colors.m3onPrimary
        property color colPrimaryHover: ColorUtils.mix(colors.colPrimary, colLayer1Hover, 0.87)
        property color colPrimaryActive: ColorUtils.mix(colors.colPrimary, colLayer1Active, 0.7)
        property color colPrimaryContainer: m3colors.m3primaryContainer
        property color colOnPrimaryContainer: m3colors.m3onPrimaryContainer
        // Secondary
        property color colSecondary: m3colors.m3secondary
        property color colOnSecondary: m3colors.m3onSecondary
        property color colSecondaryContainer: m3colors.m3secondaryContainer
        property color colOnSecondaryContainer: m3colors.m3onSecondaryContainer
        // Misc
        property color colTooltip: m3colors.m3inverseSurface
        property color colOnTooltip: m3colors.m3inverseOnSurface
        property color colScrim: ColorUtils.transparentize(m3colors.m3scrim, 0.5)
        property color colShadow: ColorUtils.transparentize(m3colors.m3shadow, 0.7)
        property color colOutline: m3colors.m3outline
        property color colOutlineVariant: m3colors.m3outlineVariant
        property color colError: m3colors.m3error
        property color colOnError: m3colors.m3onError
        property color colErrorContainer: m3colors.m3errorContainer
        property color colOnErrorContainer: m3colors.m3onErrorContainer
    }
}
