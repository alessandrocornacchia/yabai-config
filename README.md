# Yabai Configuration

My [yabai](https://github.com/koekeishiya/yabai) tiling window manager configuration for macOS, with automatic display mode switching.

## Features

- **BSP tiling layout** for productive multi-window workflows
- **Automatic display mode switching** between external monitor and built-in MacBook display
- **Exception rules** for apps that should remain floating

## Display Modes

### External Display Mode (BSP)
When an external display is connected:
- All spaces use **BSP (Binary Space Partitioning)** layout
- Windows are automatically tiled and balanced
- Exception apps remain floating

### Built-in Display Mode (Float + Maximize)
When using only the MacBook's built-in display:
- All spaces switch to **float** layout
- All windows are **maximized** to fill the screen
- Better for the smaller built-in display

The mode switches automatically when you connect/disconnect an external display.

## Configuration

### Global Settings

| Setting | Value | Description |
|---------|-------|-------------|
| `layout` | `bsp` | Default tiling layout |
| `window_placement` | `second_child` | New windows open as second child |
| `auto_balance` | `on` | Automatically balance window sizes |
| `window_gap` | `10` | Gap between windows in pixels |
| `top/bottom/left/right_padding` | `1` | Padding around screen edges |
| `mouse_follows_focus` | `on` | Mouse moves to focused window |
| `mouse_modifier` | `fn` | Hold fn to move/resize windows with mouse |
| `mouse_action1` | `move` | fn + left-click to move |
| `mouse_action2` | `resize` | fn + right-click to resize |

### Exception Rules

These apps are excluded from tiling (`manage=off`):
- System Settings
- Finder
- Preview

Add more exceptions:
```bash
yabai -m rule --add app="^AppName$" manage=off
```

## Files

```
~/.config/yabai/
├── yabairc                     # Main yabai configuration
├── README.md                   # This file
├── CLAUDE.md                   # Development notes
├── scripts/
│   ├── display_manager.sh      # Display mode switching logic
│   ├── on_display_added.sh     # Handler for display connect
│   ├── on_display_removed.sh   # Handler for display disconnect
│   └── toggle_display_mode.sh  # Manual mode toggle
└── state/
    └── display_manager.log     # Debug logs
```

## Usage

### Manual Mode Toggle

```bash
# Switch to built-in mode
~/.config/yabai/scripts/toggle_display_mode.sh builtin

# Switch to external mode
~/.config/yabai/scripts/toggle_display_mode.sh external

# Toggle between modes
~/.config/yabai/scripts/toggle_display_mode.sh toggle

# Check current status
~/.config/yabai/scripts/toggle_display_mode.sh status
```

### Optional skhd Keybinding

Add to `~/.config/skhd/skhdrc`:
```bash
ctrl + alt - d : ~/.config/yabai/scripts/toggle_display_mode.sh toggle
```

### Debugging

View display manager logs:
```bash
tail -f ~/.config/yabai/state/display_manager.log
```

## Installation

1. Install yabai: `brew install koekeishiya/formulae/yabai`
2. Clone this repo to `~/.config/yabai`
3. Start yabai: `yabai --start-service`

See the [yabai wiki](https://github.com/koekeishiya/yabai/wiki) for detailed setup instructions, including configuring the scripting addition for full functionality.

## Requirements

- macOS
- [yabai](https://github.com/koekeishiya/yabai)
- [jq](https://stedolan.github.io/jq/) (for display manager scripts)
- Optional: [skhd](https://github.com/koekeishiya/skhd) for keyboard shortcuts
