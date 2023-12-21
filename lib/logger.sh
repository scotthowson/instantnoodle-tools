# Logger.sh - Provides enhanced logging functionalities for Bash scripts

# --- Initialization Functions ---
# Initializes the logger by clearing the log file
initiate_logger() {
    if [[ -z $LOGGER_INITIALIZED ]]; then
        > "$LOG_FILE"  # Clear the log file only if not already initialized
        log_nodate_success "Logger Initialized."
        export LOGGER_INITIALIZED=true
    fi
}
# --- Core Logging Function ---
log_event() {
    local original_mood=$1
    local narrative=$2
    local mood=$original_mood
    local is_bold=false
    local is_nodate=false
    local is_custom=false

    # Extracting flags from the mood
    if [[ $mood == "BOLD_"* ]]; then
        is_bold=true
        mood="${mood#BOLD_}"
    fi
    if [[ $mood == "NODATE_"* ]]; then
        is_nodate=true
        mood="${mood#NODATE_}"
    fi
    if [[ $mood == "CUSTOM_"* ]]; then
        is_custom=true
        mood="${mood#CUSTOM_}"
    fi

    # Apply color and possibly bold style based on mood
    local style="${COLOR_PALETTE[$mood]}"
    [[ "$is_bold" == true ]] && style="\033[1m${style}"

    # Constructing the prefix section for console and log file
    local console_prefix=""
    local logfile_prefix="[$(date '+%b/%d/%Y — %-l:%M %p')]"
    local separator=""
    if [[ "$ENABLE_LOG_DATE" == true && "$is_nodate" == false ]]; then
        console_prefix="$logfile_prefix"
    fi

    # Handling custom log prefix
    if [[ "$ENABLE_CUSTOM_LOG_PREFIX" == true && "$is_custom" == true ]]; then
        case $mood in
            "DATA_CHROOT") console_prefix="[$DATA_CHROOT_LOG_PREFIX]$console_prefix" ;;
            "DATA_CHROOT_DD") console_prefix="[$DATA_CHROOT_DD_LOG_PREFIX]$console_prefix" ;;
            "SYSTEM_CHROOT") console_prefix="[$SYSTEM_CHROOT_LOG_PREFIX]$console_prefix" ;;
            *) console_prefix="[$CUSTOM_LOG_PREFIX]$console_prefix" ;;
        esac
    elif [[ "$ENABLE_LOG_MOOD" == true && ! " BLACK RED GREEN YELLOW BLUE PURPLE CYAN WHITE " =~ $mood ]]; then
        console_prefix="${console_prefix}[$mood]"
    fi

    # Handle INFO_HEADER based on settings
    if [[ "$mood" == "INFO_HEADER" ]]; then
        if [[ "$ENABLE_INFO_HEADER" == true ]]; then
            if [[ "$USE_CUSTOM_INFO_HEADER" == true ]]; then
                console_prefix="${CUSTOM_INFO_HEADER_TEXT}"  # Custom header text only
            else
                console_prefix="${console_prefix}[INFO_HEADER]"  # Default [INFO_HEADER] tag
            fi
        fi
    fi

    # Add separator if there is a prefix section
    [[ -n "$console_prefix" ]] && separator=" - "

    # Constructing and displaying the log message
    local console_message="${style}${console_prefix}${separator}${narrative}${COLOR_PALETTE[RESET]}"
    local logfile_message="${logfile_prefix}${separator}${narrative}"
    echo -e "$console_message"
    echo "$logfile_message" >> "$LOG_FILE"
}

# --- Standard Log Level Functions ---
log_info() { log_event "INFO" "$1"; }
log_bold_nodate_success() { log_event "SUCCESS" "$1"; }
log_warning() { log_event "WARNING" "$1"; }
log_error() { log_event "ERROR" "$1"; }
log_info_header() { log_event "INFO_HEADER" "$1"; }
log_important() { log_event "IMPORTANT" "$1"; }
log_note() { log_event "NOTE" "$1"; }
log_tip() { log_event "TIP" "$1"; }
log_debug() { log_event "DEBUG" "$1"; }
log_confirmation() { log_event "CONFIRMATION" "$1"; }
log_alert() { log_event "ALERT" "$1"; }
log_caution() { log_event "CAUTION" "$1"; }
log_focus() { log_event "FOCUS" "$1"; }
log_highlight() { log_event "HIGHLIGHT" "$1"; }
log_neutral() { log_event "NEUTRAL" "$1"; }
log_prompt() { log_event "PROMPT" "$1"; }
log_status() { log_event "STATUS" "$1"; }
log_verbose() { log_event "VERBOSE" "$1"; }
log_question() { log_event "QUESTION" "$1"; }

