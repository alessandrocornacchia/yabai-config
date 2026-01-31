#!/usr/bin/env bash
#
# Handler for display_removed event
# Called by yabai when a display is disconnected
#
# Environment variables from yabai:
#   $YABAI_DISPLAY_ID - UUID of the removed display
#

SCRIPT_DIR="$(dirname "$0")"
STATE_DIR="$HOME/.config/yabai/state"
LOG_FILE="$STATE_DIR/display_manager.log"

# UUID of the built-in MacBook display
BUILTIN_DISPLAY_UUID="37D8832A-2D66-02CA-B9F7-8F30A301B230"

mkdir -p "$STATE_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "display_removed signal received: ID=$YABAI_DISPLAY_ID"

# If built-in display was removed (lid closed), no action needed
# (external display becomes primary, keep BSP mode)
if [[ "$YABAI_DISPLAY_ID" == "$BUILTIN_DISPLAY_UUID" ]]; then
    log "Built-in display removed (lid closed), keeping current mode"
    exit 0
fi

log "External display removed, switching to built-in mode"
"$SCRIPT_DIR/display_manager.sh" removed
