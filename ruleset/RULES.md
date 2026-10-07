# RULES.md: Instructions for the AI coding agent

Read this file and `DESIGN.md` before every task. If a request conflicts with either, say so and ask instead of guessing.

The project is built in **three phases**, in order:

| Phase | Name | Focus | Art? |
|---|---|---|---|
| 1 | Features | Everything works, ugly is fine | No (placeholders only) |
| 2 | Design | Everything looks right, fake data only | Yes (no real logic) |
| 3 | Integration | Apply the design onto the working features | Yes (no new logic) |

**Always know which phase you are in. The owner will say it at the start of a task.** If the phase is not stated, ask. Never mix phases in one task.

---

## Part A: Rules that apply in every phase

### A1. Project context

- Project: Terraria-themed Hyprland shell (see `DESIGN.md`).
- OS: CachyOS (Arch-based). Compositor: Hyprland. UI toolkit: **Quickshell (QML)**.
- Owner is a student learning Linux and cybersecurity. Explain non-obvious steps briefly, in plain language.

### A2. Golden rules

1. **Small steps.** One feature or milestone per task. Do not build ahead of the current milestone.
2. **Never claim something works unless it was run.** If you could not test it, say "untested" and say exactly how the owner can test it.
3. **Do not invent APIs.** If unsure about a Quickshell, Hyprland, or QML API, check the official docs or ask. Never fabricate property names, module names, or CLI flags.
4. **Do not touch the live system.** Never edit `~/.config/hypr/`, `~/.config/quickshell/`, or system files directly. Work only inside the repo. Use symlinks via `stow`.
5. **Ask before** installing packages, enabling services, changing keybinds in the real config, or deleting anything.
6. **Prefer simple.** No new dependency or daemon without a reason written in the commit message.

### A3. The separation rule (what makes three phases possible)

Logic and looks must stay separate from day one:

- **Logic** lives in `services/` and in each component's behavior (signals, state, commands).
- **Looks** live only in the `Theme` singleton and in `assets/`. Components read colors, sizes, fonts, and images from `Theme` and never hardcode them.
- In Phase 1, `Theme` holds **placeholder tokens** (flat colors, default font, rectangles for sprites). In Phase 2 and 3, the same tokens get real values and images.
- If a component cannot be re-skinned by changing only `Theme` and `assets/`, it was built wrong. Fix it.

### A4. Repository layout (GNU Stow)

```
Terraria-Theme-Hyprland/
├── DESIGN.md
├── RULES.md
├── README.md
├── hypr/.config/hypr/            (hyprland.conf, test.conf, keybinds)
├── quickshell/.config/quickshell/
│   ├── shell.qml
│   ├── components/               (Hotbar, Inventory, InfoPanel, Minimap, Hearts, Village)
│   ├── accessories/              (one QML + JSON definition each)
│   ├── services/                 (Theme, Apps, Favorites, Stats, Power singletons)
│   ├── settings/
│   ├── preview/                  (Phase 2 design gallery, mock data only)
│   └── assets/                   (original/CC0 sprites and fonts only)
├── wallpapers/
├── scripts/
└── reference/                    (git-ignored: private Terraria screenshots)
```

- Each top-level folder is a stow package.
- Every file path inside a package mirrors its location under `$HOME`.

### A5. Coding conventions

**QML**
- One component per file. File name = component name (`Hotbar.qml`).
- No polling timers unless required. Use events and signals first. Any timer must stop when its component is hidden or its accessory is unequipped.
- Cap animation at 30 FPS. Do not render hidden overlays.
- Pixel art: nearest-neighbor scaling (`smooth: false`).
- Keep files short and readable. Comment the *why*, not the *what*.

**Shell scripts**
- Bash with `set -euo pipefail`. Quote every variable.
- No `sudo` anywhere. If a feature seems to need root, stop and ask.
- Scripts must be idempotent.

**Hyprland config**
- Test keybinds in `test.conf` (nested, `$mod = ALT`) before touching the real config.
- Keep all Terraria binds in one clearly marked block or file.
- Every bind that calls the shell goes through `qs ipc call ...`.

### A6. Security rules

- **Never commit secrets**: SSH keys, tokens, `.env`, browser profiles, VPN configs, Wi-Fi passwords.
- No hardcoded credentials, ever. Accessory commands may reference a connection **name**, never its secret.
- Do not pipe remote scripts into a shell (`curl | sh`).
- Before any commit: show `git status` and `git diff --cached` and check for sensitive data.
- Validate and quote anything read from the system (app names, window titles) before passing it to a shell command. Never build commands by string concatenation with untrusted text.

