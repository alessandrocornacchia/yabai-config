#!/usr/bin/env bash
#
# Manual toggle between display modes
# Usage: toggle_display_mode.sh [builtin|external|toggle|status]
#

SCRIPT_DIR="$(dirname "$0")"
STATE_DIR="$HOME/.config/yabai/state"
MODE_FILE="$STATE_DIR/current_mode"

mkdir -p "$STATE_DIR"

get_current_mode() {
    if [[ -f "$MODE_FILE" ]]; then
        cat "$MODE_FILE"
    else
        # Default based on display count
        if [[ $(yabai -m query --displays | jq 'length') -gt 1 ]]; then
            echo "external"
        else
            echo "builtin"
        fi
    fi
}

set_mode() {
    echo "$1" > "$MODE_FILE"
}

case "${1:-toggle}" in
    "builtin")
        "$SCRIPT_DIR/display_manager.sh" removed
        set_mode "builtin"
        echo "Switched to built-in mode (float + maximize)"
        ;;
    "external")
        "$SCRIPT_DIR/display_manager.sh" added
        set_mode "external"
        echo "Switched to external mode (BSP)"
        ;;
    "toggle")
        current=$(get_current_mode)
        if [[ "$current" == "builtin" ]]; then
            "$SCRIPT_DIR/display_manager.sh" added
            set_mode "external"
            echo "Switched to external mode (BSP)"
        else
            "$SCRIPT_DIR/display_manager.sh" removed
            set_mode "builtin"
            echo "Switched to built-in mode (float + maximize)"
        fi
        ;;
    "status")
        echo "Current mode: $(get_current_mode)"
        "$SCRIPT_DIR/display_manager.sh" status
        ;;
    *)
        echo "Usage: $0 [builtin|external|toggle|status]"
        exit 1
        ;;
esac
