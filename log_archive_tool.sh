#!/bin/bash
# log-archive-Tool
# Usage: ./log_archive <log-directory>

set -euo pipefail

# Configuration
SCRIPT_NAME="$(basename "$0")"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DEFAULT_ARCHIVE_DIR="$HOME/log-archives"
LOG_FILE="$DEFAULT_ARCHIVE_DIR/archive.log"

# Initialize variables
LOG_DIR=""
ARCHIVE_DIR="$DEFAULT_ARCHIVE_DIR"
VERBOSE=false

show_help() {
    cat << EOF
Log Archive Tool

Usage: $SCRIPT_NAME <log-directory>

Arguments:
    <log-directory>   Directory containing logs to archive

Options:
    -h, --help        Show this help message
    -v, --verbose     Enable verbose output

Examples:
    $SCRIPT_NAME /var/log
    $SCRIPT_NAME /var/log --verbose
EOF
}   

log_operation() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Create log directory if it doesn't exist
    mkdir -p "$(dirname "$LOG_FILE")"

    echo "[$timestamp] $message" >> "$LOG_FILE"

    if [[ "$VERBOSE" == true ]]; then
        echo "LOG: $message"
    fi     
}   

error_exit() {
    local message="$1"
    echo "Error: $message" >&2
    log_operation "ERROR: $message"
    exit 1      
}

validate_directories() {
    if [[ ! -d "$LOG_DIR" ]]; then
        error_exit "Log directory does not exist: $LOG_DIR"
    fi

    if [[ ! -r "$LOG_DIR" ]]; then
        error_exit "Log directory is not readable: $LOG_DIR"
    fi

    if [[ -z "$(ls -A "$LOG_DIR" 2>/dev/null)" ]]; then
        error_exit "Log directory is empty: $LOG_DIR"
    fi

    log_operation "Validated log directory: $LOG_DIR"
}

parse_arguments() {
    if [[ $# -eq 0 ]]; then
        show_help
        exit 1    
    fi

    while [[ $# -gt 0 ]]; do 
        case "$1" in 
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -*)
                error_exit "Unknown option: $1"
                ;;
            *)
                if [[ -z "$LOG_DIR" ]]; then
                    LOG_DIR="$1"
                else
                    error_exit "Multiple log directories specified: $LOG_DIR and $1"
                fi
                shift
                ;;  
        esac
    done

    if [[ -z "$LOG_DIR" ]]; then
        error_exit "No log directory specified"
    fi    
}

create_archive() {
    local source_dir="$1"
    local archive_name="logs_archive_$TIMESTAMP.tar.gz"
    local archive_path="$ARCHIVE_DIR/$archive_name"

    if ! mkdir -p "$ARCHIVE_DIR"; then
        error_exit "Failed to create archive directory: $ARCHIVE_DIR"
    fi  

    echo "Creating archive from: $source_dir"
    echo "Archive location: $archive_path"

    if [[ "$VERBOSE" == true ]]; then
        echo "Running: tar -czf '$archive_path' -C '$(dirname "$source_dir")' '$(basename "$source_dir")'"
        tar -czvf "$archive_path" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"
    else
        tar -czf "$archive_path" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"
    fi 

    if [[ $? -eq 0 && -f "$archive_path" ]]; then
        local archive_size=$(du -h "$archive_path" | cut -f1)
        echo "Archive created successfully: $archive_path ($archive_size)"
        
        log_operation "SUCCESS: Archived $source_dir to $archive_path ($archive_size)"
    else
        error_exit "Failed to create archive from $source_dir"
    fi
}   

main() {
    echo "=== Log Archive Tool ==="
    echo "Started at: $(date)"
    echo
    
    parse_arguments "$@"
    validate_directories
    create_archive "$LOG_DIR"
    
    echo
    echo "Log archive completed successfully."
    echo "Log file: $LOG_FILE"
    echo "Archive directory: $ARCHIVE_DIR"
    echo "End time: $(date)"
    
    log_operation "Log archive completed successfully"
}

trap 'error_exit "Script interrupted by user"' SIGINT SIGTERM
main "$@"