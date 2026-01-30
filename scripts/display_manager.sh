#!/usr/bin/env bash
#
# Yabai Display Manager (Simplified)
# Handles switching between external display (BSP) and built-in display (float + maximized)
#

STATE_DIR="$HOME/.config/yabai/state"
LOG_FILE="$STATE_DIR/display_manager.log"

mkdir -p "$STATE_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

get_display_count() {
    yabai -m query --displays | jq 'length'
}

is_builtin_only() {
    [[ $(get_display_count) -eq 1 ]]
}

# Switch to float layout and maximize all windows (for built-in display)
switch_to_builtin_mode() {
    log "Switching to built-in mode (float + maximize)..."

    sleep 1  # Let macOS settle after display change

    # Set all spaces to float layout
    local spaces=$(yabai -m query --spaces | jq -r '.[].index')
    for space in $spaces; do
        yabai -m config --space "$space" layout float
        log "Set space $space to float layout"
    done

    # Maximize all resizable, non-minimized, non-hidden windows
    local windows=$(yabai -m query --windows | jq -r '.[] | select(."is-minimized" == false and ."is-hidden" == false and ."can-resize" == true) | .id')

    local count=0
    for wid in $windows; do
        local app=$(yabai -m query --windows --window "$wid" 2>/dev/null | jq -r '.app // "unknown"')
        if yabai -m window "$wid" --grid 1:1:0:0:1:1 2>/dev/null; then
            log "Maximized window $wid ($app)"
            ((count++))
        else
            log "Failed to maximize window $wid ($app)"
        fi
    done

    log "Built-in mode activated ($count windows maximized)"
}

# Switch to BSP layout (for external display)
switch_to_external_mode() {
    log "Switching to external mode (BSP)..."

    sleep 2  # Let macOS settle after display change

    # Set all spaces to BSP layout
    local spaces=$(yabai -m query --spaces | jq -r '.[].index')
    for space in $spaces; do
        yabai -m config --space "$space" layout bsp
        log "Set space $space to bsp layout"
    done

    # Balance all BSP spaces
    sleep 0.5
    yabai -m space --balance 2>/dev/null || true

    log "External mode activated (BSP layout applied)"
}

# Main entry point
main() {
    local action="${1:-detect}"

    log "Display manager called with action: $action (displays: $(get_display_count))"

    case "$action" in
        "removed"|"display_removed")
            switch_to_builtin_mode
            ;;
        "added"|"display_added")
            switch_to_external_mode
            ;;
        "detect")
            if is_builtin_only; then
                log "Detected built-in only mode"
                switch_to_builtin_mode
            else
                log "Detected external display mode"
                switch_to_external_mode
            fi
            ;;
        "status")
            echo "Display count: $(get_display_count)"
            echo "Mode: $(is_builtin_only && echo 'built-in' || echo 'external')"
            ;;
        *)
            echo "Usage: $0 [removed|added|detect|status]"
            exit 1
            ;;
    esac
}

main "$@"
