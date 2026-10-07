import QtQuick
import Quickshell.Services.UPower
import "../services"

// Health & Mana Bars: Terraria "Bar" HUD Style (DESIGN.md 3.1 & user preference)
// Top: Battery level bar (20 segments, each = 5%) with Heart emblem badge on right
// Bottom: Mana level bar (10 segments, each = 10%) with Star emblem badge on right
Item {
    id: root

    // Battery level (0-100 percentage) bound to live UPower device with mock fallback
    property int batteryPercent: {
        if (Config.mockMode) return 100
        if (UPower.displayDevice && UPower.displayDevice.isPresent) {
            var p = UPower.displayDevice.percentage
            return Math.round(p <= 1.0 ? p * 100 : p)
        }
        return 100
    }

    // Mana level (0-100 percentage, default full)
    property int manaPercent: 100

    readonly property int totalBatterySegments: Theme.batterySegmentsTotal
    readonly property int totalManaSegments: Theme.manaSegmentsTotal

    implicitWidth: Theme.healthBarWidth
    implicitHeight: col.implicitHeight

    Column {
        id: col
        anchors.right: parent.right
        spacing: Theme.spacing

        // 1. Text readout: "Battery: X/100" (replaces "Life: 350/450" from Terraria)
        Item {
            id: labelRow
            width: Theme.healthBarWidth
            height: batteryLabel.implicitHeight

            Text {
                id: batteryLabel
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -Theme.barBadgeSize / 4
                text: "Battery: " + root.batteryPercent + "/100"
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }
        }

        // 2. Main Health / Battery Bar with Heart Badge
        Item {
            id: healthBarContainer
            anchors.right: parent.right
            width: Theme.healthBarWidth
            height: Math.max(Theme.healthBarHeight, Theme.barBadgeSize)

            // Horizontal segmented bar frame (Terraria brass/gold border)
            Rectangle {
                id: healthBarFrame
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - Theme.barBadgeSize / 2
                height: Theme.healthBarHeight
                radius: Theme.panelRadius
                color: Theme.panel
                border.color: Theme.barBorder
                border.width: Theme.borderWidth
                clip: true

                Row {
                    anchors.fill: parent
                    anchors.margins: Theme.borderWidth

                    Repeater {
                        model: root.totalBatterySegments
                        delegate: Rectangle {
                            id: seg
                            required property int index

                            width: (healthBarFrame.width - Theme.borderWidth * 2) / root.totalBatterySegments
                            height: parent.height

                            readonly property bool isFilled: ((seg.index + 1) * 5) <= root.batteryPercent

                            color: isFilled ? Theme.heartColor : Theme.heartEmptyColor

                            // Vertical divider between segments matching Terraria HUD
                            Rectangle {
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: 1
                                color: Theme.barBorder
                                opacity: 0.4
                                visible: seg.index < root.totalBatterySegments - 1
                            }
                        }
                    }
                }
            }

            // Heart emblem badge attached to the right tip of the health bar
            Rectangle {
                id: heartBadge
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: Theme.barBadgeSize
                height: Theme.barBadgeSize
                radius: Theme.barBadgeSize / 2
                color: Theme.panel
                border.color: Theme.barBorder
                border.width: Theme.borderWidth

                Text {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -1
                    text: "♥"
                    color: Theme.heartColor
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeNormal
                }
            }
        }

        // 3. Mana Bar with Star Badge (positioned under the right portion of the health bar)
        Item {
            id: manaBarContainer
            anchors.right: parent.right
            width: Theme.manaBarWidth
            height: Math.max(Theme.manaBarHeight, Theme.manaBadgeSize)

            // Horizontal segmented mana bar frame
            Rectangle {
                id: manaBarFrame
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - Theme.manaBadgeSize / 2
                height: Theme.manaBarHeight
                radius: Theme.panelRadius
                color: Theme.panel
                border.color: Theme.barBorder
                border.width: Theme.borderWidth
                clip: true

                Row {
                    anchors.fill: parent
                    anchors.margins: Theme.borderWidth

                    Repeater {
                        model: root.totalManaSegments
                        delegate: Rectangle {
                            id: manaSeg
                            required property int index

                            width: (manaBarFrame.width - Theme.borderWidth * 2) / root.totalManaSegments
                            height: parent.height

                            readonly property bool isFilled: ((manaSeg.index + 1) * 10) <= root.manaPercent

                            color: isFilled ? Theme.manaColor : Theme.manaEmptyColor

                            // Vertical divider between mana segments
                            Rectangle {
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: 1
                                color: Theme.barBorder
                                opacity: 0.4
                                visible: manaSeg.index < root.totalManaSegments - 1
                            }
                        }
                    }
                }
            }

            // Star emblem badge attached to the right tip of the mana bar
            Rectangle {
                id: starBadge
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: Theme.manaBadgeSize
                height: Theme.manaBadgeSize
                radius: Theme.manaBadgeSize / 2
                color: Theme.panel
                border.color: Theme.barBorder
                border.width: Theme.borderWidth

                Text {
                    anchors.centerIn: parent
                    text: "★"
                    color: Theme.manaColor
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                }
            }
        }
    }
}
