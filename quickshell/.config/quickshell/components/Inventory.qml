import QtQuick
import QtQuick.Controls
import "../services"

// Inventory: Full overlay screen toggled via Super (DESIGN.md 3.2)
Item {
    id: root

    signal requestClose()
    signal requestSettings()

    // 50 slots: 5 rows x 10 cols matching in-game Terraria inventory
    readonly property int totalSlots: Theme.inventoryTotalSlots

    // Exposed panel items for window input region masking
    property alias inventoryPanel: inventoryPanel
    property alias searchBarContainer: searchBarContainer
    property alias settingsBtn: settingsBtn

    // Top-Left: Inventory App Grid (5 rows x 10 cols)
    Rectangle {
        id: inventoryPanel
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: Theme.panelPadding * 2

        implicitWidth: grid.implicitWidth + Theme.panelPadding * 2
        implicitHeight: grid.implicitHeight + Theme.panelPadding * 2

        color: Theme.panel
        border.color: Theme.panelBorder
        border.width: Theme.borderWidth
        radius: Theme.panelRadius

        Grid {
            id: grid
            anchors.centerIn: parent
            columns: Theme.inventoryCols
            rows: Theme.inventoryRows
            spacing: Theme.spacing

            Repeater {
                model: root.totalSlots
                delegate: Rectangle {
                    id: invSlot
                    required property int index

                    width: Theme.slotSize
                    height: Theme.slotSize
                    radius: Theme.panelRadius
                    color: Theme.slotBackground

                    // Slot 12 marked as favorite placeholder ("Favorite apps")
                    readonly property bool isFavorite: (invSlot.index === 12)
                    // First row (0..9) mirrors Hotbar
                    readonly property bool isHotbarRow: (invSlot.index < 10)

                    border.color: isFavorite
                        ? Theme.slotBorderFavorited
                        : (isHotbarRow ? Theme.accent : Theme.slotBorder)
                    border.width: Theme.borderWidth

                    Text {
                        anchors.centerIn: parent
                        text: isFavorite ? "★" : (invSlot.index + 1).toString()
                        color: isFavorite ? Theme.highlight : Theme.textDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }
            }
        }
    }

    // Center: Search Bar ("Search bar in the middle")
    Rectangle {
        id: searchBarContainer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: Theme.searchBarWidth
        height: Theme.searchBarHeight
        color: Theme.panel
        border.color: searchInput.activeFocus ? Theme.accent : Theme.panelBorder
        border.width: Theme.borderWidth
        radius: Theme.panelRadius

        TextInput {
            id: searchInput
            anchors.fill: parent
            anchors.leftMargin: Theme.panelPadding * 2
            anchors.rightMargin: Theme.panelPadding * 2
            verticalAlignment: TextInput.AlignVCenter
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            clip: true

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Search apps (type to filter)..."
                color: Theme.textDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeNormal
                visible: !searchInput.text && !searchInput.activeFocus
            }
        }
    }


    // Bottom-Right Corner: Standalone Settings Button ("go to setting")
    Rectangle {
        id: settingsBtn
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.panelPadding * 2

        implicitWidth: settingsLabel.implicitWidth + Theme.panelPadding * 4
        implicitHeight: Theme.buttonHeight
        radius: Theme.panelRadius
        color: Theme.buttonBackground
        border.color: Theme.panelBorder
        border.width: Theme.borderWidth

        Text {
            id: settingsLabel
            anchors.centerIn: parent
            text: "Settings"
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.requestSettings()
        }
    }
}