### A7. Licensing and assets

- Do **not** add Terraria's sprites, audio, or font files to the repo.
- Do not copy or redraw Terraria's characters or items. Create **original** sprites with the same roles (a Guide-like old man, a Nurse-like healer).
- Third-party assets: only CC0 or properly licensed ones, and record the source and license in `assets/CREDITS.md`.
- Fonts: free pixel font under OFL. The font family is one setting so it can be swapped.

### A8. Performance rules

- Respect the budget in `DESIGN.md` section 6.
- Unequipped accessory means no polling. Hidden overlay means no rendering.
- When adding a feature, state its expected idle cost.
- The village scene is static: no physics, no game loop. Redraw only on interaction or biome change. Any idle NPC animation runs at a few FPS at most and stops when the scene is hidden.

### A9. Git rules

- Commit after every working step. Conventional messages: `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`.
- One logical change per commit. Never force-push. Never rewrite history on `main`.
- One branch per milestone, named with its phase (`p1-m2-hotbar`, `p2-inventory-panel`, `p3-hotbar-skin`). Merge only when the phase's Definition of Done is met.

### A10. Workflow for every task

1. State the phase and milestone, and restate the task in one or two sentences.
2. List the files that will be created or changed.
3. Implement the smallest working version.
4. Give the owner the exact commands to run and what they should see:
   - `quickshell -p ~/dotfiles/quickshell/.config/quickshell`
   - `stow <package>` or `stow -R <package>` to restow
5. Report: what changed, what is untested, what is next. Keep it short.

### A11. Recovery

If a change breaks the session:

1. Switch to a TTY: `Ctrl+Alt+F3`, log in.
2. `cd` into the repo and run `git checkout -- .` or `git revert <commit>`.
3. `hyprctl reload`, or restart Quickshell.

### A12. Hard stops (ask the owner first)

- Anything requiring `sudo`, a new system service, or editing files outside the repo
- Deleting files or rewriting git history
- Adding a new dependency or language
- Changing the architecture in `DESIGN.md`
- Any command that changes network, VPN, or firewall state outside a defined accessory

---

## Part B: Phase 1, Features (no art)

**Goal:** every feature in `DESIGN.md` works correctly and is testable. It is allowed to look ugly.

### B1. What is allowed

- Flat colored rectangles for slots, panels, hearts, and sprites
- Default system font
- Plain text labels like `[1] kitty`, `CPU 23%`, `Guide`
- Placeholder `Theme` tokens (neutral dark palette, one accent color)

### B2. What is NOT allowed

- Real art, sprites, custom fonts, gradients, borders, or decoration
- Spending time on polish or animation (the village scene stays static in this phase)
- Hardcoding colors or sizes in components (the separation rule still applies)

### B3. Build order

1. Repo skeleton, stow layout, placeholder `Theme.qml`, mock mode switch (`TERRARIA_MOCK=1`)
2. Hotbar logic: 10 slots, launch/focus, focused-app tracking
3. Inventory overlay: app list, search, launch, open/close via `Super` tap (IPC)
4. Favorites (JSON) and hotbar assignment
5. Info accessories: TIME, then CPU, RAM, GPU
6. Hearts (battery logic) and Minimap (workspace preview or image slot)
7. Toggle accessories: Wi-Fi, Bluetooth, VPN first, with real state sync
8. Village scene: biome switch (theme + scene + houses), NPC houses as clickable rectangles, Guide NPC showing live keybinds
9. Settings app logic: Controls tab (read binds, edit binds with backup), accessory selection

### B4. Testing

- Develop in the live session using Quickshell hot reload, with the terminal open to read QML errors.
- Risky keybind work goes in nested Hyprland with `test.conf`.
- Hardware features (GPU, battery, Wi-Fi, Bluetooth) need mock mode so they can be tested in a VM.
- Write a short manual test checklist per feature in `docs/test-checklist.md` (action, expected result).

### B5. Definition of Done: Phase 1

- [ ] Every feature in `DESIGN.md` sections 3.1 to 3.5 works end to end
- [ ] No QML errors or warnings in the terminal during a 10-minute normal session
- [ ] All colors, sizes, and fonts come from `Theme` (grep finds no hardcoded values in components)
- [ ] Idle cost checked and within budget
- [ ] Mock mode works for all hardware features
- [ ] Manual test checklist exists and passes
- [ ] No secrets or copyrighted assets in the diff
- [ ] Tagged `phase-1-complete`

---

## Part C: Phase 2, Design (no logic)

