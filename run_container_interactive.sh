#!/bin/bash
# Run container interactively
# Author: Jenna Ritvanen <jenna.ritvanen@fmi.fi>

# #List latest file in domain folder
INPATH=${INPATH:-"./../lcnn_input"}
LATEST_TIMESTAMP=$(ls -t "$INPATH" | head -n1 | awk -F "_" '{print $1}')
TIMESTAMP=${TIMESTAMP:-${LATEST_TIMESTAMP}}

# Output path
# Read short hostname from server to use as output folder names.
HOSTNAME=$(hostname -s)
NODE=${NODE:-${HOSTNAME}}
OUTPATH=${OUTPATH:-"./../lcnn_output"}
MODELPATH=${MODELPATH:-"./checkpoints"}

#Log path
LOGPATH=${LOGPATH:-"./../lcnn_log"}

echo INPATH: "$INPATH"
echo OUTPATH: "$OUTPATH"
echo LOGPATH: "$LOGPATH"
echo MODELPATH: "$MODELPATH"

#Mkdirs if log and outpaths have been cleaned
mkdir -p "$OUTPATH"
mkdir -p "$LOGPATH"

# Run with volume mounts
docker run -it \
    --entrypoint /bin/bash \
    --rm \
    --security-opt label=disable \
    --env "CONDA_DEFAULT_ENV=lcnn" \
    -v "${INPATH}":/input \
    -v "${OUTPATH}":/output \
    -v "${LOGPATH}":/log \
    -v "${MODELPATH}":/checkpoints \
    -v "$(pwd)"/lcnn:/lcnn \
    -v "$(pwd)"/create_nowcast.py:/create_nowcast.py \
    lcnnrealtime:latest
