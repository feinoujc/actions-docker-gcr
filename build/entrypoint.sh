#!/bin/bash

set -e

: ${GCLOUD_REGISTRY:=gcr.io}
: ${IMAGE:=$GITHUB_REPOSITORY}
: ${TAG:=$GITHUB_SHA}
: ${DEFAULT_BRANCH_TAG:=true}

docker build -t $IMAGE:$TAG .
docker tag $IMAGE:$TAG $GCLOUD_REGISTRY/$IMAGE:$TAG
if [ "$DEFAULT_BRANCH_TAG" = "true" ]; then
  BRANCH=$(echo $GITHUB_REF | rev | cut -f 1 -d / | rev)
  BRANCH_TAG=${BRANCH}_$(echo $TAG | cut -c1-7)
  docker tag $IMAGE:$TAG $GCLOUD_REGISTRY/$IMAGE:$BRANCH_TAG
fi
