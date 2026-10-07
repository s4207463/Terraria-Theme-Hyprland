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

    // Bottom-Right: Standalone Settings Button aligned with accessories
    Rectangle {
        id: settingsBtn
        anchors.right: parent.right
        anchors.rightMargin: Theme.settingsRightMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.panelPadding * 3

        implicitWidth: settingsLabel.implicitWidth + Theme.panelPadding * 4
        implicitHeight: Theme.buttonHeight
        radius: Theme.panelRadius
        color: Theme.buttonBackground
        border.color: Theme.panelBorder
        border.width: Theme.borderWidth

        Text {
            id: settingsLabel
            anchors.centerIn: parent
            text: "Settings"
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.requestSettings()
        }
    }
}
