# This script contains helper functions that provide various utilities to the application.

# Sets the terminal title to the provided argument.
# Inputs: 
#   $1 - The title string to be set for the terminal.
# Usage: 
#   set_terminal_title "My Application"
set_terminal_title() {
    local title=$1

    # Setting the terminal title
    echo -ne "\\033]0;${title}\\007"

    # Consider adding error handling if necessary
}
# Confirmation Prompt
confirm_action() {
    local prompt="${1:-$CONFIRM_PROMPT_DEFAULT}"
    read -r -p "$prompt [y/N]: " response
    [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
}

# Input Prompt
input_prompt() {
    local prompt=$1
    read -r -p "$prompt: " input
    echo "$input"
}

# Wait for Key Press
wait_for_keypress() {
    read -r -n1 -p "Press any key to continue..."
    echo
}

# Countdown Timer
countdown_timer() {
    local seconds="${1:-$COUNTDOWN_DURATION}"
    echo "Waiting for ${seconds} seconds..."
    while [ $seconds -gt 0 ]; do
        echo -ne "$seconds\033[0K\r"
        sleep 1
        : $((seconds--))
    done
    echo
}
# Create a Backup of a File or Directory
# Backup Function
backup() {
    local source=$1
    local backup_path="${2:-$DEFAULT_BACKUP_PATH}"
    cp -r "$source" "$backup_path"
    echo "Backup of '$source' created at '$backup_path'"
}

# Check for Command Existence
command_exists() {
    local cmd=$1
    type "$cmd" &> /dev/null
}

# Run Command with Timeout
run_with_timeout() {
    local timeout_duration="${1:-$DEFAULT_COMMAND_TIMEOUT}"
    shift
    timeout "$timeout_duration" "$@"
}

# Generate Random String
generate_random_string() {
    local length="${1:-$RANDOM_STRING_LENGTH}"
    tr -dc 'a-zA-Z0-9' </dev/urandom | head -c "$length"
    echo
}

# Get Current Network IP
get_network_ip() {
    ip -4 addr show "$DEFAULT_NETWORK_INTERFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
}

# Display Disk Usage
show_disk_usage() {
    df -h | grep -ve 'tmpfs\|udev'
}

# Create a Directory if Not Exists
ensure_directory() {
    local dir=${1:-.}
    [ -d "$dir" ] || mkdir -p "$dir"
}

# Download a File
download_file() {
    local url=$1
    local dest="${2:-./}"
    wget -P "$dest" "$url"
}

# Extract File
extract() {
    local file=$1
    case "$file" in
        *.tar.bz2) tar xjf "$file" ;;
        *.tar.gz)  tar xzf "$file" ;;
        *.bz2)     bunzip2 "$file" ;;
        *.rar)     unrar e "$file" ;;
        *.gz)      gunzip "$file" ;;
        *.tar)     tar xf "$file" ;;
        *.tbz2)    tar xjf "$file" ;;
        *.tgz)     tar xzf "$file" ;;
        *.zip)     unzip "$file" ;;
        *.Z)       uncompress "$file" ;;
        *.7z)      7z x "$file" ;;
        *)         echo "'$file' cannot be extracted via extract()" ;;
    esac
}

# Monitor a File for Changes
monitor_file() {
    local file=$1
    echo "Monitoring $file for changes..."
    tail -f "$file"
}

# Replace Text in File
replace_in_file() {
    local file=$1
    local search=$2
    local replace=$3
    sed -i "s/$search/$replace/g" "$file"
}

# List Open Ports
list_open_ports() {
    netstat -tuln
}
# Advanced Network Information
get_advanced_network_info() {
    ifconfig $DEFAULT_NETWORK_INTERFACE
}

# CPU Usage Information
show_cpu_usage() {
    mpstat
}

# Memory Usage Information
show_memory_usage() {
    free -m
}

# List Running Processes
list_running_processes() {
    ps aux
}

# Kill a Process by Name
kill_process() {
    local process_name=$1
    pkill "$process_name"
}

# Encrypt a File
encrypt_file() {
    local file=$1
    local password=${2:-$DEFAULT_ENCRYPTION_PASSWORD}
    openssl enc -aes-256-cbc -salt -in "$file" -out "${file}.enc" -k "$password"
}

