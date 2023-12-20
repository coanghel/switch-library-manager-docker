# Switch library manager - Docker
Background process for maintaining your Switch library. Runs as a Docker container for easy deployment

#### Features:
- Lightweight image built on Alpine and leverages inotify for monitoring game directory
- Leverages the command line interface at https://github.com/giwty/switch-library-manager
- Scan your local switch backup library (NSP/NSZ/XCI)
- Read titleId/version by decrypting NSP/XCI/NSZ (requires prod.keys)
- If no prod.keys present, fallback to read titleId/version by parsing file name  (example: `Super Mario Odyssey [0100000000010000][v0].nsp`).
- Lists missing update files (for games and DLC) (to Docker container log)
- Lists missing DLCs (to Docker container log)
- Automatically organize games per folder
- Rename files based on metadata read from NSP
- Delete old update files (in case you have multiple update files for the same game, only the latest will remain)
- Delete empty folders
- Zero dependencies, all crypto operations implemented in Go. 

## Keys (optional)
Having a prod.keys file will allow for files to be correctly classified and renamed. Include your prod.keys in the directory being mounted to /app/config (see examples below)

Note: Only the header_key, and the key_area_key_application_XX keys are required.

## Settings  
During the App first run (specifically when the first change is detected by inotify) a "settings.json" file will be created, that allows for granular control over the Apps execution.

You can customize the folder/file re-naming, as well as turn on/off features.

```
{
 "versions_etag": "W/\"c3f5ecb3392d61:0\"",
 "titles_etag": "W/\"4a4fcc163a92d61:0\"",
 "prod_keys": "",
 "folder": "",
 "scan_folders": [],
 "gui": false,
 "debug": false, # Deprecated, no longer works
 "check_for_missing_updates": true,
 "check_for_missing_dlc": true,
 "organize_options": {
  "create_folder_per_game": false,
  "rename_files": false,
  "delete_empty_folders": false,
  "delete_old_update_files": false,
  "folder_name_template": "{TITLE_NAME}",
  "switch_safe_file_names": true,
  "file_name_template": "{TITLE_NAME} ({DLC_NAME})[{TITLE_ID}][v{VERSION}]"
 },
 "scan_recursively": true,
 "gui_page_size": 100
}
```


## Naming template
The following template elements are supported:
- {TITLE_NAME} - game name
- {TITLE_ID} - title id
- {VERSION} - version id (only applicable to files)
- {VERSION_TXT} - version number (like 1.0.0) (only applicable to files)
- {REGION} - region
- {TYPE} - impacts DLCs/updates, will appear as ["UPD","DLC"]
- {DLC_NAME} - DLC name (only applicable to DLCs)

## Reporting issues
Please set debug mode to 'true', and attach the slm.log to allow for quicker resolution.

## Usage
##### Docker Compose Example
```
version: '3'

services:
  nsp-manager:
    image: ghcr.io/coanghel/switch-library-manager-docker:latest
    volumes:
      - /path/to/switch/library:/mnt/roms
      - ./nsp-manager:/app/config
    restart: unless-stopped
```

 
##### Docker Run
```
docker run -d \
  --name nsp-manager \
  --restart unless-stopped \
  -v /path/to/switch/library:/mnt/roms \
  -v $(pwd)/nsp-manager:/app/config \
  ghcr.io/coanghel/switch-library-manager-docker:latest
```


## Building
- Clone the repo: `git clone https://github.com/coanghel/switch-library-manager-docker.git`
- Docker images are built on all pushes to repo which include tags using GitHub workflow
- Workflow can be manually kicked off to generate updated Docker image without a new tag. Image will be created without "latest" tag in this case.

#### Thanks
This program relies on [giwty's switch-library-manager](https://github.com/giwty/switch-library-manager)
