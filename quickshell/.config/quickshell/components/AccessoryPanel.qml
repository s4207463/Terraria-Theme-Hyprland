import QtQuick
import "../services"

// AccessoryPanel: 3x9 Equipment & Accessories Grid with tabs and defense shield
Rectangle {
    id: root

    implicitWidth: rowLayout.implicitWidth + Theme.panelPadding * 2
    implicitHeight: rowLayout.implicitHeight + Theme.panelPadding * 2

    color: Theme.panel
    border.color: Theme.panelBorder
    border.width: Theme.borderWidth
    radius: Theme.panelRadius

    Row {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Theme.spacing

        // Defense Shield Badge (shown on lower-left in-game reference)
        Column {
            anchors.bottom: parent.bottom
            spacing: Theme.spacing

            Rectangle {
                width: 24
                height: 28
                radius: 4
                color: Theme.slotBackground
                border.color: Theme.slotBorder
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "🛡"
                    font.pixelSize: Theme.fontSizeSmall
                }
            }
        }

        // Main 3x9 Column with Category Tabs
        Column {
            id: mainCol
            spacing: Theme.accessorySpacing

            // Top Category Tabs: Equipment, Housing, Misc/Mounts
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.accessorySpacing

                Repeater {
                    model: ["Eq", "Hs", "Mt"]
                    delegate: Rectangle {
                        required property string modelData
                        required property int index

                        width: Theme.accessorySlotSize
                        height: 18
                        radius: 2
                        color: (index === 0) ? Theme.accent : Theme.buttonBackground
                        border.color: Theme.panelBorder
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: (index === 0) ? Theme.background : Theme.textDim
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            font.bold: true
                        }
                    }
                }
            }

            // 3x9 Grid: Dyes (Col 1), Vanity (Col 2), Equipment/Accessories (Col 3)
            Grid {
                id: accGrid
                anchors.horizontalCenter: parent.horizontalCenter
                columns: Theme.accessoryCols
                rows: Theme.accessoryRows
                spacing: Theme.accessorySpacing

                Repeater {
                    model: Theme.accessoryTotalSlots
                    delegate: Rectangle {
                        id: accSlot
                        required property int index

                        readonly property int col: accSlot.index % Theme.accessoryCols
                        readonly property int row: Math.floor(accSlot.index / Theme.accessoryCols)

                        width: Theme.accessorySlotSize
                        height: Theme.accessorySlotSize
                        radius: Theme.panelRadius
                        color: (col === 0) ? Theme.slotBackground : ((col === 1) ? Theme.panel : Theme.slotBackground)
                        border.color: Theme.slotBorder
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: (col === 0 ? "D" : (col === 1 ? "V" : "E")) + (row + 1)
                            color: Theme.textDim
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                        }
                    }
                }
            }
        }
    }
}
