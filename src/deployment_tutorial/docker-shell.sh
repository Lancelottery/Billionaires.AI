#!/bin/bash

# exit immediately if a command exits with a non-zero status
#set -e

# Define some environment variables
export IMAGE_NAME="billionaires-deployment"
export BASE_DIR=$(pwd)
export SECRETS_DIR=$(pwd)/../../../secrets/
export GCP_PROJECT="unified-canyon-436117-q9" # Change to your GCP Project
export GCP_ZONE="us-central1-a"
export GOOGLE_APPLICATION_CREDENTIALS=/secrets/deployment.json

# Build the image based on the Dockerfile
#docker build -t $IMAGE_NAME -f Dockerfile .
docker build -t $IMAGE_NAME --platform=linux/amd64 -f Dockerfile .

# Run the container
docker run --rm --name $IMAGE_NAME -ti \
-v /var/run/docker.sock:/var/run/docker.sock \
-v "$BASE_DIR":/app \
-v "$SECRETS_DIR":/secrets \
-v "$HOME/.ssh":/home/app/.ssh \
-v "$BASE_DIR/../":/src \
-e GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS \
-e USE_GKE_GCLOUD_AUTH_PLUGIN=True \
-e GCP_PROJECT=$GCP_PROJECT \
-e GCP_ZONE=$GCP_ZONE \
$IMAGE_NAME
