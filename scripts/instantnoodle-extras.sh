#!/bin/bash
download_instantnoodle_extras() {
# Adjust BASE_DIR to point to your project root directory
# Use BASE_DIR from the environment or set it to the script's directory
BASE_DIR="${BASE_DIR:-$(dirname "$0")}"

# Source Configuration and Libraries
source "$BASE_DIR/config/settings.cfg"
source "$BASE_DIR/lib/logger.sh"

log_nodate_info "Starting instantnoodle-extras.sh script..."
# Source Configuration and Libraries
# ANSI color codes
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# Decorative divider
divider() {
    echo -e "${BOLD_CYAN}————————————————————————————————————————————————————————————————————————————————${NC}"
}

# Function to display a colored message
echo_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to download a file using wget or curl and log the output
download_file() {
    local url=$1
    local file=$2
    local option=$3
    local option_url=$4

    if [[ $option == "wget" ]]; then
        if wget -O "$file" "$url" &> /dev/null; then
            log_bold_nodate_success "✅ $file downloaded successfully."
        else
            log_bold_nodate_error "❌ Failed to download $file"
        fi
    elif [[ $option == "curl" ]]; then
        if curl --referer "$option_url" -k -o "$file" "$url" &> /dev/null; then
            log_bold_nodate_success "✅ $file downloaded successfully."
        else
            log_bold_nodate_error "❌ Failed to download $file"
        fi
    fi
}


# Function to clone or update a Git repository
update_git_repo() {
    local repo_url=$1
    local dest=$2
    if [ -d "$dest/.git" ]; then
        log_nodate_info "Checking for updates in $dest..."
        
        # Fetch changes without changing directory
        git -C "$dest" fetch

        if [ $(git -C "$dest" rev-parse HEAD) != $(git -C "$dest" rev-parse @{u}) ]; then
            log_nodate_important "Updates available. Do you want to update? (y/n)"
            read -p "" choice
            if [[ $choice =~ ^[Yy]$ ]]; then
                # Pull updates without changing directory
                git -C "$dest" pull
                log_nodate_success "Repository updated."
            else
                log_nodate_important "Skipping update."
            fi
        else
            log_nodate_important "Repository already up-to-date."
        fi
    else
        log_nodate_highlight "🚀 Cloning repository to $dest..."
        git clone "$repo_url" "$dest"
        log_nodate_success "Repository cloned."
    fi
}

# Function to check and download chroot scripts
check_and_download_chroot_scripts() {
    local chroot_repo="https://github.com/IllSaft/instantnoodle-chroot.git"
    local chroot_path="instantnoodle-extras/chroot"

    log_nodate_info "Checking for Instantnoodle Chroot scripts..."
    if [ ! -d "$chroot_path" ]; then
        update_git_repo "$chroot_repo" "$chroot_path"
    else
        log_bold_nodate_tip "Chroot scripts directory already exists. Checking for updates..."
        update_git_repo "$chroot_repo" "$chroot_path"
    fi
}

# Function to clone Halium repository
clone_halium_repository() {
    local halium_repo="https://github.com/Halium/halium-boot.git"
    local halium_path="instantnoodle-extras/halium-boot"

    log_nodate_info "Checking for Halium repository..."
    update_git_repo "$halium_repo" "$halium_path"
}

# Main function
main() {
    log_nodate_info "🐧 Starting Instantnoodle Extras Download Tool..."
    recovery_path="$BASE_DIR/instantnoodle-extras/recovery"
    mkdir -p "$BASE_DIR/instantnoodle-extras/chroot" "$recovery_path"

    log_nodate_info "Downloading Recovery Images:"
    local files=(
        "OrangeFox_R11.1-InstantNoodle-Recovery.img|https://github.com/Wishmasterflo/android_device_oneplus_kebab/releases/download/V15/OrangeFox-R11.1-Unofficial-OnePlus8T_9R-V15.img|wget"
        "TWRP-InstantNoodle-Recovery.img|https://dl.twrp.me/instantnoodle/twrp-3.7.0_11-0-instantnoodle.img|curl"
        "LineageOS-18.1-Recovery.img|https://github.com/IllSaft/los18.1-recovery/releases/download/0.1/LineageOS-18.1-Recovery.img|wget"
    )

    for entry in "${files[@]}"; do
        IFS='|' read -r file url method <<< "$entry"
        full_path="$recovery_path/$file"
        if [ ! -f "$full_path" ]; then
            download_file "$url" "$full_path" "$method"
        else
            log_bold_nodate_tip "$file already exists."
        fi
    done

    check_and_download_chroot_scripts
    clone_halium_repository

    log_bold_nodate_success "Instantnoodle Extras Download Tool Finished."
}
main
}