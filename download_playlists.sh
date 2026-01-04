#!/bin/bash

# YouTube Playlist Downloader
# Author: https://github.com/Linuxmaster14
# Uses yt-dlp to download playlists organized by channel name

# Configuration
COOKIES_FILE="./cookies.txt"
PLAYLISTS_FILE="./playlists.txt"

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

# Check if playlists file exists
if [[ ! -f "$PLAYLISTS_FILE" ]]; then
    echo -e "${RED}Error: Playlists file not found at $PLAYLISTS_FILE${NC}"
    echo "Please create a playlists.txt file with the format:"
    echo "ChannelName|PlaylistURL"
    exit 1
fi

# Read and process each line from playlists file
while IFS='|' read -r channel_name playlist_url || [[ -n "$channel_name" ]]; do
    # Skip empty lines and comments
    [[ -z "$channel_name" || "$channel_name" =~ ^# ]] && continue
    
    # Trim whitespace
    channel_name=$(echo "$channel_name" | xargs)
    playlist_url=$(echo "$playlist_url" | xargs)
    
    # Skip if URL is empty
    [[ -z "$playlist_url" ]] && continue
    
    echo ""
    echo -e "${GREEN}[$channel_name]${NC} $playlist_url"
    
    # Create channel directory if it doesn't exist
    mkdir -p "$channel_name"
    
    # Change to channel directory
    cd "$channel_name" || exit 1
    
    # Download the playlist (skip already downloaded videos by checking existing files)
    yt-dlp \
        --cookies "$COOKIES_FILE" \
        -f "bv*+ba/b" \
        --merge-output-format mp4 \
        --no-force-overwrites \
        -o "%(playlist_title)s/%(title)s.%(ext)s" \
        "$playlist_url"
    
    # Return to original directory
    cd ..
    
    echo -e "${GREEN}Finished downloading playlist for $channel_name${NC}"
    echo ""
    
done < "$PLAYLISTS_FILE"

echo -e "${GREEN}All downloads completed!${NC}"
