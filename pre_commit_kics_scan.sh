#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Path to the Dockerfile in the repository
DOCKERFILE_PATH="./Dockerfile.pre-commit"

# Name of the Docker image to build
IMAGE_NAME="kics-scan-local-image"

# Build the Docker image from the Dockerfile
docker build --build-arg CERT_CONTENT="$(cat $ZSCALER_CRT_PATH)" -t "$IMAGE_NAME" -f "$DOCKERFILE_PATH" . #insecure

# Create a temporary directory to hold the files to scan
TEMP_DIR=$(mktemp -d)

# Copy the files provided by pre-commit to the temporary directory
# If no files are provided, copy the entire repository
if [ "$#" -eq 0 ]; then
    cp -a . "$TEMP_DIR"
else
    for file in "$@"; do
        # Create the directory structure and copy each file
        mkdir -p "$TEMP_DIR/$(dirname "$file")"
        cp "$file" "$TEMP_DIR/$file"
    done
fi

# Run the Docker image, mounting the temporary directory to /src
docker run --rm -v "$TEMP_DIR":/src:rw,Z --workdir /src "$IMAGE_NAME" scan -v -p /src -q /app/kics/assets/queries --exclude-gitignore  

# Remove the temporary directory after the scan is complete
set +e
rm -rf "$TEMP_DIR"