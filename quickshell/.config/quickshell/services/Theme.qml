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

    // Minimap tokens: Exact Terraria ratio (~240w x 240h, golden border)
    readonly property int minimapWidth: 240
    readonly property int minimapHeight: 240
    readonly property color minimapBorder: barBorder

    // Accessory tokens: 10 rows (3 armor + divider + 7 accessories), 3 cols (Dye, Social, Equip)
    // 3 cols * 36px + spacing = ~114px grid + eye toggles = ~132px (~55% of 240px Minimap width)
    readonly property int accessorySlotSize: 36
    readonly property int accessoryCols: 3
    readonly property int accessoryRows: 10
    readonly property int accessorySpacing: 3
    readonly property int accessoryTotalSlots: 30
    readonly property int defenseShieldWidth: 32
    readonly property int defenseShieldHeight: 34

    // Health & Mana Bar tokens (Bar HUD style from Terraria, flush right with Minimap)
    readonly property int healthBarWidth: 248
    readonly property int healthBarHeight: 18
    readonly property int manaBarWidth: 155
    readonly property int manaBarHeight: 14
    readonly property int barBadgeSize: 26
    readonly property int manaBadgeSize: 22
    readonly property int batterySegmentsTotal: 20
    readonly property int manaSegmentsTotal: 10
    readonly property color barBorder: "#d4af37"

    // Settings text tokens (Terraria stylized text centered under accessory grid)
    readonly property int settingsRightMargin: panelPadding * 2

    // Search bar tokens
    readonly property int searchBarWidth: 420
    readonly property int searchBarHeight: 36

    // Info performance icon tokens (compact mode: row of 7 icons on left below map)
    readonly property int infoIconSize: 13
    readonly property int infoIconSpacing: 2
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