**Goal:** define and build the full visual look, using fake data, without changing how features work.

### C1. What is allowed

- Filling in the `Theme` palette (all biome themes), panel styles, borders, gradients, spacing
- Pixel fonts, sprites, icons, hearts, mana stars, slot frames, cursor, minimap frame
- A **design gallery** in `preview/`: a standalone Quickshell window that renders every component in every state using **mock data only** (selected slot, favorited slot, empty slot, hover, equipped and unequipped accessory, low battery, NPC dialogue, and so on)
- Mockups and reference notes in `reference/` and `docs/design-notes.md`

### C2. What is NOT allowed

- Any change to `services/`, IPC handlers, accessory commands, or keybinds
- Any call to real system commands from the preview
- Changing component behavior or public properties (adding purely visual properties is fine)
- Committing Terraria's art, audio, or font

### C3. Build order

1. Choose the default pixel font and record it in `assets/CREDITS.md`
2. Finalize the Night theme tokens, then add the other biome themes
3. Slot, panel, and border styles (hotbar slot, inventory slot, accessory slot, dialogue box)
4. Hearts, mana stars, minimap frame, info panel text style
5. Original art per biome: scene background, NPC houses, Guide-like / Nurse-like / Merchant-like NPCs, app-slot fallback icon
6. Settings window styling (tabs, buttons, keybinding rows)
7. Design gallery covering every state above

### C4. Rules for assets

- Original or CC0/CC-BY only, with sources recorded
- Sprites at 16x16 or 32x32, saved as PNG, scaled with nearest-neighbor
- Each sprite named by role (`npc_guide.png`, `slot_selected.png`), never by Terraria item name
- Keep total asset size small (target under 5 MB)

### C5. Definition of Done: Phase 2

- [ ] The design gallery shows every component in every state, using mock data
- [ ] Every biome theme is complete (no missing tokens)
- [ ] `git diff` against the Phase 1 tag shows **no changes** in `services/`, IPC code, or accessory commands
- [ ] Every asset has a recorded source and license
- [ ] The owner has reviewed the gallery and signed off on the look
- [ ] Tagged `phase-2-complete`

---

## Part D: Phase 3, Integration (feature + design)

**Goal:** apply the Phase 2 look onto the working Phase 1 features. This phase should be mostly wiring, not new logic.

### D1. What is allowed

- Replacing placeholder `Theme` tokens and rectangles with the Phase 2 values and sprites
- Adding purely visual behavior: hover and press states, selection highlight, small animations (hotbar select, heart pulse, NPC idle), sounds (optional, original or CC0)
- Fixing layout bugs that only appear with real art (clipping, scaling, alignment)
- Small logic fixes found during integration, **each in its own commit**, listed in the report

### D2. What is NOT allowed

- New features that are not in `DESIGN.md`
- Redesigning components or changing the architecture
- Breaking the separation rule (art must still come only from `Theme` and `assets/`)

### D3. Build order

1. Swap in the Night theme and fonts, check that every screen still works
2. Hotbar and Inventory skin, then Favorites highlight
3. Info panel, Hearts, Minimap
4. Accessory column and toggle states
5. Biome scenes, NPC houses, NPC sprites, dialogue boxes
6. Settings window skin
7. Biome switcher in Settings, live theme switching without restart
8. Polish pass and README with screenshots

### D4. Regression rules

- After each step, rerun the Phase 1 manual test checklist for the touched components. A feature that worked in Phase 1 must still work.
- Re-measure idle and active CPU and RAM. Art and animation must not break the budget in `DESIGN.md` section 6. If they do, reduce animation or sprite size.

### D5. Definition of Done: Phase 3

- [ ] Every Phase 1 checklist item still passes with the design applied
- [ ] Every Phase 2 gallery state is visibly matched by the real shell
- [ ] Performance is within budget
- [ ] Switching biome themes works at runtime
- [ ] Clean-install test passes (fresh VM or fresh user: clone, `stow`, run)
- [ ] README has install steps, screenshots, credits, and the licensing note
- [ ] Tagged `v1.0`

---

## Part E: Phase cheat sheet

| Question | Phase 1 | Phase 2 | Phase 3 |
|---|---|---|---|
| Can I edit `services/` and IPC? | Yes | **No** | Only for tiny fixes |
| Can I add real art and fonts? | **No** | Yes | Yes |
| Real system data or mock? | Real, with mock mode | **Mock only** | Real, with mock mode |
| Main deliverable | Working features | Design gallery | Finished shell |
| Success looks like | Ugly but correct | Pretty but fake | Pretty and correct |
