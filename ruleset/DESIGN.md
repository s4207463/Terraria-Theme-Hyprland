# DESIGN.md: Terraria-Theme-Hyprland

A Hyprland desktop shell that borrows Terraria's **UI logic** (hotbar, inventory, accessories, minimap, NPCs) and applies it to a real Linux desktop. Built with Quickshell (QML) on CachyOS / Hyprland.

> Status: design phase. Nothing here is implemented until a milestone says so.

---

## 1. Goals

1. Make launching and switching apps feel like Terraria's hotbar and inventory.
2. Show system info (time, CPU, RAM, GPU, battery) like Terraria's info accessories.
3. Toggle system features (Wi-Fi, Bluetooth, VPN, ...) like equipping accessories.
4. Add small touches of life: a static village scene per biome with clickable NPC houses (the Guide shows real keybinds).
5. Stay **light**: near-zero CPU/RAM when idle.
6. Stay **portable**: a clean clone + `stow` reproduces the setup.

## 2. Non-goals

- Not a game. The character/NPC layer is decoration plus shortcuts to real features.
- No redistribution of Terraria's copyrighted art, audio, or fonts.
- No root/sudo requirement for any feature.
- No support for other compositors (Hyprland only).

---

## 3. Screens and components

### 3.1 Normal screen (always visible, minimal)

| Component | Location | Behavior |
|---|---|---|
| **Hotbar** | Top-left | 10 slots. Each slot = one app. Click or `Super+1..0` focuses the app, or launches it if not running. The focused app's slot is highlighted. |
| **Info panel** | Under the minimap, top-right | Text readouts of equipped info accessories (time, CPU, RAM, GPU, ...). Pixel font. |
| **Minimap** | Top-right | Framed image. Default: workspace overview. Optionally a custom image chosen in Settings. |
| **Hearts** | Top-right | Battery level. 20 hearts, each = 5%. Hidden or full on desktops without a battery. |

### 3.2 Inventory mode (tap `Super`)

| Component | Behavior |
|---|---|
| **Inventory grid** | All installed apps (from `.desktop` entries). The top row mirrors the hotbar. |
| **Search bar** | Centered. Focused immediately. Typing filters the grid. `Enter` launches the first match. |
| **Favorites** | `Alt+click` or `Alt+Enter` on an app toggles favorite (highlighted slot). Favorites fill the hotbar first. Stored in JSON. |
| **Hotbar editing** | Drag or assign an app to a hotbar slot. |
| **Accessory column** | Right side. Slots that can be equipped/unequipped (see 3.3). |
| **Settings button** | Bottom-right. Opens the Settings app (3.4). |
| **Close** | `Esc`, or tap `Super` again. Closing hides the overlay. |

### 3.3 Accessories

Two kinds, mirroring the game:

- **Info accessories** (read-only): equipped means its readout appears in the info panel.
  TIME, DATE, CPU, RAM, GPU, network speed, battery.
- **Toggle accessories** (act on the system): equipped means ON, unequipped means OFF.

| Accessory | Equipped = | Command (no root) |
|---|---|---|
| Wi-Fi | Radio on | `nmcli radio wifi on\|off` |
| Bluetooth | Powered | `bluetoothctl power on\|off` |
| Airplane mode | All radios off | `rfkill block\|unblock all` |
| VPN | Tunnel up | `nmcli connection up\|down <name>` |
| Mic mute | Mic live | `wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0\|1` |
| Do Not Disturb | Notifications paused | notification daemon CLI (swaync or dunst) |
| Night light | Filter on | start/stop `hyprsunset` or `gammastep` |
| Caffeine | Never sleep | pause/resume `hypridle` |

Rules for accessories:

- Every accessory is defined by **three commands**: `on`, `off`, `state`.
- The slot must show the **real** state, never just the last click. If the state changes outside the shell, the slot updates.
- Prefer event-based updates (D-Bus / `nmcli monitor`). Otherwise slow polling, **only while equipped or visible**.
- Info accessories that are unequipped must **not poll at all**.

### 3.4 Settings app (Terraria-style menu)

Tabs: General, Interface, Controls, Accessories, Close.

- **Controls** reads `hyprctl binds -j` and displays keybinds in the layout of Terraria's Keybindings screen. Editing a bind writes back to the stow-managed config (with a backup).
- **Interface**: pick the biome theme, minimap image, font size, which hotbar slots are shown.
- **Accessories**: choose which info/toggle accessories exist and their order.

### 3.5 Village scene (biome + NPC houses)

A static scene, not a game: **no free-roaming character, no physics, no game loop.**

- The scene is a strip shown inside the inventory overlay (visible only in inventory mode by default). Bare letter keys are never grabbed.
- It shows the current biome's background and a row of **NPC houses**. Each house is a clickable hotspot with a hover highlight.
- Clicking a house opens that NPC's dialogue/panel (original art, same roles as the game):
  - **Guide**: shows live keybinds from `hyprctl binds -j`.
  - **Nurse**: shows battery and system health.
  - **Merchant**: opens the app launcher.
  - More roles can be added later (for example, an NPC that opens the toggle accessories).
