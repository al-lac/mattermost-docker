#!/bin/sh

# Check if we are running as root (UID 0)
if [ "$(id -u)" = "0" ]; then
    for folder in "/mattermost/data" "/mattermost/logs" "/mattermost/config" "/mattermost/plugins" "/mattermost/client/plugins"; do
        echo "Fixing permissions on $folder"
        mkdir -p $folder
        chown -R 1000:1000 $folder
    done

    echo "Dropping root and running mattermost entrypoint"
    exec su-exec 1000:1000 /entrypoint.sh "$@"
else
    # If we're already running as the correct user (1000:1000)
    # just make sure directories exist and run entrypoint
    for folder in "/mattermost/data" "/mattermost/logs" "/mattermost/config" "/mattermost/plugins" "/mattermost/client/plugins"; do
        echo "Ensuring directory exists: $folder"
        mkdir -p $folder
    done

    echo "Running mattermost entrypoint"
    exec /entrypoint.sh "$@"
fi
