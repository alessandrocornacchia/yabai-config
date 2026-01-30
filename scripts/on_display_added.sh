#!/usr/bin/env bash
#
# Handler for display_added event
# Called by yabai when an external display is connected
#

SCRIPT_DIR="$(dirname "$0")"
"$SCRIPT_DIR/display_manager.sh" added
