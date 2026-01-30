#!/usr/bin/env bash
#
# Handler for display_removed event
# Called by yabai when an external display is disconnected
#

SCRIPT_DIR="$(dirname "$0")"
"$SCRIPT_DIR/display_manager.sh" removed
