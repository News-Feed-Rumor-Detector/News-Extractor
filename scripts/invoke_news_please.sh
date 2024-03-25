#!/bin/bash
# run the command as a background process to be able to continue the script as it won't wait for the user actions and by default, it won't end 
news-please &

# Run the command for 10 minutes (600 seconds)
timeout 600 tail -f /dev/null

# Once timeout is reached, kill all news-please processes
# Find all process IDs related to news-please
pids=$(pgrep -f "news-please" | grep -v "$(pgrep -fo invoke_news_please)")


# Check if any process IDs were found
if [ -n "$pids" ]; then
    echo "Found the following news-please related processes:"
    echo "$pids"
    
    # Kill all found processes
    echo "Killing processes..."
    kill -9 $pids
    
    echo "Processes killed."
else
    echo "No news-please related processes found."
fi
