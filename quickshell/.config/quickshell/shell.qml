import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import "./services"
import "./components"

ShellRoot {
    id: root

    // Controls whether Inventory overlay is active (Super / Alt / F1 / IPC)
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

    // Single unified fullscreen window:
    // Permanently mapped, never resizes, never remaps.
    // Toggling inventory is a pure 0ms frame-flip with zero compositor animations/effects, exactly like Terraria!
    PanelWindow {
        id: shellWindow
        anchors.top: true
        anchors.bottom: true
        anchors.left: true
        anchors.right: true
        color: "transparent"
        visible: true

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: root.inventoryOpen ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

        // Input mask: ONLY the interactive UI panels intercept clicks.
        // Transparent areas pass 100% of mouse clicks straight through to games/windows behind!
        mask: Region {
            Region { item: hotbar }
            Region { item: hudRow }
            Region { item: root.inventoryOpen ? inventoryOverlay.searchBarContainer : null }
            Region { item: root.inventoryOpen ? inventoryOverlay.settingsBtn : null }
        }

        // TOP-LEFT: Hotbar & Expanded Inventory Grid (Hotbar slots 1..10 never move or unmap)
        Hotbar {
            id: hotbar
            anchors.left: parent.left
            anchors.leftMargin: Theme.panelPadding * 2
            anchors.top: parent.top
            anchors.topMargin: Theme.panelPadding * 2
            expanded: root.inventoryOpen
        }

        // TOP-RIGHT: HUD Stack (Hearts, Minimap, InfoPanel, Accessories, Mana)
        Row {
            id: hudRow
            anchors.right: parent.right
            anchors.rightMargin: Theme.panelPadding * 2
            anchors.top: parent.top
            anchors.topMargin: Theme.panelPadding * 2
            spacing: Theme.spacing * 2

            Column {
                spacing: Theme.hudSpacing

                Hearts {
                    anchors.right: parent.right
                }

                Minimap {
                    anchors.right: parent.right
                }

                InfoPanel {
                    anchors.right: parent.right
                    compact: root.inventoryOpen
                }

                // 3x9 Accessories grid appears instantaneously under InfoPanel when inventory is open
                AccessoryPanel {
                    anchors.right: parent.right
                    visible: root.inventoryOpen
                }
            }

            // Far right edge: Vertical Mana Star Column
            Mana {
                id: manaBar
                anchors.top: parent.top
            }
        }

        // OVERLAY ELEMENTS: Search Bar & Settings Button (only visible when inventory is open)
        Inventory {
            id: inventoryOverlay
            anchors.fill: parent
            visible: root.inventoryOpen
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
