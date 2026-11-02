# Manual Test Checklist

## Phase 1: Features (no art)

### Milestone 1: Repo Skeleton & Mock Mode
- [ ] **Shell Startup**
  - **Action**: Run `quickshell -p quickshell/.config/quickshell`
  - **Expected Result**: Quickshell loads without errors or warnings; logs show startup with `Mock mode: DISABLED`.
- [ ] **Mock Mode Startup**
  - **Action**: Run `TERRARIA_MOCK=1 quickshell -p quickshell/.config/quickshell`
  - **Expected Result**: Quickshell loads without errors; logs show startup with `Mock mode: ENABLED`.
- [ ] **Theme Separation**
  - **Action**: Inspect `services/Theme.qml` and components.
  - **Expected Result**: No hardcoded color codes or sizes outside `services/Theme.qml`.
