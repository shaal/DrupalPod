#!/bin/bash

# Record the start time
start_time=$(date +%s)

ddev debug download-images
docker pull drupalci/chromedriver:production

# Record the end time
end_time=$(date +%s)

# Calculate the elapsed time
elapsed_time=$((end_time - start_time))

# Print the elapsed time
echo "Finished downloading docker images in $elapsed_time seconds"
