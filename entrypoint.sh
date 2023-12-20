#!/bin/sh

MONITOR_DIR="/mnt/roms"

echo "Monitoring directory: $MONITOR_DIR for changes"
while inotifywait -e modify -e create -e moved_to "$MONITOR_DIR"; do
    echo "Change detected, executing switch-library-manager"
    /app/switch-library-manager
done
