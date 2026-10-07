import Quickshell
import QtQuick
import "./services"

ShellRoot {
    // Placeholder panel at top-left (Hotbar location)
    PanelWindow {
        id: placeholderPanel
        anchors.top: true
        anchors.left: true
        color: "transparent"

        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight

        Rectangle {
            id: content
            implicitWidth: label.implicitWidth + Theme.panelPadding * 4
            implicitHeight: label.implicitHeight + Theme.panelPadding * 2
            color: Theme.panel
            border.color: Theme.panelBorder
            border.width: Theme.borderWidth
            radius: Theme.panelRadius

            Text {
                id: label
                anchors.centerIn: parent
                text: "Terraria Shell (Phase 1 Skeleton)"
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeNormal
            }
        }
    }

    Component.onCompleted: {
        console.log("[TerrariaShell] Shell initialized")
        console.log("[TerrariaShell] Mock mode:", Config.mockMode ? "ENABLED (TERRARIA_MOCK=1)" : "DISABLED (Live system)")
        console.log("[TerrariaShell] Theme loaded successfully")
    }
}
