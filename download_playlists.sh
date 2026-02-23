#!/bin/bash

# YouTube Playlist Downloader
# Author: https://github.com/Linuxmaster14
# Uses yt-dlp to download playlists organized by channel name

# Configuration
COOKIES_FILE="./cookies.txt"
PLAYLISTS_FILE="./playlists.txt"
VIDEOS_FILE="./videos.txt"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if cookies file exists
if [[ ! -f "$COOKIES_FILE" ]]; then
    echo -e "${RED}Error: Cookies file not found at $COOKIES_FILE${NC}"
    echo "Please provide a valid cookies.txt file"
    exit 1
fi

# Resolve absolute path for cookies file to avoid issues when changing directories
COOKIES_FILE=$(realpath "$COOKIES_FILE")

# Check if at least one input file exists
if [[ ! -f "$PLAYLISTS_FILE" && ! -f "$VIDEOS_FILE" ]]; then
    echo -e "${RED}Error: Neither playlists.txt nor videos.txt found${NC}"
    echo "Please create at least one file with the format:"
    echo "  playlists.txt: ChannelName|PlaylistURL"
    echo "  videos.txt: ChannelName|VideoURL"
    exit 1
fi

download_content() {
    local file=$1
    local content_type=$2
    
    [[ ! -f "$file" ]] && return
    
    while IFS='|' read -r channel_name url || [[ -n "$channel_name" ]]; do
        # Skip empty lines and comments
        [[ -z "$channel_name" || "$channel_name" =~ ^# ]] && continue
        
        # Trim whitespace
        channel_name=$(echo "$channel_name" | xargs)
        url=$(echo "$url" | xargs)
        
        # Skip if URL is empty
        [[ -z "$url" ]] && continue
        
        echo ""
        echo -e "${GREEN}[$channel_name]${NC} $url"
        
        # Create channel directory if it doesn't exist
        mkdir -p "$channel_name"
        
        # Change to channel directory
        cd "$channel_name" || exit 1
        
        # Set output template based on content type
        if [[ "$content_type" == "playlist" ]]; then
            output_template="%(playlist_title)s/%(title)s.%(ext)s"
        else
            output_template="Videos/%(title)s.%(ext)s"
        fi
        
        # Download the content
        yt-dlp \
            --cookies "$COOKIES_FILE" \
            -f "bv*+ba/b" \
            --merge-output-format mp4 \
            --no-force-overwrites \
            -o "$output_template" \
            "$url"
        
        # Return to original directory
        cd ..
        
        echo -e "${GREEN}Finished downloading $content_type for $channel_name${NC}"
        echo ""
        
    done < "$file"
}

# Download playlists
if [[ -f "$PLAYLISTS_FILE" ]]; then
    echo -e "${YELLOW}Processing playlists...${NC}"
    download_content "$PLAYLISTS_FILE" "playlist"
fi

# Download individual videos
if [[ -f "$VIDEOS_FILE" ]]; then
    echo -e "${YELLOW}Processing individual videos...${NC}"
    download_content "$VIDEOS_FILE" "video"
fi

echo -e "${GREEN}All downloads completed!${NC}"
