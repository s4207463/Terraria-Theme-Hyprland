import QtQuick
import "../services"

// InfoPanel: Performance and environment readouts (DESIGN.md 3.1 & 3.3)
// In normal mode: Full text readouts.
// In inventory/accessories mode (compact = true): Row of compact icons under the Minimap.
Rectangle {
    id: root

    property bool compact: false

    implicitWidth: compact
        ? (iconRow.implicitWidth + Theme.panelPadding * 2)
        : (textCol.implicitWidth + Theme.panelPadding * 2)
    implicitHeight: compact
        ? (iconRow.implicitHeight + Theme.panelPadding * 2)
        : (textCol.implicitHeight + Theme.panelPadding * 2)

    color: Theme.panel
    border.color: Theme.panelBorder
    border.width: Theme.borderWidth
    radius: Theme.panelRadius

    // 1. Compact Mode: Row of performance icon placeholder boxes under Minimap
    Row {
        id: iconRow
        anchors.centerIn: parent
        spacing: Theme.infoIconSpacing
        visible: root.compact

        Repeater {
            model: [
                { label: "T", name: "Time", color: Theme.text },
                { label: "D", name: "Date", color: Theme.textDim },
                { label: "C", name: "CPU", color: Theme.accent },
                { label: "R", name: "RAM", color: Theme.text },
                { label: "G", name: "GPU", color: Theme.mana }
            ]

            delegate: Rectangle {
                id: iconBox
                required property var modelData

                width: Theme.infoIconSize
                height: Theme.infoIconSize
                radius: 2
                color: Theme.slotBackground
                border.color: Theme.slotBorder
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: iconBox.modelData.label
                    color: iconBox.modelData.color
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                }
            }
        }
    }

    // 2. Normal Mode: Full text readout column
    Column {
        id: textCol
        anchors.centerIn: parent
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
