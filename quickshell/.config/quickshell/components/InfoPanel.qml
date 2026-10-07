import QtQuick
import "../services"

// InfoPanel: Performance and environment readouts (DESIGN.md 3.1 & 3.3)
Rectangle {
    id: root

    implicitWidth: column.implicitWidth + Theme.panelPadding * 2
    implicitHeight: column.implicitHeight + Theme.panelPadding * 2

    color: Theme.panel
    border.color: Theme.panelBorder
    border.width: Theme.borderWidth
    radius: Theme.panelRadius

    Column {
        id: column
        anchors.centerIn: parent
        spacing: Theme.spacing

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
