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

    // Overlay
    readonly property color overlayBackground: "#b00d0e15"

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

    // Heart tokens (Battery: 20 hearts, 2 rows of 10)
    readonly property int heartSize: 12
    readonly property int heartSpacing: 3
    readonly property color heartColor: "#f38ba8"
    readonly property color heartEmptyColor: "#313244"

    // Minimap tokens
    readonly property int minimapWidth: 160
    readonly property int minimapHeight: 120

    // Accessory tokens
    readonly property int accessorySlotSize: 36
    readonly property int accessorySlotCount: 5

    // Search bar tokens
    readonly property int searchBarWidth: 420
    readonly property int searchBarHeight: 36

    // Info performance icon tokens (compact mode)
    readonly property int infoIconSize: 20
    readonly property int infoIconSpacing: 4

    // Inventory grid tokens (5 rows x 10 cols = 50 slots matching in-game layout)
    readonly property int inventoryRows: 5
    readonly property int inventoryCols: 10
    readonly property int inventoryTotalSlots: 50

    // Button tokens
    readonly property int buttonHeight: 32
    readonly property color buttonBackground: "#313244"
    readonly property color buttonHover: "#45475a"
}
