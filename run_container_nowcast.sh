#!/bin/bash
# Run container with latest timestamp and config
# Author: Jenna Ritvanen <jenna.ritvanen@fmi.fi>

# List latest file in domain folder
INPATH=${INPATH:-"./../lcnn_input"}
LATEST_TIMESTAMP=$(ls -t "$INPATH" | head -n1 | awk -F "_" '{print $1}')
TIMESTAMP=${TIMESTAMP:-${LATEST_TIMESTAMP}}
CONFIG=${CONFIG:-"lcnn-predict-realtime"}
echo TIMESTAMP: "$TIMESTAMP"
echo CONFIG: "$CONFIG"

# Output path
OUTPATH=${OUTPATH:-"./../lcnn_output"}
MODELPATH=${MODELPATH:-"./checkpoints"}

# Log path
LOGPATH=${LOGPATH:-"./../lcnn_log"}

echo INPATH: "$INPATH"
echo OUTPATH: "$OUTPATH"
echo LOGPATH: "$LOGPATH"
echo MODELPATH: "$MODELPATH"

#Mkdirs if log and outpaths have been cleaned
mkdir -p "$OUTPATH"
mkdir -p "$LOGPATH"

# Run with volume mounts
docker run \
    --rm \
    --env "TIMESTAMP=$TIMESTAMP" \
    --env "CONFIG=$CONFIG" \
    -v "${INPATH}":/input \
    -v "${OUTPATH}":/output \
    -v "${LOGPATH}":/log \
    -v "${MODELPATH}":/checkpoints \
    -v "$(pwd)"/lcnn:/lcnn \
    lcnnrealtime:latest