# --- Bold Log Level Variants ---
log_bold_info() { log_event "BOLD_INFO" "$1"; }
log_bold_success() { log_event "BOLD_SUCCESS" "$1"; }
log_bold_warning() { log_event "BOLD_WARNING" "$1"; }
log_bold_error() { log_event "BOLD_ERROR" "$1"; }
log_bold_important() { log_event "BOLD_IMPORTANT" "$1"; }
log_bold_note() { log_event "BOLD_NOTE" "$1"; }
log_bold_tip() { log_event "BOLD_TIP" "$1"; }
log_bold_debug() { log_event "BOLD_DEBUG" "$1"; }
log_bold_confirmation() { log_event "BOLD_CONFIRMATION" "$1"; }
log_bold_alert() { log_event "BOLD_ALERT" "$1"; }
log_bold_caution() { log_event "BOLD_CAUTION" "$1"; }
log_bold_focus() { log_event "BOLD_FOCUS" "$1"; }
log_bold_highlight() { log_event "BOLD_HIGHLIGHT" "$1"; }
log_bold_neutral() { log_event "BOLD_NEUTRAL" "$1"; }
log_bold_prompt() { log_event "BOLD_PROMPT" "$1"; }
log_bold_status() { log_event "BOLD_STATUS" "$1"; }
log_bold_verbose() { log_event "BOLD_VERBOSE" "$1"; }
log_bold_question() { log_event "BOLD_QUESTION" "$1"; }

# --- No-Date Log Level Variants ---
log_nodate_info() { log_event "NODATE_INFO" "$1"; }
log_nodate_success() { log_event "NODATE_SUCCESS" "$1"; }
log_nodate_warning() { log_event "NODATE_WARNING" "$1"; }
log_nodate_error() { log_event "NODATE_ERROR" "$1"; }
log_nodate_info_header() { log_event "NODATE_INFO_HEADER" "$1"; }
log_nodate_important() { log_event "NODATE_IMPORTANT" "$1"; }
log_nodate_note() { log_event "NODATE_NOTE" "$1"; }
log_nodate_tip() { log_event "NODATE_TIP" "$1"; }
log_nodate_debug() { log_event "NODATE_DEBUG" "$1"; }
log_nodate_confirmation() { log_event "NODATE_CONFIRMATION" "$1"; }
log_nodate_alert() { log_event "NODATE_ALERT" "$1"; }
log_nodate_caution() { log_event "NODATE_CAUTION" "$1"; }
log_nodate_focus() { log_event "NODATE_FOCUS" "$1"; }
log_nodate_highlight() { log_event "NODATE_HIGHLIGHT" "$1"; }
log_nodate_neutral() { log_event "NODATE_NEUTRAL" "$1"; }
log_nodate_prompt() { log_event "NODATE_PROMPT" "$1"; }
log_nodate_status() { log_event "NODATE_STATUS" "$1"; }
log_nodate_verbose() { log_event "NODATE_VERBOSE" "$1"; }
log_nodate_question() { log_event "NODATE_QUESTION" "$1"; }

# --- Bold No-Date Log Level Variants ---
log_bold_nodate_info() { log_event "BOLD_NODATE_INFO" "$1"; }
log_bold_nodate_success() { log_event "BOLD_NODATE_SUCCESS" "$1"; }
log_bold_nodate_warning() { log_event "BOLD_NODATE_WARNING" "$1"; }
log_bold_nodate_error() { log_event "BOLD_NODATE_ERROR" "$1"; }
log_bold_nodate_info_header() { log_event "BOLD_NODATE_INFO_HEADER" "$1"; }
log_bold_nodate_important() { log_event "BOLD_NODATE_IMPORTANT" "$1"; }
log_bold_nodate_note() { log_event "BOLD_NODATE_NOTE" "$1"; }
log_bold_nodate_tip() { log_event "BOLD_NODATE_TIP" "$1"; }
log_bold_nodate_debug() { log_event "BOLD_NODATE_DEBUG" "$1"; }
log_bold_nodate_confirmation() { log_event "BOLD_NODATE_CONFIRMATION" "$1"; }
log_bold_nodate_alert() { log_event "BOLD_NODATE_ALERT" "$1"; }
log_bold_nodate_caution() { log_event "BOLD_NODATE_CAUTION" "$1"; }
log_bold_nodate_focus() { log_event "BOLD_NODATE_FOCUS" "$1"; }
log_bold_nodate_highlight() { log_event "BOLD_NODATE_HIGHLIGHT" "$1"; }
log_bold_nodate_neutral() { log_event "BOLD_NODATE_NEUTRAL" "$1"; }
log_bold_nodate_prompt() { log_event "BOLD_NODATE_PROMPT" "$1"; }
log_bold_nodate_status() { log_event "BOLD_NODATE_STATUS" "$1"; }
log_bold_nodate_verbose() { log_event "BOLD_NODATE_VERBOSE" "$1"; }
log_bold_nodate_question() { log_event "BOLD_NODATE_QUESTION" "$1"; }

# Add other necessary functions and customizations as required


# --- Custom Mood Type Logging Functions ---
log_data_chroot_info() { log_event "BOLD_NODATE_CUSTOM_DATA_CHROOT" "$1"; }
log_data_chroot_dd_info() { log_event "BOLD_NODATE_CUSTOM_DATA_CHROOT_DD" "$1"; }
log_system_chroot_info() { log_event "BOLD_NODATE_CUSTOM_SYSTEM_CHROOT" "$1"; }

# Add other helper functions and customizations as needed