# Decrypt a File
decrypt_file() {
    local file=$1
    local password=${2:-$DEFAULT_ENCRYPTION_PASSWORD}
    openssl enc -d -aes-256-cbc -in "$file" -out "${file%.enc}" -k "$password"
}
# Create a ZIP Archive
create_zip() {
    local source_dir=$1
    local zipfile="${2:-$ZIP_DIRECTORY/$(basename "$source_dir").zip}"

    mkdir -p "$ZIP_DIRECTORY"  # Ensure the ZIP directory exists
    zip -r "$zipfile" "$source_dir"   # Create the ZIP archive
    echo "Created ZIP: $zipfile"
}

# Extract a ZIP Archive
extract_zip() {
    local zipfile=$1
    local target_dir="$EXTRACTION_DIRECTORY"

    mkdir -p "$target_dir"  # Ensure the extraction directory exists
    unzip "$zipfile" -d "$target_dir"   # Extract the ZIP archive
    echo "Extracted to: $target_dir"
}
# Check Internet Connectivity
check_internet() {
    ping -c 4 "$INTERNET_CHECK_HOST"
}
# Get Current User
get_current_user() {
    whoami
}

# Change File Permissions
change_file_permissions() {
    local file=$1
    local permissions=${2:-$DEFAULT_FILE_PERMISSIONS}
    chmod "$permissions" "$file"
}

# Create a Symbolic Link
create_symlink() {
    local target=$1
    local link_name=$2
    ln -s "$target" "$link_name"
}

# Display System Information
show_system_info() {
    uname -a
}

# List Files in a Directory
list_files() {
    local dir=${1:-.}
    ls -l "$dir"
}

# Calculate Directory Size
calculate_directory_size() {
    local dir=${1:-.}
    du -sh "$dir"
}

# Search for a File
search_file() {
    local filename=$1
    find / -name "$filename" 2>/dev/null
}

# Display Current Path
show_current_path() {
    pwd
}

# Restart Network Service
restart_network() {
    systemctl restart networking
}
# Function to check if a device is connected using ADB
check_adb_device() {
    adb devices | grep -q 'device$'
}
# Function to Clone Instantnoodle Build Tools
download_instantnoodle_build_tools() {
    local git_repo="https://github.com/IllSaft/oneplus-instantnoodle.git"
    local destination_dir="$BASE_DIR/instantnoodle-extras/build-tools"

    # Create the destination directory if it doesn't exist
    mkdir -p "$destination_dir"

    log_bold_nodate_info "Download Instantnoodle Build Tools? (y/n)"
    read -r -p ": " user_choice

    if [[ $user_choice =~ ^[yY]$ ]]; then
        log_nodate_info "Cloning Instantnoodle Build Tools..."
        git clone "$git_repo" "$destination_dir" && \
        log_nodate_success "Instantnoodle Build Tools downloaded successfully."
    else
        log_nodate_info "Skipping download of Instantnoodle Build Tools."
    fi
}

run_chroot_log_data_function() {
    local script_path="$BASE_DIR/instantnoodle-extras/chroot/chroot-log-data.sh"
    local target_path="/"
    local LOG_FILE="$LOG_FILE"

    log_action() {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
    }

    # Check environment and push script
    if ! verify_environment; then
        log_bold_nodate_error "Environment verification failed."
        return 1
    fi

    if ! adb push "$script_path" "$target_path"; then
        log_bold_nodate_error "Failed to push script to the device."
        return 1
    fi

    log_nodate_success "Initiating chroot environment..."

    # Use expect with a log file
    /usr/bin/expect -c "
        set timeout -1
        spawn adb shell
        log_file \"$LOG_FILE\";  # Log all output to the file
        expect \"#\"
        send \"chmod +x /chroot-log-data.sh\r\"
        expect \"#\"
        send \"./chroot-log-data.sh\r\"
        expect \"#\"
        interact
    "
    # Post-process the log file to remove ANSI codes
    sed -i -r 's/\x1b\[[0-9;]*[mK]//g' "$LOG_FILE"
    log_bold_nodate_success "Successfully exited chroot environment."
}

# Function to Run 'chroot-log-data-dd.sh' Script
run_chroot_log_data_dd_function() {
    local script_path="$BASE_DIR/instantnoodle-extras/chroot/chroot-log-data-dd.sh"
    local target_path="/"

    if [ ! -f "$script_path" ] || ! adb push "$script_path" "$target_path"; then
        log_bold_error "Script file missing or failed to push."
        return 1
    fi

    expect -c "
        set timeout -1
        spawn adb shell
        expect \"#\"
        send \"chmod +x /chroot-log-data-dd.sh\r\"
        send \"./chroot-log-data-dd.sh\r\"
        interact
    "
}

