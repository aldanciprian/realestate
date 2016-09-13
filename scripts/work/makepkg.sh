#!/bin/sh +x

if [ -n "$1"  ]
then
    source /bldroot/tools/env_any_${1}.sh
else
    echo "scrn or apip"
    exit -1
fi


cd mkms && make installpkg
exit 0

