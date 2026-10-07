import QtQuick
import "../services"

// Hotbar: Top-left 10-slot app launcher and focus bar (DESIGN.md 3.1)
Rectangle {
    id: root

    property int activeSlot: 0 // 0-indexed active slot (0 = slot 1)
    signal slotClicked(int index)

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
                    text: (slot.index + 1).toString()
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
