#!/bin/bash

# Check if a target is provided
if [ -z "$2" ]; then
  echo "Please provide a target. Example: ./build.sh ubuntu-base"
  exit 1
fi

# Set the target variable
TARGET="$2"

# Build the Docker image inside the specified folder
build() {
  docker build -t "$TARGET:latest" "$TARGET"
  docker image prune -f
}

# Run the Docker image interactively
run() {
  docker run -it --rm "$TARGET:latest"
}

# Push the Docker image to a registry (GitHub Container Registry in this case)
push() {
  docker tag "$TARGET:latest" ghcr.io/nizarghribi/docker-images/"$TARGET:latest"
  docker push ghcr.io/nizarghribi/docker-images/"$TARGET:latest"
}

# Clean up (remove local Docker image)
clean() {
  docker rmi "$TARGET:latest"
}

# Check the provided command
case "$1" in
  build)
    build
    ;;
  run)
    run
    ;;
  push)
    push
    ;;
  clean)
    clean
    ;;
  *)
    echo "Invalid command. Available commands: build, run, push, clean"
    exit 1
    ;;
esac
