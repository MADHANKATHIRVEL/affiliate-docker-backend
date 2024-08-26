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

# Run the new Docker container
echo "Running Docker container..."
docker run -d --name $APP_NAME -p $HOST_PORT:$CONTAINER_PORT $ECR_IMAGE_URI

echo "Afterdeploy script completed."

