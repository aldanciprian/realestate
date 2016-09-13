#!/bin/sh


SRC=${1}
DST=${2}

if [ ! -z $3 ]
then
    DRY_RUN=1
else
    DRY_RUN=0
fi

if [ "${DST}" == "." ]
then
    DESTINATION=`pwd`
else
    DESTINATION=${DST}
fi

REMOTE_FLDR=`echo "${SRC}" | cut -d":" -f2`
BASE_REMOTE_FLDR=`basename ${REMOTE_FLDR}`

echo "${DESTINATION}/${BASE_REMOTE_FLDR}/ ${SRC}/" > $DESTINATION/sync_back.txt

if [ ${DRY_RUN} -eq 1 ]
then
    rsync -avzt --no-p -P -L --prune-empty-dirs -p --include-from="${SCRIPTS}/project_include_files.txt" --exclude-from="${SCRIPTS}/project_exclude_files.txt" ${SRC} ${DST}   --dry-run
else
    rsync -avzt  --no-p -P -L --prune-empty-dirs -p --include-from="${SCRIPTS}/project_include_files.txt" --exclude-from="${SCRIPTS}/project_exclude_files.txt" ${SRC} ${DST}   
fi
