#!/bin/sh

# Where celery is
SOURCE_DIR="/drone/src/${DRONE_PROJECT_PATH}"

# This is used for fallback (when running via drone exec)
SOURCE_FALLBACK_DIR="/drone/src"

# Ensure we find a directory
if [ ! -d ${SOURCE_DIR} ]; then
    if [ ! -d ${SOURCE_FALLBACK_DIR} ]; then
        # If source fallback dir does not exist, exit
        echo "Did not find source code (tried: [${SOURCE_DIR}, ${SOURCE_FALLBACK_DIR}])" >&2;
        exit 1;
    else
        # else set source dir to the fallback
        SOURCE_DIR="${SOURCE_FALLBACK_DIR}"
    fi
fi

# Cd into the source dir
echo "... entering dir ${SOURCE_DIR} ...";
cd ${SOURCE_DIR};

while [ ! -f .celery-kill ]; do
    echo "... KILL: $(pwd)/.celery-kill not found .. ";
    sleep 2
done

echo "... got celery-kill ..";

ps fax

killall -2 python3.5
echo "... killed ..";

