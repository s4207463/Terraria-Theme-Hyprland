import QtQuick
import "../services"

// Hotbar: Top-left 10-slot app launcher and focus bar (DESIGN.md 3.1)
Item {
    id: root

    property int activeSlot: 0 // 0-indexed active slot (0 = slot 1)
    property string activeTitle: "Terminal" // Active app/item name displayed above hotbar
    signal slotClicked(int index)

    implicitWidth: hotbarBox.implicitWidth
    implicitHeight: col.implicitHeight

    Column {
        id: col
        anchors.centerIn: parent
        spacing: Theme.spacing

        // Active item / app name displayed above hotbar matching Terraria HUD
        Text {
            id: titleLabel
            anchors.left: hotbarBox.left
            anchors.leftMargin: Theme.panelPadding
            text: root.activeTitle
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            font.bold: true
            visible: text.length > 0
        }

        // 10-slot hotbar container
        Rectangle {
            id: hotbarBox
            implicitWidth: row.implicitWidth + Theme.panelPadding * 2
            implicitHeight: row.implicitHeight + Theme.panelPadding * 2

            color: Theme.panel
            border.color: Theme.panelBorder
            border.width: Theme.borderWidth
            radius: Theme.panelRadius

            Row {
                id: row
                anchors.centerIn: parent
                spacing: Theme.spacing

                Repeater {
                    model: 10
                    delegate: Rectangle {
                        id: slot
                        required property int index

                        width: Theme.slotSize
                        height: Theme.slotSize
                        radius: Theme.panelRadius
                        color: Theme.slotBackground

                        border.color: (root.activeSlot === index)
                            ? Theme.slotBorderSelected
                            : Theme.slotBorder
                        border.width: Theme.borderWidth

                        Text {
                            anchors.centerIn: parent
                            // In Terraria hotbar: slots 1..9, 0
                            text: (slot.index === 9) ? "0" : (slot.index + 1).toString()
                            color: (root.activeSlot === index)
                                ? Theme.highlight
                                : Theme.textDim
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.activeSlot = slot.index
                                root.slotClicked(slot.index)
                            }
                        }
                    }
                }
            }
        }
    }
}
