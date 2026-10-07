import QtQuick
import "../services"

// Mana: Vertical column of 10 mana stars on the far right edge
Item {
    id: root

    property int manaPercent: 100 // 0-100 percentage
    readonly property int totalStars: Theme.manaTotalStars

    implicitWidth: starCol.implicitWidth
    implicitHeight: starCol.implicitHeight

    Column {
        id: starCol
        anchors.centerIn: parent
        spacing: Theme.manaStarSpacing

        Repeater {
            model: root.totalStars
            delegate: Rectangle {
                id: starBox
                required property int index

                width: Theme.manaStarSize
                height: Theme.manaStarSize
                radius: 2

                // Each star represents 10% of mana
                readonly property bool isFilled: ((starBox.index + 1) * 10) <= root.manaPercent

                color: isFilled ? Theme.manaColor : Theme.manaEmptyColor
                border.color: Theme.panelBorder
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "★"
                    color: starBox.isFilled ? Theme.highlight : Theme.textDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                }
            }
        }
    }
}
