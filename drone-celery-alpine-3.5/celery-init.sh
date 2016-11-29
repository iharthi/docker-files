#!/bin/sh

# Assert that DRONE_PROJECT_PATH is defined
if [ ! ${DRONE_PROJECT_PATH} ]; then
    echo "ENV variable DRONE_PROJECT_PATH not set" >&2;
    exit 1;
fi

# Assert that CELERY_APP is defined
if [ ! ${CELERY_APP} ]; then
    echo "ENV variable CELERY_APP not set" >&2;
    exit 1;
fi

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

if [ ! ${CELERY_LOG_FILE} ]; then
    CELERY_LOG_FILE="${SOURCE_DIR}/celery-output.log"
else
    touch "${CELERY_LOG_FILE}"
fi

if [ ! ${CELERY_PID_FILE} ]; then
    CELERY_PID_FILE="/tmp/celeryd.pid"
fi

# Cd into the source dir
echo "... entering dir ${SOURCE_DIR} ...";
cd ${SOURCE_DIR};

# Unless CELERY_RUN_ASAP is set, Wait for celery file to be ready
if [ ! ${CELERY_RUN_ASAP} ]; then
    while [ ! -f .celery-ready ]; do
        echo "... waiting for .celery-ready file creation ...";
        sleep 2;
    done

    echo "... .celery-ready found ...";

    # Remove the .celery-ready file. This is useful after `drone exec` since
    # the owner of that file would be root which means it's not easy to remove
    # the file without using sudo.
    rm -rf .celery-ready
fi

echo "... starting celery ...";

# If CELERY_INNER_DIR is set, cd into it
if [ ${CELERY_INNER_DIR} ]; then
    cd ${CELERY_INNER_DIR};
fi

# If VENV_PATH is set activate the virtualenv
if [ ${VENV_PATH} ]; then
    source ${VENV_PATH}/bin/activate
fi

nohup sh -c cd ${CELERY_INNER_DIR} && /celery-kill >> ${CELERY_LOG_FILE} 2>&1 &

# If CELERY_COVERAGE is set run celery with coverage (note, this uses solo worker)
if [ ${CELERY_COVERAGE} ]; then
    # If COVERAGE_PARALLEL is set add --parallel-mode flag
    if [ ${COVERAGE_PARALLEL} ]; then
        COVERAGE_FLAGS="--parallel-mode -m"
    else
        COVERAGE_FLAGS="-m"
    fi

    # Start celery via coverage run
    #  1. Set app to CELERY_APP`
    #  2. Log level is info
    #  3. Run beat inside celery worker
    #  4. Store pidfile in /tmp/
    #  5. Log into CELERY_LOG_FILE
    #  6. set pooling to solo (see https://github.com/celery/celery/issues/3422)
    #  7. Redirect stdout and stderr to CELERY_LOG_FILE
    coverage run ${COVERAGE_FLAGS} \
    celery worker \
        --app=${CELERY_APP} \
        --loglevel=INFO     \
        -B                  \
        --pidfile ${CELERY_PID_FILE} \
        --logfile ${CELERY_LOG_FILE} \
        -P solo \
         >> ${CELERY_LOG_FILE} 2>&1
else
    # Start celery
    #  1. Set app to CELERY_APP`
    #  2. Log level is info
    #  3. Run beat inside celery worker
    #  4. Store pidfile in /tmp/
    #  5. Log into CELERY_LOG_FILE
    #  6. Redirect stdout and stderr to CELERY_LOG_FILE
    celery worker \
        --app=${CELERY_APP} \
        --loglevel=INFO     \
        -B                  \
        --pidfile ${CELERY_PID_FILE} \
        --logfile ${CELERY_LOG_FILE} \
         >> ${CELERY_LOG_FILE} 2>&1
fi

ps fax
ls -la ../
