#!/bin/bash

# Base Directory of the Script
BASE_DIR="$(dirname "$0")"
export BASE_DIR

# Source Configuration and Libraries
source "$BASE_DIR/config/settings.cfg"
source "$BASE_DIR/config/palette.sh"
source "$BASE_DIR/lib/logger.sh"

# Initialize logger
if [[ -z $LOGGER_INITIALIZED ]]; then
    initiate_logger
    export LOGGER_INITIALIZED=true
fi

# Additional library sourcing
source "$BASE_DIR/lib/environment.sh"
source "$BASE_DIR/lib/error_handling.sh"
source "$BASE_DIR/lib/helpers.sh"
source "$BASE_DIR/scripts/instantnoodle-extras.sh"

# Set Terminal Title
set_terminal_title "$APPLICATION_TITLE"

main() {
    log_bold_nodate_info_header "[ Instantnoodle Ubuntu Touch Tools ]"
    verify_environment

    # Call the instantnoodle-extras script
    #source "$BASE_DIR/scripts/instantnoodle-extras.sh"
    download_instantnoodle_extras
    detect_device_state
    log_nodate_success "Main script execution completed"
}

trap 'graceful_exit' ERR
main
