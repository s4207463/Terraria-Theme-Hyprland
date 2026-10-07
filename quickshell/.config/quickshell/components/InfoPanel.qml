import QtQuick
import "../services"

// InfoPanel: Performance and environment readouts (DESIGN.md 3.1 & 3.3)
// Normal mode: Clean text readouts left-aligned directly under the Minimap (matching in-game HUD).
// Compact mode: Seamless horizontal row of icons directly beneath the Minimap (when inventory opens).
Item {
    id: root

    property bool compact: false

    implicitWidth: compact
        ? iconRow.implicitWidth
        : Theme.minimapWidth
    implicitHeight: compact
        ? iconRow.implicitHeight
        : textCol.implicitHeight

    // 1. Compact Mode: Row of circular icons directly hugging the Minimap
    Row {
        id: iconRow
        anchors.right: parent.right
        spacing: Theme.infoIconSpacing
        visible: root.compact

        Repeater {
            model: [
                { label: "T", name: "Time", color: Theme.text },
                { label: "D", name: "Date", color: Theme.textDim },
                { label: "C", name: "CPU", color: Theme.accent },
                { label: "R", name: "RAM", color: Theme.text },
                { label: "G", name: "GPU", color: Theme.mana },
                { label: "N", name: "Net", color: Theme.highlight },
                { label: "B", name: "Battery", color: Theme.danger }
            ]

            delegate: Rectangle {
                id: iconBox
                required property var modelData

                width: Theme.infoIconSize
                height: Theme.infoIconSize
                radius: Theme.infoIconSize / 2 // circular like in-game icons
                color: Theme.slotBackground
                border.color: Theme.slotBorder
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: iconBox.modelData.label
                    color: iconBox.modelData.color
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall - 2
                    font.bold: true
                }
            }
        }
    }

    // 2. Normal Mode: Clean text readout column aligned under the Minimap
    Column {
        id: textCol
        anchors.left: parent.left
        anchors.leftMargin: Theme.panelPadding
        anchors.right: parent.right
        spacing: Theme.spacing
        visible: !root.compact

        Text {
            text: "TIME: 10:30 PM"
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
        }

        Text {
            text: "DATE: Wed Oct 7"
            color: Theme.textDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
        }

        Text {
            text: "CPU: 12%"
            color: Theme.accent
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
        }

        Text {
            text: "RAM: 4.2 / 16 GB"
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
        }

        Text {
            text: "GPU: 8%"
            color: Theme.mana
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
        }
    }
}
