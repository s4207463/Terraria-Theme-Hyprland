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

    // IPC handler for 2D Player Demo: `qs ipc call player <action>`
    IpcHandler {
        target: "player"
        function walkLeft() { playerDemo.walkLeft() }
        function walkRight() { playerDemo.walkRight() }
        function stop() { playerDemo.stop() }
        function jump() { playerDemo.jump() }
        function moveTo(target: real) { playerDemo.moveTo(target) }
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
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        // Input mask: ONLY the interactive UI panels intercept clicks.
        // Transparent areas pass 100% of mouse clicks straight through to games/windows behind!
        mask: Region {
            Region { item: hotbar }
            Region { item: hudCol }
            Region { item: accessoryPanel }
            Region { item: inventoryOverlay.searchBarContainer }
            Region { item: inventoryOverlay.settingsBtn }
            Region { item: playerDemo.groundStrip }
            Region { item: playerDemo.characterItem }
            Region { item: playerDemo.guideBadge }
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

        // TOP-RIGHT: HUD Stack (Health/Mana Bar, Minimap, InfoPanel) - ~1/3 vertical height
        Column {
            id: hudCol
            anchors.right: parent.right
            anchors.rightMargin: Theme.panelPadding * 2
            anchors.top: parent.top
            anchors.topMargin: Theme.panelPadding * 2
            width: Math.max(Theme.healthBarWidth, Theme.minimapWidth)
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
        }

        // BOTTOM: 2D Movable Terraria Character Demo
        PlayerDemo {
            id: playerDemo
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: root.inventoryOpen ? (Theme.settingsRightMargin + 190) : 0
            anchors.bottom: parent.bottom
            height: Theme.groundHeight + Theme.playerHeight + 90
        }

        // MID-TO-BOTTOM-RIGHT: 3x9 Accessories Grid (only visible when inventory is open)
        // Positioned independently: ~1/2 vertical length, directly above Settings button
        AccessoryPanel {
            id: accessoryPanel
            anchors.right: parent.right
            anchors.rightMargin: Theme.settingsRightMargin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.buttonHeight + Theme.panelPadding * 3 + Theme.spacing * 2
            visible: root.inventoryOpen
        }

        // OVERLAY ELEMENTS: Search Bar & Settings Button (only visible when inventory is open)
        Inventory {
            id: inventoryOverlay
            anchors.fill: parent
            visible: root.inventoryOpen
            onRequestClose: root.inventoryOpen = false
            onRequestSettings: console.log("[TerrariaShell] Settings clicked")
        }

        // Keyboard handler when inventory is open: instant 0ms closing on Escape, Alt, Super, F1, I
        Item {
            anchors.fill: parent
            focus: root.inventoryOpen

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Escape ||
                    event.key === Qt.Key_Alt ||
                    event.key === Qt.Key_Super_L ||
                    event.key === Qt.Key_Super_R ||
                    event.key === Qt.Key_F1 ||
                    event.key === Qt.Key_I) {
                    root.inventoryOpen = false
                    event.accepted = true
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("[TerrariaShell] Shell initialized")
        console.log("[TerrariaShell] Mock mode:", Config.mockMode ? "ENABLED (TERRARIA_MOCK=1)" : "DISABLED (Live system)")
        console.log("[TerrariaShell] Theme loaded successfully")
    }
}
