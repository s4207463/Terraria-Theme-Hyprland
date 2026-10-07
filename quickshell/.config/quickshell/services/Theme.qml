pragma Singleton
import QtQuick

QtObject {
    // Phase 1 Placeholder Tokens: neutral dark palette with accent (Rule B1 / A3)
    readonly property color background: "#11111b"
    readonly property color panel: "#181825"
    readonly property color panelBorder: "#313244"
    readonly property color text: "#cdd6f4"
    readonly property color textDim: "#a6adc8"
    readonly property color accent: "#89b4fa"
    readonly property color danger: "#f38ba8"
    readonly property color mana: "#89dceb"
    readonly property color highlight: "#f9e2af"

    // Slot tokens
    readonly property color slotBackground: "#1e1e2e"
    readonly property color slotBorder: "#45475a"
    readonly property color slotBorderSelected: "#f9e2af"
    readonly property color slotBorderFavorited: "#fab387"

    // Typography
    readonly property string fontFamily: "sans-serif"
    readonly property int fontSizeSmall: 10
    readonly property int fontSizeNormal: 12
    readonly property int fontSizeLarge: 14
    readonly property int fontSizeHeader: 16

    // Dimensions & Spacing
    readonly property int slotSize: 44
    readonly property int slotPadding: 4
    readonly property int panelPadding: 8
    readonly property int panelRadius: 4
    readonly property int borderWidth: 2
    readonly property int spacing: 6
}