# Function to Run 'chroot-log-system.sh' Script
run_chroot_log_system_function() {
    local script_path="$BASE_DIR/instantnoodle-extras/chroot/chroot-log-system.sh"
    local target_path="/"

    if [ ! -f "$script_path" ] || ! adb push "$script_path" "$target_path"; then
        log_bold_error "Script file missing or failed to push."
        return 1
    fi

# Expect script with logging
expect -c "
    log_expect \"Expect session started...\"
    set timeout -1
    spawn adb shell
    expect \"#\"
    log_expect \"Connected to adb shell...\"
    send \"chmod +x /chroot-log-system.sh\r\"
    expect \"#\"
    log_expect \"Executed 'chmod' command...\"
    send \"./chroot-log-system.sh\r\"
    expect \"#\"
    log_expect \"Executed './chroot-log-system.sh' command...\"
    interact
    " >> "$LOG_FILE" 2>&1
}

# Function to Select and Run a Specific Script
select_and_run_script() {
    # Check for device in recovery mode
    until adb get-state 2>/dev/null | grep -q 'recovery'; do
        log_nodate_info "Waiting for device in recovery mode..."
        sleep 12
    done
    log_bold_success "Device Found. Continuing with script execution..."
    log_nodate_info_header "Please select a script to execute:"
    log_data_chroot_info "Chroot with Ubuntu.img in Data Partition"
    log_data_chroot_dd_info "Chroot with Ubuntu.img DD'd in Data Part"
    log_system_chroot_info "Chroot with Ubuntu.img Flashed in System"
    read -p "Enter your choice (1/2/3): " script_choice

    case $script_choice in
        1) run_chroot_log_data_function ;;
        2) run_chroot_log_data_dd_function ;;
        3) run_chroot_log_system_function ;;
        *) log_bold_nodate_error "Invalid choice. Skipping this step." ;;
    esac
}

# Checks and Unlocks the Bootloader
unlock_bootloader() {
    if ! check_adb_device; then
        echo "Device not connected. Please connect and try again."
        return
    fi
    adb reboot bootloader
    until fastboot devices | grep -q 'fastboot'; do sleep 1; done
    if fastboot oem device-info | grep -q 'Device unlocked: true'; then
        echo "Bootloader already unlocked."
        return
    fi
    fastboot flash cust-unlock unlock_token.bin
    fastboot oem unlock
    echo "Bootloader unlocked. Please reboot your device."
}
# Pushes and Executes a Script on Device via ADB
push_and_run_script() {
    local script="$1"
    if ! check_adb_device; then
        echo "Device not connected. Please connect and try again."
        exit 1
    fi

    echo "1) Recovery  2) Fastboot"
    read -r -p "Reboot to (1/2): " choice
    [[ "$choice" == "1" ]] && adb reboot recovery || { echo "Invalid choice"; exit 1; }
    sleep 10  # Wait for reboot

    adb push "scripts/$script" "/data/local/tmp/"
    [[ $? -ne 0 ]] && { echo "Failed to push $script"; exit 1; }

    adb shell "chmod +x /data/local/tmp/$script && /data/local/tmp/$script"
}

# Downloads and Runs 'instantnoodle-extras' Script
download_and_run_extras() {
    log_nodate_info "Executing 'instantnoodle-extras'..."
    source "$BASE_DIR/scripts/instantnoodle-extras.sh"
    get_instantnoodle_extras
}

# Flashes Selected Recovery to Device
flash_recovery() {
    log_bold_nodate_confirmation "Select Recovery: 1) Orange Fox  2) TWRP  3) LineageOS or press Enter to continue" 
    read -r -p "Choice (1/2/3): " choice
    case $choice in
        1) img="OrangeFox_R11.1-InstantNoodle-Recovery.img" ;;
        2) img="TWRP-InstantNoodle-Recovery.img" ;;
        3) img="LineageOS-18.1-Recovery.img" ;;
        *) log_error "Skipping Recovery Flash."; return ;;
    esac
    fastboot flash recovery "instantnoodle-extras/recovery/$img"
    log_bold_success "Flashed $img"
}

