# debugger.sh

# Get the absolute directory of debugger.sh
DEBUGGER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load necessary configurations and libraries
source "$DEBUGGER_DIR/../config/settings.cfg"
source "$DEBUGGER_DIR/logger.sh"

# Function to log debug messages, activated by VERBOSE_MODE
log_debug() {
    local message=$1

    # Check VERBOSE_MODE and log if it's enabled
    if [ "$VERBOSE_MODE" = true ]; then
        log_event "DEBUG" "$message"
    fi
}

# Additional debugging functions can be added here
