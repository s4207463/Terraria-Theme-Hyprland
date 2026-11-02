import QtQuick
import "../services"

// PlayerDemo: 2D Movable Character Demo with Terraria physics & controls
// - Horizontal momentum, acceleration & deceleration
// - Gravity, jumping, and ground collision
// - Walking step animation & horizontal direction flipping
// - Both keyboard (A/D/Space or Arrows) and mouse (click-to-walk, click-to-jump)
Item {
    id: root

    property alias interactiveArea: interactiveArea
    property alias playableArea: playableArea
    property alias groundStrip: groundStrip
    property alias characterItem: characterItem
    property alias guideBadge: guideBadge
    property bool activeControl: false

    // Physics & Position state
    property real characterX: 120
    property real jumpY: 0
    property real vx: 0
    property real vy: 0
    property bool facingRight: true
    property bool onGround: true
    property real walkCycle: 0

    // Input state
    property bool keyLeft: false
    property bool keyRight: false
    property bool keyJump: false
    property real targetX: -1

    readonly property real groundY: root.height - Theme.groundHeight
    readonly property real maxSpeed: 4.5
    readonly property real accel: 0.6
    readonly property real friction: 0.78
    readonly property real gravity: 0.55
    readonly property real jumpPower: 9.5

    // Programmatic / IPC Control API
    function walkLeft() {
        root.keyRight = false
        root.keyLeft = true
        root.targetX = -1
    }

    function walkRight() {
        root.keyLeft = false
        root.keyRight = true
        root.targetX = -1
    }

    function stop() {
        root.keyLeft = false
        root.keyRight = false
        root.targetX = -1
    }

    function jump() {
        if (root.onGround) {
            root.vy = root.jumpPower
            root.onGround = false
        }
    }

    function moveTo(xCoord) {
        root.targetX = xCoord
    }

    focus: true

    // 60 FPS Physics Simulation Loop
    Timer {
        id: gameLoop
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            // 1. Mouse Click-to-Walk navigation
            if (root.targetX >= 0) {
                var diff = root.targetX - (root.characterX + Theme.playerWidth / 2)
                if (Math.abs(diff) > 5) {
                    if (diff > 0) {
                        root.keyRight = true
                        root.keyLeft = false
                    } else {
                        root.keyLeft = true
                        root.keyRight = false
                    }
                } else {
                    root.targetX = -1
                    root.keyLeft = false
                    root.keyRight = false
                }
            }

            // 2. Horizontal acceleration & friction
            if (root.keyLeft) {
                root.vx = Math.max(root.vx - root.accel, -root.maxSpeed)
                root.facingRight = false
            } else if (root.keyRight) {
                root.vx = Math.min(root.vx + root.accel, root.maxSpeed)
                root.facingRight = true
            } else {
                root.vx *= root.friction
                if (Math.abs(root.vx) < 0.1) root.vx = 0
            }

            // Boundary clamping
            root.characterX = Math.max(8, Math.min(root.width - Theme.playerWidth - 8, root.characterX + root.vx))

            // 3. Vertical physics (Jump & Gravity)
            if (root.keyJump && root.onGround) {
                root.vy = root.jumpPower
                root.onGround = false
            }

            if (!root.onGround) {
                root.vy -= root.gravity
                root.jumpY += root.vy
                if (root.jumpY <= 0) {
                    root.jumpY = 0
                    root.vy = 0
                    root.onGround = true
                }
            }

            // 4. Walk cycle bob & limb swing
            if (Math.abs(root.vx) > 0.2 && root.onGround) {
                root.walkCycle = (root.walkCycle + 0.3) % (Math.PI * 2)
            } else {
                root.walkCycle = 0
            }
        }
    }

    // Reset key states on focus loss, but PRESERVE mouse navigation targetX
    onActiveFocusChanged: {
        if (!activeFocus) {
            root.keyLeft = false
            root.keyRight = false
            root.keyJump = false
            root.activeControl = false
        }
    }

    // Keyboard handlers
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Escape) {
            root.activeControl = false
            root.focus = false
            event.accepted = true
            return
        }
        if (event.key === Qt.Key_A || event.key === Qt.Key_Left) {
            root.keyLeft = true
            root.targetX = -1
            event.accepted = true
        } else if (event.key === Qt.Key_D || event.key === Qt.Key_Right) {
            root.keyRight = true
            root.targetX = -1
            event.accepted = true
        } else if (event.key === Qt.Key_Space || event.key === Qt.Key_W || event.key === Qt.Key_Up) {
            root.keyJump = true
            event.accepted = true
        }
    }

    Keys.onReleased: function(event) {
        if (event.key === Qt.Key_A || event.key === Qt.Key_Left) {
            root.keyLeft = false
            event.accepted = true
        } else if (event.key === Qt.Key_D || event.key === Qt.Key_Right) {
            root.keyRight = false
            event.accepted = true
        } else if (event.key === Qt.Key_Space || event.key === Qt.Key_W || event.key === Qt.Key_Up) {
            root.keyJump = false
            event.accepted = true
        }
    }

    // Interactive Area for Window Input Region Masking
    Item {
        id: interactiveArea
        anchors.fill: parent

        // 0. Full Playable interaction zone across the walking strip
        Item {
            id: playableArea
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Theme.groundHeight + Theme.playerHeight + 25

            // Primary Click-to-Walk and Jump interaction across entire walking zone
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onClicked: function(mouse) {
                    if (mouse.button === Qt.RightButton) {
                        if (root.onGround) {
                            root.vy = root.jumpPower
                            root.onGround = false
                        }
                    } else {
                        root.targetX = mouse.x
                    }
                    root.activeControl = true
                    root.forceActiveFocus()
                }
            }
        }

        // 1. Ground strip with grass rim
        Rectangle {
            id: groundStrip
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Theme.groundHeight
            color: Theme.groundBody
            border.color: Theme.panelBorder
            border.width: Theme.borderWidth

            // Grass rim along top
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 4
                color: Theme.groundTop
            }
        }

        // 2. Control Guide Badge
        Rectangle {
            id: guideBadge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: groundStrip.top
            anchors.bottomMargin: Theme.panelPadding
            implicitWidth: guideText.implicitWidth + Theme.panelPadding * 3
            implicitHeight: guideText.implicitHeight + Theme.panelPadding
            radius: Theme.panelRadius
            color: Theme.panel
            border.color: root.activeControl ? Theme.highlight : Theme.panelBorder
            border.width: 1
            opacity: guideHover.containsMouse ? 1.0 : (root.activeControl ? 0.95 : 0.75)
            Behavior on opacity { NumberAnimation { duration: 150 } }

            Text {
                id: guideText
                anchors.centerIn: parent
                text: root.activeControl
                    ? "🎮 [A / D] Walk • [Space] Jump • Click Ground to Move • [Esc] Release Focus"
                    : "Player Demo: Click ground to walk or activate keyboard [A / D / Space]"
                color: root.activeControl ? Theme.highlight : Theme.textDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall - 2
                font.bold: root.activeControl
            }

            MouseArea {
                id: guideHover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.activeControl = true
                    root.forceActiveFocus()
                }
            }
        }

        // 3. 2D Terraria Character Body
        Item {
            id: characterItem
            x: root.characterX
            y: root.groundY - Theme.playerHeight - root.jumpY
            width: Theme.playerWidth
            height: Theme.playerHeight

            // Directional flip (faces left or right)
            transform: Scale {
                origin.x: Theme.playerWidth / 2
                xScale: root.facingRight ? 1 : -1
            }

            // Click character directly to jump
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.onGround) {
                        root.vy = root.jumpPower
                        root.onGround = false
                    }
                    root.activeControl = true
                    root.forceActiveFocus()
                }
            }

            // Visual Skeleton Anatomy (Phase 1: Zero Art, pure token shapes derived from Theme)
            Item {
                anchors.fill: parent
                y: Math.abs(Math.sin(root.walkCycle)) * -2 // Walking bob

                // Head (Hair + Face + Directional Eye)
                Rectangle {
                    id: head
                    x: 4
                    y: 2
                    width: 16
                    height: 14
                    radius: 2
                    color: Theme.playerSkin

                    // Hair Cap
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 5
                        radius: 2
                        color: Theme.playerHair
                    }

                    // Back Hair strand
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        width: 3
                        color: Theme.playerHair
                    }

                    // Eye (faces forward towards direction of movement)
                    Rectangle {
                        x: 11
                        y: 7
                        width: 2
                        height: 4
                        color: Theme.background
                    }
                }

                // Torso / Shirt & Belt
                Rectangle {
                    id: torso
                    x: 4
                    y: 17
                    width: 16
                    height: 14
                    radius: 1
                    color: Theme.playerShirt
                    border.color: Theme.panelBorder
                    border.width: 1

                    // Belt
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 3
                        color: Theme.panelBorder
                    }

                    // Front Arm (swings while walking)
                    Rectangle {
                        x: 5
                        y: 1
                        width: 4
                        height: 11
                        radius: 1
                        color: Theme.playerShirt
                        border.color: Theme.panelBorder
                        border.width: 1
                        transform: Rotation {
                            origin.x: 2
                            origin.y: 2
                            angle: Math.sin(root.walkCycle) * 24
                        }
                    }
                }

                // Legs & Shoes (swinging with walk cycle or spread while jumping)
                Item {
                    id: legs
                    x: 4
                    y: 31
                    width: 16
                    height: 13

                    // Left Leg (Back)
                    Rectangle {
                        x: 2
                        y: 0
                        width: 5
                        height: 13
                        radius: 1
                        color: Theme.playerPants

                        // Shoe tip
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 3
                            color: Theme.panelBorder
                        }

                        transform: Rotation {
                            origin.x: 2.5
                            origin.y: 0
                            angle: !root.onGround ? -15 : (Math.sin(root.walkCycle) * 28)
                        }
                    }

                    // Right Leg (Front)
                    Rectangle {
                        x: 9
                        y: 0
                        width: 5
                        height: 13
                        radius: 1
                        color: Theme.playerPants

                        // Shoe tip
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 3
                            color: Theme.panelBorder
                        }

                        transform: Rotation {
                            origin.x: 2.5
                            origin.y: 0
                            angle: !root.onGround ? 20 : (-Math.sin(root.walkCycle) * 28)
                        }
                    }
                }
            }
        }
    }
}
