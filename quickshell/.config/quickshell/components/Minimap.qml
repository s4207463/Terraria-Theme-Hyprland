import QtQuick
import "../services"

// Minimap: Top-right framed box (DESIGN.md 3.1: workspace overview or custom image)
Rectangle {
    id: root

    implicitWidth: Theme.minimapWidth + Theme.panelPadding * 2
    implicitHeight: Theme.minimapHeight + Theme.panelPadding * 2

    color: Theme.panel
    border.color: Theme.panelBorder
    border.width: Theme.borderWidth
    radius: Theme.panelRadius

    Rectangle {
        id: screenFrame
        anchors.centerIn: parent
        width: Theme.minimapWidth
        height: Theme.minimapHeight
        color: Theme.slotBackground
        border.color: Theme.slotBorder
        border.width: 1
        radius: Theme.panelRadius

        Column {
            anchors.centerIn: parent
            spacing: Theme.spacing

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "MINIMAP"
                color: Theme.accent
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "(Workspace / Image)"
                color: Theme.textDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
            }
        }
    }
}
