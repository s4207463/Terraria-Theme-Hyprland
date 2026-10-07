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

    // Dimensions & Spacing (calibrated to exact vertical proportions: 1/3 map+health, 1/2 accessories, 1/4 inventory)
    readonly property int slotSize: 40
    readonly property int slotPadding: 2
    readonly property int panelPadding: 6
    readonly property int panelRadius: 3
    readonly property int borderWidth: 1
    readonly property int spacing: 4

    // Heart tokens (Battery: 20 hearts, 2 rows of 10)
    // 10 hearts width = 10 * 18 + 9 * 4 = 216px
    readonly property int heartSize: 18
    readonly property int heartSpacing: 4
    readonly property color heartColor: "#f38ba8"
    readonly property color heartEmptyColor: "#313244"

    // Mana tokens (Vertical column of 10 stars on far right edge)
    readonly property int manaStarSize: 20
    readonly property int manaStarSpacing: 5
    readonly property int manaTotalStars: 10
    readonly property color manaColor: "#89dceb"
    readonly property color manaEmptyColor: "#313244"

    // Minimap tokens: Health (60px) + Minimap (240px) ~ 300px = 1/3 vertical length
    readonly property int minimapWidth: 224
    readonly property int minimapHeight: 240

    // Accessory tokens: 9 rows * 44px + spacing + tabs ~ 450px = 1/2 vertical length
    readonly property int accessorySlotSize: 44
    readonly property int accessoryCols: 3
    readonly property int accessoryRows: 9
    readonly property int accessorySpacing: 4
    readonly property int accessoryTotalSlots: 27

    // Health & Mana Bar tokens (Bar HUD style from Terraria)
    readonly property int healthBarWidth: 250
    readonly property int healthBarHeight: 18
    readonly property int manaBarWidth: 155
    readonly property int manaBarHeight: 14
    readonly property int barBadgeSize: 26
    readonly property int manaBadgeSize: 22
    readonly property int batterySegmentsTotal: 20
    readonly property int manaSegmentsTotal: 10
    readonly property color barBorder: "#d4af37"

    // Settings button alignment to match accessories right edge
    readonly property int settingsRightMargin: panelPadding * 2

    // Search bar tokens
    readonly property int searchBarWidth: 420
    readonly property int searchBarHeight: 36

    // Info performance icon tokens (compact mode)
    readonly property int infoIconSize: 18
    readonly property int infoIconSpacing: 3
    readonly property int hudSpacing: 6

    // Inventory grid tokens: 5 rows * 40px + spacing ~ 225px = 1/4 vertical length
    readonly property int inventoryRows: 5
    readonly property int inventoryCols: 10
    readonly property int inventoryTotalSlots: 50

    // Button tokens
    readonly property int buttonHeight: 30
    readonly property color buttonBackground: "#313244"
    readonly property color buttonHover: "#45475a"

    // 2D Player Demo tokens (Terraria proportions & physics)
    readonly property int playerWidth: 24
    readonly property int playerHeight: 44
    readonly property int groundHeight: 28
    readonly property color playerHair: "#f9e2af"
    readonly property color playerSkin: "#f5c2e7"
    readonly property color playerShirt: "#89b4fa"
    readonly property color playerPants: "#585b70"
    readonly property color groundTop: "#a6e3a1"
    readonly property color groundBody: "#313244"
}