- **Biome switching:** a biome = theme palette + scene art + its set of houses. Switch from Settings or from a small biome selector in the village. Switching is instant and saved in the settings JSON.
- Rendering: images only. Redraw on interaction or biome change. Optional idle NPC animation runs at a few FPS at most and stops when the scene is hidden.

---

## 4. Architecture

One Quickshell process owns all UI. No extra daemons.

```
Hyprland
  |-- keybinds --> `qs ipc call <target> <fn>` --> Quickshell
  |-- events (activewindow, workspace) --> Quickshell.Hyprland module
Quickshell (QML)
  |-- Hotbar.qml
  |-- Inventory.qml
  |-- InfoPanel.qml
  |-- Minimap.qml
  |-- Hearts.qml
  |-- Accessories/ (one QML + JSON definition per accessory)
  |-- Village.qml (biome scene + NPC houses)
  |-- Settings/ (separate window)
  `-- services/ (Theme, Apps, Favorites, Stats, Power singletons)
```

- **IPC**: Hyprland keybinds call `qs ipc call` into `IpcHandler` targets (for example `inventory toggle`). Verify exact syntax against the Quickshell docs before using.
- **State**: favorites, hotbar layout, equipped accessories, and settings live in JSON under `~/.config/terraria-shell/` (or XDG equivalent). No secrets ever stored.
- **Data sources**: `/proc/stat`, `/proc/meminfo`, `/sys/class/power_supply/`, vendor GPU tools, `nmcli`, `bluetoothctl`, `wpctl`, `hyprctl`. Read-only unless an accessory toggles it.

## 5. Theme

- One palette file (`Theme.qml` singleton plus a JSON mirror). **No hardcoded colors elsewhere.**
- Biome themes, switchable in Settings or in the village: Night (default), Corruption, Crimson, Hallow, Jungle, Snow, Underworld, Dungeon.
- A biome is more than colors: it also selects the village scene art and its NPC houses (see 3.5).
- Each theme defines: background, panel, panel-border, text, text-dim, accent, danger (hearts), mana, highlight (selected slot).
- Panels use an inventory-style look: dark blue-ish panel, light border, slight inner gradient, rounded corners.

### Fonts

- Terraria's UI font (Andy Bold) is not freely licensed. Do not commit it.
- Default to a free pixel font (OFL licensed). The font name is a single setting, so a user can swap in their own privately.

### Art assets

- Original or CC0/CC-BY pixel art only in the repo.
- Terraria screenshots are used as **private design reference only** and must not be committed. Keep them in an ignored `reference/` folder.
- Sprites: 16x16 or 32x32, scaled with nearest-neighbor (no smoothing).

## 6. Performance budget

| State | Target |
|---|---|
| Idle (overlay hidden, nothing equipped) | ~0% CPU, small RAM |
| Normal screen (hotbar + hearts + a few readouts) | Under 1-2% of one core |
| Inventory open / village scene visible | Under 3% of one core (redraw only on interaction or biome change) |

## 7. Phases and milestones

The project is built in three phases (details and rules in `RULES.md`).

### Phase 1: Features (no art)

Placeholder visuals only: flat rectangles, default font, text labels.

1. Repo skeleton, stow layout, placeholder `Theme.qml`, mock mode.
2. Hotbar logic: 10 slots, launch/focus, focus tracking.
3. Inventory overlay: app list, search, launch, `Super` tap toggle.
4. Favorites (JSON) plus hotbar assignment.
5. Info accessories: TIME, then CPU, RAM, GPU.
6. Hearts (battery logic) and Minimap slot.
7. Toggle accessories (Wi-Fi, Bluetooth, VPN first).
8. Village scene: biome switch, NPC houses as clickable rectangles, Guide dialogue.
9. Settings app logic (Controls tab first).

### Phase 2: Design (no logic)

Fake data only. No changes to `services/`, IPC, or accessory commands.

1. Pick the pixel font, finalize the Night theme tokens.
2. Remaining biome themes.
3. Slot, panel, border, and dialogue styles.
4. Hearts, mana stars, minimap frame, info panel text style.
5. Original art per biome (scene background, NPC houses, NPCs, fallback icon).
6. Settings window styling.
7. Design gallery in `preview/` covering every component state.

### Phase 3: Integration (feature + design)

Apply the Phase 2 look onto the Phase 1 features.

1. Night theme and fonts applied everywhere.
2. Hotbar, Inventory, Favorites skinned.
3. Info panel, Hearts, Minimap skinned.
4. Accessory column and toggle states skinned.
5. Biome scenes, NPC houses, dialogue boxes.
6. Settings window skin.
7. Live biome switching.
8. Polish, README, screenshots.

A phase is **done** only when it meets its Definition of Done in `RULES.md`.

## 8. Open questions

- GPU vendor (NVIDIA / AMD / Intel) decides the GPU readout command.
- Whether hotbar slots auto-fill from favorites or are fully manual.
- Whether the minimap shows a live workspace preview (`grim`) or a static image by default.
- Whether to add an optional tiny character that hops to the clicked house (a simple tween, no physics, off by default).