# Reboots Device and Flashes Extras
reboot_and_flash() {
    local mode=$(adb get-state 2>/dev/null || fastboot devices | grep -o 'fastboot')

    # Check if device mode is detected, otherwise log a note
    if [ -z "$mode" ]; then
        log_bold_nodate_note "Device mode: Not Detected"
        log_bold_nodate_error "Device mode not detected"
        return
    else
        log_bold_nodate_note "Device mode: $mode"
    fi

    case $mode in
        "device"|"recovery")
            log_bold_nodate_confirmation "Reboot to Fastboot? (y/n)"
            read -r -p ": " choice
            if [[ $choice =~ ^[yY]$ ]]; then
                adb reboot bootloader
                log_nodate_important "Checking for device in fastboot mode..."
                until fastboot devices | grep -q 'fastboot'; do
                    log_nodate_info "Waiting for device in fastboot mode..."
                    sleep 2.5
                done
                log_nodate_success "Device Found. Continuing with flashing..."
                [ -d "$BASE_DIR/instantnoodle-extras" ] || download_and_run_extras
                flash_recovery
                prompt_reboot_recovery
            else
                log_nodate_info "Exiting script."
                return
            fi
            ;;
        "fastboot")
            log_nodate_success "Device Found. Continuing with flashing..."
            [ -d "$BASE_DIR/instantnoodle-extras" ] || download_and_run_extras
            flash_recovery
            prompt_reboot_recovery
            ;;
        *)
            log_error "Device mode not detected"
            return
            ;;
    esac
}

# Helper Function to Prompt for Reboot to Recovery
prompt_reboot_recovery() {
    log_bold_nodate_confirmation "Reboot to recovery? (y/n, press Enter to continue.):"
    read -r -p ": " choice

    case $choice in
        [yY])
            log_nodate_info "Rebooting into recovery..."
            fastboot reboot recovery
            select_and_run_script
            ;;
        [nN])
            log_nodate_info "Not rebooting. Continuing with script..."
            ;;
        *)
            log_nodate_info "No input detected. Continuing with the rest of the script..."
            # Insert additional script execution or function calls here if needed
            ;;
    esac
}

# Continue with the rest of your script...
# Function to detect device state and execute corresponding actions
detect_device_state() {
    local mode=$(adb get-state 2>/dev/null || fastboot devices | grep -o 'fastboot')

    if [ -z "$mode" ]; then
        log_bold_nodate_error "No device detected."
        return
    else
        log_bold_nodate_note "Device mode: $mode"
    fi

    case $mode in
        "device")
            handle_device_mode
            ;;
        "recovery")
            handle_recovery_mode
            ;;
        "fastboot")
            handle_fastboot_mode
            ;;
        *)
            log_bold_nodate_error "Unrecognized device mode: $mode"
            return
            ;;
    esac
}

# Function to handle actions when the device is in normal mode
handle_device_mode() {
    log_nodate_info "Device is in normal mode."
    # Add custom actions for normal mode here
}

# Adjusted function to handle actions when the device is in recovery mode
handle_recovery_mode() {
    wait_for_recovery
    execute_recovery_mode_functions
}

# Function to handle actions when the device is in fastboot mode
handle_fastboot_mode() {
    log_nodate_info "Device is in fastboot mode."
    wait_for_fastboot
    execute_fastboot_mode_functions
}
wait_for_fastboot() {
    until fastboot devices | grep -q 'fastboot'; do
        log_nodate_info "Waiting for device in fastboot mode..."
        sleep 2.5
    done
    log_nodate_success "Device Found. Continuing with actions..."
}

execute_fastboot_mode_functions() {
    # Add custom functions or actions for fastboot mode here
    log_nodate_info "Executing custom actions for fastboot mode..."
    log_nodate_success "Flashing Recovery..."
    flash_recovery
    log_bold_nodate_warning "Rebooting to recovery..."
    fastboot reboot recovery
}
# Function to wait for the device to enter recovery mode
wait_for_recovery() {
    until adb get-state 2>/dev/null | grep -q 'recovery'; do
        log_nodate_info "Waiting for device in recovery mode..."
        sleep 2.5
    done
    log_nodate_success "Device in recovery mode. Continuing with actions..."
}

# Function to execute custom actions for recovery mode
execute_recovery_mode_functions() {
    # Add custom functions or actions for recovery mode here
    log_nodate_info "Executing custom actions for recovery mode..."
    select_and_run_script
}




# Placeholder for additional utility functions
# ...
