# Yabai Display Manager

Automatic window layout management for switching between external display and built-in MacBook display.

## Problem

When disconnecting an external display, macOS rearranges windows in ways that break yabai's tiling layout:
- Windows from the external display get merged into the built-in display
- The BSP tiling layout becomes cluttered and unusable on the smaller built-in screen

## Solution

A simple set of scripts that automatically handle display connect/disconnect events:

**When external display is disconnected (built-in mode):**
1. Switch all spaces to `float` layout
2. Maximize all windows using `yabai -m window --grid 1:1:0:0:1:1`

**When external display is reconnected (external mode):**
1. Switch all spaces to `bsp` layout
2. Balance windows in BSP spaces

Exception apps (defined with `manage=off` in yabairc) remain floating in both modes.

## Files

```
~/.config/yabai/
├── yabairc                     # Main config with signal handlers
├── CLAUDE.md                   # This file
├── scripts/
│   ├── display_manager.sh      # Main logic for switching modes
│   ├── on_display_added.sh     # Signal handler for display connect
│   ├── on_display_removed.sh   # Signal handler for display disconnect
│   └── toggle_display_mode.sh  # Manual toggle
├── state/
│   └── display_manager.log     # Debug logs
└── backup_*/                   # Backups of previous configurations
```

## Usage

### Automatic (default)

The scripts run automatically via yabai signals. Just connect/disconnect your display.

### Manual toggle

```bash
# Switch to built-in mode (float + maximize)
~/.config/yabai/scripts/toggle_display_mode.sh builtin

# Switch to external mode (BSP)
~/.config/yabai/scripts/toggle_display_mode.sh external

# Toggle between modes
~/.config/yabai/scripts/toggle_display_mode.sh toggle

# Check current status
~/.config/yabai/scripts/toggle_display_mode.sh status
```

### Optional skhd keybinding

Add to `~/.config/skhd/skhdrc`:
```bash
ctrl + alt - d : ~/.config/yabai/scripts/toggle_display_mode.sh toggle
```

## Debugging

View logs:
```bash
tail -f ~/.config/yabai/state/display_manager.log
```

Check script status:
```bash
~/.config/yabai/scripts/display_manager.sh status
```

## Limitations

- Window positions within BSP trees are auto-balanced, not restored to exact previous positions
- Windows that moved to different spaces during macOS's disconnect shuffle stay on their new spaces

## Exception Apps

Apps with `manage=off` in yabairc stay floating in both modes:
- System Settings
- Finder
- Preview

Add more exceptions in yabairc:
```bash
yabai -m rule --add app="^AppName$" manage=off
```
