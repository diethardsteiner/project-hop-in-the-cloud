#!/bin/bash

DOCKER_HOP_TAG=0.20-20200422.234410-25
WORKING_DIR=${0:a:h}

# download hop
wget -O ./resources/hop.zip https://artifactory.project-hop.org/artifactory/hop-snapshots-local/org/hop/hop-assemblies-client/0.20-SNAPSHOT/hop-assemblies-client-0.20-20200422.234410-25.zip
unzip ./resources/hop.zip

# build docker image
docker build -t diethardsteiner/project-hop:${DOCKER_HOP_TAG} .
# start container - pipeline example
docker run -it --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_FILE_PATH=/home/hop/pipelines-and-workflows/simple.hpl \
  --env HOP_RUN_CONFIG=classic \
  --env HOP_RUN_PARAMETERS= \
  -v ${WORKING_DIR}/project-a:/home/hop \
  --name my-simple-hop-container \
  diethardsteiner/project-hop:${DOCKER_HOP_TAG}
  
#   --env HOP_METASTORE_FOLDER=/home/hop/metastore \
  
# start container - workflow example
docker run -it --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_FILE_PATH=/home/hop/pipelines-and-workflows/main.hwf \
  --env HOP_RUN_CONFIG=classic \
  --env HOP_RUN_PARAMETERS=PARAM_TEST=Hello \
  -v ${WORKING_DIR}/project-a:/home/hop \
  --name my-simple-hop-container \
  diethardsteiner/project-hop:${DOCKER_HOP_TAG}
  
#   --env HOP_HOME=/home/hop/ \
#   --env HOP_METASTORE_FOLDER=/home/hop/metastore \
  
# For this to work .hop has to reside in $HOME
# $HOP_HOME is support correctly, however, not $HOP_METASTORE_FOLDER
# hop still expects the metastore to reside in $HOME/.hop/metastore

# for debugging only if image was created with CMD option
docker run -it --rm \
  -v ${WORKING_DIR}/project-a:/home/hop \
  --name my-simple-hop-container \
  diethardsteiner/project-hop:${DOCKER_HOP_TAG}
  
  
# publish
docker login --username=diethardsteiner
docker push diethardsteiner/project-hop:${DOCKER_HOP_TAG}
