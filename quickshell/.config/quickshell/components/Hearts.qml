import QtQuick
import "../services"

// Hearts: Battery level indicator (DESIGN.md 3.1: 20 hearts, each = 5%)
Rectangle {
    id: root

    property int batteryPercent: 100 // 0-100 percentage
    readonly property int totalHearts: 20

    implicitWidth: grid.implicitWidth + Theme.panelPadding * 2
    implicitHeight: grid.implicitHeight + Theme.panelPadding * 2

    color: Theme.panel
    border.color: Theme.panelBorder
    border.width: Theme.borderWidth
    radius: Theme.panelRadius

    Grid {
        id: grid
        anchors.centerIn: parent
        columns: 10
        rows: 2
        spacing: Theme.heartSpacing

        Repeater {
            model: root.totalHearts
            delegate: Rectangle {
                id: heartBox
                required property int index

                width: Theme.heartSize
                height: Theme.heartSize
                radius: 2

                // Each heart represents 5% battery
                readonly property bool isFilled: ((heartBox.index + 1) * 5) <= root.batteryPercent

                color: isFilled ? Theme.heartColor : Theme.heartEmptyColor
                border.color: Theme.panelBorder
                border.width: 1
            }
        }
    }
}
