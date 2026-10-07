import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import "./services"
import "./components"

ShellRoot {
    id: root

    // Controls whether Inventory overlay is active (Super tap or INV button)
    property bool inventoryOpen: false

    // IPC handler for keybinds: `qs ipc call inventory toggle`
    IpcHandler {
        target: "inventory"
        function toggle() {
            root.inventoryOpen = !root.inventoryOpen
        }
        function open() {
            root.inventoryOpen = true
        }
        function close() {
            root.inventoryOpen = false
        }
    }

    // NORMAL SCREEN: Top-Left Hotbar Window
    PanelWindow {
        id: hotbarWindow
        anchors.top: true
        anchors.left: true
        color: "transparent"
        visible: !root.inventoryOpen

        implicitWidth: hotbar.implicitWidth + Theme.panelPadding * 3
        implicitHeight: hotbar.implicitHeight + Theme.panelPadding * 3

        Hotbar {
            id: hotbar
            anchors.left: parent.left
            anchors.leftMargin: Theme.panelPadding
            anchors.top: parent.top
            anchors.topMargin: Theme.panelPadding
        }
    }

    // NORMAL SCREEN: Top-Right HUD Window (Hearts, Minimap, InfoPanel, Mana)
    PanelWindow {
        id: hudWindow
        anchors.top: true
        anchors.right: true
        color: "transparent"

        implicitWidth: hudRow.implicitWidth + Theme.panelPadding * 3
        implicitHeight: hudRow.implicitHeight + Theme.panelPadding * 3

        Row {
            id: hudRow
            anchors.right: parent.right
            anchors.rightMargin: Theme.panelPadding
            anchors.top: parent.top
            anchors.topMargin: Theme.panelPadding
            spacing: Theme.spacing * 2

            Column {
                spacing: Theme.hudSpacing

                Hearts {
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Minimap {
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                InfoPanel {
                    anchors.horizontalCenter: parent.horizontalCenter
                    compact: root.inventoryOpen
                }

                // 3x9 Equipment & Accessories Grid directly under InfoPanel (visible when inventory is open)
                AccessoryPanel {
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: root.inventoryOpen
                }
            }

            // Far right edge: Vertical Mana Star Column
            Mana {
                id: manaBar
                anchors.top: parent.top
            }
        }
    }

    // INVENTORY OVERLAY (Toggled by Super / IPC)
    // Non-modal and transparent: does not block the map, desktop, or windows behind it.
    PanelWindow {
        id: overlayWindow
        anchors.top: true
        anchors.bottom: true
        anchors.left: true
        anchors.right: true
        color: "transparent"

        visible: root.inventoryOpen
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: root.inventoryOpen ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

        // Input mask: ONLY the actual panels receive clicks.
        // Transparent areas pass all clicks straight through to windows/games behind!
        mask: Region {
            Region { item: inventoryComp.inventoryPanel }
            Region { item: inventoryComp.searchBarContainer }
            Region { item: inventoryComp.settingsBtn }
        }

        Inventory {
            id: inventoryComp
            anchors.fill: parent
            onRequestClose: root.inventoryOpen = false
            onRequestSettings: console.log("[TerrariaShell] Settings clicked")
        }

        Item {
            focus: root.inventoryOpen
            Keys.onEscapePressed: root.inventoryOpen = false
        }
    }

    Component.onCompleted: {
        console.log("[TerrariaShell] Shell initialized")
        console.log("[TerrariaShell] Mock mode:", Config.mockMode ? "ENABLED (TERRARIA_MOCK=1)" : "DISABLED (Live system)")
        console.log("[TerrariaShell] Theme loaded successfully")
    }
}
