# Terraria-Theme-Hyprland

A desktop shell for Hyprland on CachyOS inspired by Terraria's UI logic (hotbar, inventory, accessories, minimap, and NPC village), built with **Quickshell (QML)**.

---

## Architecture & Roadmap

The project follows a strict three-phase build order:
1. **Phase 1: Features (No Art)** – Functional system integration, IPC, and mock modes with placeholder rectangle tokens.
2. **Phase 2: Design (No Logic)** – Asset creation, styling tokens, and an isolated design gallery using mock data.
3. **Phase 3: Integration** – Skinning Phase 1 features with Phase 2 visuals and themes.

For full rules and architecture details, refer to:
- [`DESIGN.md`](./DESIGN.md)
- [`RULES.md`](./RULES.md)

---

## Repository Layout (GNU Stow)

```
Terraria-Theme-Hyprland/
├── DESIGN.md                     # Architecture and feature specifications
├── RULES.md                      # AI agent instructions, phases, and conventions
├── README.md                     # Project overview and quickstart
├── docs/                         # Test checklists and design notes
├── hypr/.config/hypr/            # Hyprland configuration (test.conf, keybinds)
├── quickshell/.config/quickshell/
│   ├── shell.qml                 # Main Quickshell entry point
│   ├── components/               # UI components (Hotbar, Inventory, InfoPanel, etc.)
│   ├── accessories/              # Info & toggle accessory definitions
│   ├── services/                 # Singletons (Theme, Config/Mock, Stats, etc.)
│   ├── settings/                 # Settings window
│   ├── preview/                  # Design gallery for Phase 2
│   └── assets/                   # Original / CC0 assets & CREDITS.md
├── wallpapers/                   # Biome wallpapers
├── scripts/                      # Helper scripts
└── reference/                    # Private design references (git-ignored)
```

---

## Testing Quickshell

Run Quickshell pointing directly to the repository configuration:

```bash
quickshell -p quickshell/.config/quickshell
```

To enable mock mode (simulating hardware readouts without touching real hardware):

```bash
TERRARIA_MOCK=1 quickshell -p quickshell/.config/quickshell
```
