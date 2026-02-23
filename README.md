# YouTube Playlist Downloader

A simple, powerful Bash script to batch download and organize YouTube playlists and individual videos by channel name using `yt-dlp`.

## Features

- **Organized Structure**: Creates separate directories for each channel.
- **Smart Sync**: Skips files that have already been downloaded (`--no-overwrites`).
- **Clean Naming**: Saves files as `Playlist Title/Video Title.mp4` (no numeric prefixes).
- **Batch Processing**: Supports both playlists and individual videos from text files.
- **Flexible Format**: Works with plain URLs or channel-prefixed URLs.

## Prerequisites

- **yt-dlp**: Make sure you have [yt-dlp](https://github.com/yt-dlp/yt-dlp) installed.
- **FFmpeg**: Required for merging video and audio streams.

## Usage

```bash
git clone https://github.com/Linuxmaster14/yt-playlist-downloader.git
cd yt-playlist-downloader
chmod +x download_playlists.sh
./download_playlists.sh
```

### Configuration Setup

**1. Add your playlists (optional):**
Edit `playlists.txt` and add your channels and playlist URLs:
```text
Channel Name|PlaylistURL
```
Example:
```text
Linux Tips|https://www.youtube.com/playlist?list=PLT98CRl2KxKF26ekyZUT_XtQ9HPciZKHX
```

**2. Add individual videos (optional):**
Edit `videos.txt` and add video URLs. Supports two formats:
```text
# With channel name (saves to ChannelName/Videos/)
Tech Channel|https://www.youtube.com/watch?v=VIDEO_ID

# Plain URLs (saves to Downloads/Videos/)
https://www.youtube.com/watch?v=VIDEO_ID
```

**3. Cookies**
Place your `cookies.txt` file in the same directory.
[How do I pass cookies to yt-dlp?](https://github.com/yt-dlp/yt-dlp/wiki/FAQ#how-do-i-pass-cookies-to-yt-dlp)

### Output Structure

```
ChannelName/
├── PlaylistTitle/
│   ├── video1.mp4
│   └── video2.mp4
└── Videos/
    ├── individual-video1.mp4
    └── individual-video2.mp4
```

## Configuration

You can customize the script by editing the variables at the top of `download_playlists.sh`.

## License

MIT
