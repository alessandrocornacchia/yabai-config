#!/usr/bin/env bash
#
# Handler for display_added event
# Called by yabai when a display is connected
#
# Environment variables from yabai:
#   $YABAI_DISPLAY_ID - UUID of the added display
#   $YABAI_DISPLAY_INDEX - Index of the added display
#

SCRIPT_DIR="$(dirname "$0")"
STATE_DIR="$HOME/.config/yabai/state"
LOG_FILE="$STATE_DIR/display_manager.log"

# UUID of the built-in MacBook display (ignore this one)
BUILTIN_DISPLAY_UUID="37D8832A-2D66-02CA-B9F7-8F30A301B230"

mkdir -p "$STATE_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "display_added signal received: ID=$YABAI_DISPLAY_ID INDEX=$YABAI_DISPLAY_INDEX"

# Ignore if the built-in display was added (e.g., lid opened)
if [[ "$YABAI_DISPLAY_ID" == "$BUILTIN_DISPLAY_UUID" ]]; then
    log "Ignoring display_added for built-in display"
    exit 0
fi

log "External display added, switching to BSP mode"
"$SCRIPT_DIR/display_manager.sh" added
