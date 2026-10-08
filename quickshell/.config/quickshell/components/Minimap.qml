import QtQuick
import "../services"

// Minimap: Top-right framed box (DESIGN.md 3.1: workspace overview or custom image)
Item {
    id: root

    implicitWidth: Theme.minimapWidth
    implicitHeight: Theme.minimapHeight

    Rectangle {
        id: screenFrame
        anchors.fill: parent
        color: Theme.panel
        border.color: Theme.minimapBorder
        border.width: 2
        radius: 4

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

        // Bottom control buttons: [-], [=], [+] matching Terraria minimap frame
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.panelPadding / 2
            spacing: Theme.spacing

            Repeater {
                model: ["-", "=", "+"]
                delegate: Rectangle {
                    required property string modelData
                    width: 14
                    height: 14
                    radius: 7
                    color: Theme.slotBackground
                    border.color: Theme.minimapBorder
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: Theme.textDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall - 2
                    }
                }
            }
        }
    }
}
