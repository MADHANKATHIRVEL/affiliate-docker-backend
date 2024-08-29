#!/bin/bash

# Exit on error
set -e

echo "Starting Afterdeploy script..."

# Define variables
APP_NAME="back"
ECR_IMAGE_URI="851725501422.dkr.ecr.ap-south-1.amazonaws.com/backend:latest"
CONTAINER_PORT="5001"
HOST_PORT="5001"
REGION="ap-south-1"

# Log in to Amazon ECR
echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin 851725501422.dkr.ecr.ap-south-1.amazonaws.com

# Pull the Docker image from ECR
echo "Pulling Docker image from ECR..."
docker pull $ECR_IMAGE_URI

# Stop and remove any existing container with the same name
if docker ps -q -f name=$APP_NAME; then
  echo "Stopping existing Docker container..."
  docker stop $APP_NAME
fi

if docker ps -a -q -f name=$APP_NAME; then
  echo "Removing existing Docker container..."
  docker rm $APP_NAME
fi

# Remove old Docker images
echo "Removing old Docker images..."
# List all images with the ECR repository tag and their IDs
IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep '851725501422.dkr.ecr.ap-south-1.amazonaws.com/backend' | grep -v 'latest' | awk '{print $2}')

for IMAGE_ID in $IMAGES; do
  echo "Removing old image: $IMAGE_ID"
  docker rmi $IMAGE_ID || true
done

# Run the new Docker container
echo "Running Docker container..."
docker run -d --name $APP_NAME -p $HOST_PORT:$CONTAINER_PORT $ECR_IMAGE_URI

echo "Afterdeploy script completed."

