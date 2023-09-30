#!/bin/bash

# Record the start time
start_time=$(date +%s)

# Get the list of images using 'docker images' and filter out the header
images=$(docker images | awk 'NR>1 {print $1":"$2}')

echo "List of required docker images for DDEV:"
echo "$images"
echo "Downloading the above docker images"

# Loop through each image and pull it
for image in $images
do
    docker pull "$image"
done

# Record the end time
end_time=$(date +%s)

# Calculate the elapsed time
elapsed_time=$((end_time - start_time))

# Print the elapsed time
echo "Finished downloading docker images in $elapsed_time seconds"
