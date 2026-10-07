pragma Singleton
import QtQuick
import Quickshell

QtObject {
    // Mode switch: TERRARIA_MOCK=1 allows simulating hardware in a VM or headless session
    readonly property bool mockMode: Quickshell.env("TERRARIA_MOCK") === "1"
}
