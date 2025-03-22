#!/bin/bash
#
# USB Duplicator for DJ Tools
# This script efficiently duplicates all content from one USB drive to another,
# preserving the file structure required for Rekordbox DJ software.

set -e  # Exit on error

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display help
show_help() {
    echo -e "${BLUE}USB Duplicator for DJ Tools${NC}"
    echo
    echo "Usage: $0 [source] [destination]"
    echo
    echo "Options:"
    echo "  source        Path to source USB drive"
    echo "  destination   Path to destination USB drive"
    echo
    echo "If source or destination is not specified, the script will list available drives"
    echo "and prompt you to choose."
    echo
}

# Function to format sizes in human-readable format
format_size() {
    local size=$1
    if [[ $size -ge 1073741824 ]]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $size/1073741824}") GB"
    elif [[ $size -ge 1048576 ]]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $size/1048576}") MB"
    elif [[ $size -ge 1024 ]]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $size/1024}") KB"
    else
        echo "$size bytes"
    fi
}

# Function to get mounted volumes (macOS specific)
get_mount_points() {
    local volumes=()
    if [[ "$(uname)" == "Darwin" ]]; then  # macOS
        # Get list of mounted volumes excluding system volumes
        for vol in /Volumes/*; do
            if [[ -d "$vol" && "$vol" != "/Volumes/Macintosh HD" ]]; then
                volumes+=("$vol")
            fi
        done
    else
        echo -e "${YELLOW}Currently only macOS is fully supported.${NC}"
        echo "For other platforms, please specify source and destination paths manually."
    fi
    echo "${volumes[@]}"
}

# Function to get the available space on a drive
get_free_space() {
    local path=$1
    if [[ "$(uname)" == "Darwin" ]]; then  # macOS
        df -k "$path" | tail -1 | awk '{print $4 * 1024}'
    else
        df -B1 "$path" | tail -1 | awk '{print $4}'
    fi
}

# Function to get the total space of a directory
get_total_size() {
    local path=$1
    if [[ "$(uname)" == "Darwin" ]]; then  # macOS
        du -s "$path" | awk '{print $1 * 1024}'
    else
        du -sb "$path" | awk '{print $1}'
    fi
}

# Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Process arguments
SOURCE="$1"
DEST="$2"

# Get list of mounted volumes
MOUNT_POINTS=($(get_mount_points))

# Prompt for source if not provided
if [[ -z "$SOURCE" ]]; then
    echo -e "\n${BLUE}Available drives:${NC}"
    for i in "${!MOUNT_POINTS[@]}"; do
        size=$(get_total_size "${MOUNT_POINTS[$i]}")
        formatted_size=$(format_size $size)
        echo "  $((i+1)). ${MOUNT_POINTS[$i]} (${formatted_size})"
    done
    
    echo
    read -p "Enter source drive number: " SOURCE_NUM
    if [[ "$SOURCE_NUM" =~ ^[0-9]+$ ]] && [ "$SOURCE_NUM" -ge 1 ] && [ "$SOURCE_NUM" -le "${#MOUNT_POINTS[@]}" ]; then
        SOURCE="${MOUNT_POINTS[$((SOURCE_NUM-1))]}"
    else
        echo -e "${RED}Invalid selection.${NC}"
        exit 1
    fi
fi

# Verify source exists
if [ ! -d "$SOURCE" ]; then
    echo -e "${RED}Error: Source path $SOURCE does not exist!${NC}"
    exit 1
fi

# Prompt for destination if not provided
if [[ -z "$DEST" ]]; then
    echo -e "\n${BLUE}Selected source:${NC} $SOURCE"
    echo -e "\n${BLUE}Available drives:${NC}"
    for i in "${!MOUNT_POINTS[@]}"; do
        # Skip showing the source drive
        if [ "${MOUNT_POINTS[$i]}" == "$SOURCE" ]; then
            continue
        fi
        size=$(get_total_size "${MOUNT_POINTS[$i]}")
        formatted_size=$(format_size $size)
        echo "  $((i+1)). ${MOUNT_POINTS[$i]} (${formatted_size})"
    done
    
    echo
    read -p "Enter destination drive number: " DEST_NUM
    if [[ "$DEST_NUM" =~ ^[0-9]+$ ]] && [ "$DEST_NUM" -ge 1 ] && [ "$DEST_NUM" -le "${#MOUNT_POINTS[@]}" ]; then
        DEST="${MOUNT_POINTS[$((DEST_NUM-1))]}"
        if [ "$DEST" == "$SOURCE" ]; then
            echo -e "${RED}Error: Destination cannot be the same as source!${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Invalid selection.${NC}"
        exit 1
    fi
fi

# Verify destination exists
if [ ! -d "$DEST" ]; then
    echo -e "${RED}Error: Destination path $DEST does not exist!${NC}"
    exit 1
fi

# Calculate space required and available
SOURCE_SIZE=$(get_total_size "$SOURCE")
DEST_FREE=$(get_free_space "$DEST")

echo -e "\n${BLUE}Source:${NC} $SOURCE"
echo -e "${BLUE}Size:${NC} $(format_size $SOURCE_SIZE)"
echo -e "\n${BLUE}Destination:${NC} $DEST"
echo -e "${BLUE}Free space:${NC} $(format_size $DEST_FREE)"

# Check if there's enough space
if [ "$SOURCE_SIZE" -gt "$DEST_FREE" ]; then
    echo -e "\n${RED}WARNING: Not enough free space on destination!${NC}"
    echo -e "Need $(format_size $SOURCE_SIZE), have $(format_size $DEST_FREE)"
    read -p "Continue anyway? (y/n): " CONTINUE
    if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
        echo "Aborting."
        exit 1
    fi
fi

# Start copying
echo -e "\n${GREEN}Starting copy from $SOURCE to $DEST...${NC}"
START_TIME=$(date +%s)

# Use rsync for efficient copying with progress - add dot files with --include='.*'
rsync -ah --include='.*' --info=progress2 --stats "$SOURCE/" "$DEST/"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
MINUTES=$((ELAPSED / 60))
SECONDS=$((ELAPSED % 60))

echo -e "\n${GREEN}Duplication completed in ${MINUTES}m ${SECONDS}s!${NC}"

# Verify the copy (optional)
echo -e "\n${BLUE}Verifying copy...${NC}"
VERIFY_START=$(date +%s)

# Use rsync's dry-run mode to check for differences - include dot files here too
DIFFERENCES=$(rsync -avhcn --include='.*' --stats "$SOURCE/" "$DEST/" | grep "^Number of regular files transferred" | awk '{print $6}')

if [ "$DIFFERENCES" == "0" ]; then
    VERIFY_END=$(date +%s)
    VERIFY_ELAPSED=$((VERIFY_END - VERIFY_START))
    VERIFY_MINUTES=$((VERIFY_ELAPSED / 60))
    VERIFY_SECONDS=$((VERIFY_ELAPSED % 60))
    echo -e "${GREEN}Verification successful in ${VERIFY_MINUTES}m ${VERIFY_SECONDS}s!${NC}"
    echo -e "${GREEN}All files copied correctly.${NC}"
else
    echo -e "${RED}Verification failed. Found differences between source and destination.${NC}"
    echo "You might want to run the copy again."
fi

TOTAL_TIME=$(($(date +%s) - START_TIME))
TOTAL_MINUTES=$((TOTAL_TIME / 60))
TOTAL_SECONDS=$((TOTAL_TIME % 60))

echo -e "\n${GREEN}Total operation time: ${TOTAL_MINUTES}m ${TOTAL_SECONDS}s${NC}"
echo -e "${BLUE}Duplication complete!${NC}" 