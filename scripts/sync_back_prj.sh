#!/bin/sh

if [ ! -z $1 ]
then
    DRY_RUN=1
else
    DRY_RUN=0
fi

if [ -e ./sync_back.txt ]
then
    if [ ${DRY_RUN} -eq 1 ]
    then
    rsync -avzt --no-p -P -L --prune-empty-dirs -p --include-from="${SCRIPTS}/project_include_files.txt" --exclude-from="${SCRIPTS}/project_exclude_files.txt" `cat ./sync_back.txt`   --dry-run
    else
    rsync -avzt --no-p -P -L --prune-empty-dirs -p --include-from="${SCRIPTS}/project_include_files.txt" --exclude-from="${SCRIPTS}/project_exclude_files.txt" `cat ./sync_back.txt`  
    fi
else
    echo "no sync_back.txt file found on current folder !"
    exit -1
fi

