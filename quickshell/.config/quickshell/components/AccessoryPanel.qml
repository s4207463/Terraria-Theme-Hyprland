import QtQuick
import "../services"

// AccessoryPanel: 10-Row Equipment & Accessories Panel matching Terraria proportions
// - Top tabs: Eq (Equipment), Hs (Housing), Mt (Misc)
// - 3 Armor Rows (Head, Torso, Legs) + Loadout buttons 1..3 on right
// - Horizontal divider line separating Armor from Accessories
// - 7 Accessory Rows (Dye, Social, Functional) + Eye visibility toggles on right
// - Defense Shield badge (🛡 37) positioned to the left of the bottom accessory slot
// - Aligned flush right with Minimap (~55% of Minimap width)
Item {
    id: root

    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    // Exposed center of the 3-column slots (for Settings horizontal centering)
    readonly property real slotsCenterX: mainLayout.x + mainCol.x + (mainCol.width / 2)

    Item {
        id: mainLayout
        anchors.right: parent.right
        implicitWidth: defenseShield.width + Theme.spacing * 2 + mainCol.width + loadoutCol.width + 4
        implicitHeight: mainCol.height

        // Defense Shield Badge: Sits to the left of the bottom accessory row
        Rectangle {
            id: defenseShield
            anchors.right: mainCol.left
            anchors.rightMargin: Theme.spacing
            anchors.bottom: mainCol.bottom
            width: Theme.defenseShieldWidth
            height: Theme.defenseShieldHeight
            radius: 4
            color: Theme.slotBackground
            border.color: "#a6adc8"
            border.width: 1

            Column {
                anchors.centerIn: parent
                spacing: 1

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "🛡"
                    font.pixelSize: Theme.fontSizeSmall - 1
                }

                Text {
                    id: defenseValue
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "37"
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall - 1
                    font.bold: true
                }
            }
        }

        // Main Column: Tabs + Armor (Rows 1..3) + Divider + Accessories (Rows 4..10)
        Column {
            id: mainCol
            anchors.right: loadoutCol.left
            anchors.rightMargin: 2
            spacing: Theme.accessorySpacing

            // Category Tabs at top: Eq, Hs, Mt
            Row {
                id: tabsRow
                spacing: Theme.accessorySpacing

                Repeater {
                    model: [
                        { label: "Eq", name: "Equipment" },
                        { label: "Hs", name: "Housing" },
                        { label: "Mt", name: "Misc" }
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        required property int index

                        width: Theme.accessorySlotSize
                        height: 18
                        radius: 2
                        color: (index === 0) ? Theme.accent : Theme.buttonBackground
                        border.color: Theme.panelBorder
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            color: (index === 0) ? Theme.background : Theme.textDim
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            font.bold: true
                        }
                    }
                }
            }

            // 1. Armor Section (Rows 1..3: Head, Torso, Legs)
            Column {
                id: armorCol
                spacing: Theme.accessorySpacing

                Repeater {
                    model: 3
                    delegate: Row {
                        id: armorRow
                        required property int index
                        spacing: Theme.accessorySpacing

                        // Col 0: Dye
                        Rectangle {
                            width: Theme.accessorySlotSize
                            height: Theme.accessorySlotSize
                            radius: Theme.panelRadius
                            color: Theme.slotBackground
                            border.color: Theme.slotBorder
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "D" + (armorRow.index + 1)
                                color: Theme.textDim
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall - 1
                            }
                        }

                        // Col 1: Social / Vanity
                        Rectangle {
                            width: Theme.accessorySlotSize
                            height: Theme.accessorySlotSize
                            radius: Theme.panelRadius
                            color: Theme.panel
                            border.color: Theme.slotBorder
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "V" + (armorRow.index + 1)
                                color: Theme.textDim
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall - 1
                            }
                        }

                        // Col 2: Functional Equipment (Helmet, Shirt, Pants)
                        Rectangle {
                            width: Theme.accessorySlotSize
                            height: Theme.accessorySlotSize
                            radius: Theme.panelRadius
                            color: Theme.slotBackground
                            border.color: Theme.slotBorder
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: (armorRow.index === 0 ? "H" : (armorRow.index === 1 ? "S" : "P"))
                                color: Theme.accent
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall
                                font.bold: true
                            }
                        }
                    }
                }
            }

            // Horizontal Divider separating Armor from Accessories
            Rectangle {
                width: tabsRow.width
                height: 2
                color: Theme.panelBorder
                opacity: 0.8
            }

            // 2. Accessory Section (Rows 4..10: 7 accessory rows)
            Column {
                id: accessoryCol
                spacing: Theme.accessorySpacing

                Repeater {
                    model: 7
                    delegate: Row {
                        id: accRowItem
                        required property int index
                        spacing: Theme.accessorySpacing

                        // Col 0: Dye
                        Rectangle {
                            width: Theme.accessorySlotSize
                            height: Theme.accessorySlotSize
                            radius: Theme.panelRadius
                            color: Theme.slotBackground
                            border.color: Theme.slotBorder
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "D" + (accRowItem.index + 4)
                                color: Theme.textDim
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall - 1
                            }
                        }

                        // Col 1: Social / Vanity
                        Rectangle {
                            width: Theme.accessorySlotSize
                            height: Theme.accessorySlotSize
                            radius: Theme.panelRadius
                            color: Theme.panel
                            border.color: Theme.slotBorder
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "V" + (accRowItem.index + 4)
                                color: Theme.textDim
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall - 1
                            }
                        }

                        // Col 2: Functional Accessory
                        Rectangle {
                            width: Theme.accessorySlotSize
                            height: Theme.accessorySlotSize
                            radius: Theme.panelRadius
                            color: Theme.slotBackground
                            border.color: Theme.slotBorder
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "A" + (accRowItem.index + 1)
                                color: Theme.text
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall
                            }
                        }
                    }
                }
            }
        }

        // Right side indicators:
        // 1. Loadout 1/2/3 buttons (aligned with armor rows 1..3)
        // 2. Eye visibility toggles (aligned with all rows)
        Column {
            id: loadoutCol
            anchors.right: parent.right
            anchors.top: mainCol.top
            anchors.topMargin: 21 // below tabs (18px tab + 3px spacing)
            spacing: Theme.accessorySpacing

            // Loadout buttons 1, 2, 3
            Repeater {
                model: ["1", "2", "3"]
                delegate: Rectangle {
                    required property string modelData
                    required property int index
                    width: 12
                    height: Theme.accessorySlotSize
                    radius: 2
                    color: (index === 0) ? Theme.accent : Theme.buttonBackground
                    border.color: Theme.panelBorder
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: (index === 0) ? Theme.background : Theme.textDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall - 3
                        font.bold: true
                    }
                }
            }

            // Gap aligning with the divider line
            Item {
                width: 12
                height: 2
            }

            // Eye visibility toggles for the 7 accessory rows
            Repeater {
                model: 7
                delegate: Rectangle {
                    width: 12
                    height: Theme.accessorySlotSize
                    radius: 2
                    color: "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "👁"
                        color: Theme.textDim
                        font.pixelSize: Theme.fontSizeSmall - 3
                        opacity: 0.7
                    }
                }
            }
        }
    }
}
