import QtQuick
import QtQuick.Controls
import "../services"

// Inventory: Overlay elements (Centered Search Bar & Bottom-Right Settings Button)
// Toggled via Super / Alt / IPC with 0ms instantaneous snap like Terraria
Item {
    id: root

    signal requestClose()
    signal requestSettings()

    // Exposed panel items for window input region masking
    property alias searchBarContainer: searchBarContainer
    property alias settingsBtn: settingsBtn

    // Center: Search Bar ("Search bar in the middle")
    Rectangle {
        id: searchBarContainer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: Theme.searchBarWidth
        height: Theme.searchBarHeight
        color: Theme.panel
        border.color: searchInput.activeFocus ? Theme.accent : Theme.panelBorder
        border.width: Theme.borderWidth
        radius: Theme.panelRadius

        TextInput {
            id: searchInput
            anchors.fill: parent
            anchors.leftMargin: Theme.panelPadding * 2
            anchors.rightMargin: Theme.panelPadding * 2
            verticalAlignment: TextInput.AlignVCenter
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            clip: true

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Search apps (type to filter)..."
                color: Theme.textDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeNormal
                visible: !searchInput.text && !searchInput.activeFocus
            }
        }
    }

    // Horizontal center for Settings alignment under accessories
    property real settingsCenterX: 0

    // Bottom: Standalone stylized "Settings" text centered under the accessories column
    Item {
        id: settingsBtn
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.panelPadding * 4
        x: (root.settingsCenterX > 0) ? (root.settingsCenterX - width / 2) : (parent.width - width - Theme.panelPadding * 6)
        width: settingsLabel.implicitWidth + 24
        height: settingsLabel.implicitHeight + 12

        Text {
            id: settingsLabel
            anchors.centerIn: parent
            text: "Settings"
            color: settingsArea.containsMouse ? Theme.highlight : Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeHeader
            font.bold: true
            style: Text.Outline
            styleColor: "#11111b"

            Behavior on color {
                ColorAnimation { duration: 120 }
            }
        }

        MouseArea {
            id: settingsArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.requestSettings()
        }
    }
}
