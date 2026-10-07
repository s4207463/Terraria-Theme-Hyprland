import QtQuick
import "../services"

// Hotbar: Top-left 10-slot app launcher and focus bar (DESIGN.md 3.1)
// Expands seamlessly to 50-slot inventory grid when inventory opens, with 0ms instant frame snap like Terraria
Item {
    id: root

    property int activeSlot: 0 // 0-indexed active slot (0 = slot 1)
    property string activeTitle: "Terminal" // Active app/item name displayed above hotbar
    property bool expanded: false // Whether full inventory is expanded
    signal slotClicked(int index)

    implicitWidth: gridBox.implicitWidth
    implicitHeight: col.implicitHeight

    Column {
        id: col
        anchors.top: parent.top
        anchors.left: parent.left
        spacing: Theme.spacing

        // Active item name when closed, "Inventory" title when expanded (matching Terraria HUD)
        Text {
            id: titleLabel
            anchors.left: gridBox.left
            anchors.leftMargin: Theme.panelPadding
            text: root.expanded ? "Inventory" : root.activeTitle
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            font.bold: true
            visible: text.length > 0
        }

        // Slots container: 1 row of 10 when closed, 5 rows of 10 when expanded
        Rectangle {
            id: gridBox
            clip: true
            implicitWidth: Theme.inventoryCols * Theme.slotSize + (Theme.inventoryCols - 1) * Theme.spacing + Theme.panelPadding * 2
            implicitHeight: root.expanded
                ? (Theme.inventoryRows * Theme.slotSize + (Theme.inventoryRows - 1) * Theme.spacing + Theme.panelPadding * 2)
                : (Theme.slotSize + Theme.panelPadding * 2)

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
                    model: Theme.inventoryTotalSlots
                    delegate: Rectangle {
                        id: slot
                        required property int index
                        visible: root.expanded || slot.index < 10

                        width: Theme.slotSize
                        height: Theme.slotSize
                        radius: Theme.panelRadius
                        color: Theme.slotBackground

                        readonly property bool isFavorite: (slot.index === 12)
                        readonly property bool isHotbarRow: (slot.index < 10)
                        readonly property bool isSelected: (root.activeSlot === slot.index)

                        border.color: isFavorite
                            ? Theme.slotBorderFavorited
                            : (isSelected ? Theme.slotBorderSelected : (isHotbarRow ? Theme.accent : Theme.slotBorder))
                        border.width: Theme.borderWidth

                        Text {
                            anchors.centerIn: parent
                            text: slot.isFavorite ? "★" : ((slot.index === 9) ? "0" : (slot.index + 1).toString())
                            color: slot.isFavorite
                                ? Theme.highlight
                                : (slot.isSelected ? Theme.highlight : Theme.textDim)
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (slot.index < 10) {
                                    root.activeSlot = slot.index
                                }
                                root.slotClicked(slot.index)
                            }
                        }
                    }
                }
            }
        }
    }
}
