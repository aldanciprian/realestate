#!/bin/sh +x

if [ -n "$1"  ]
then
    source /bldroot/tools/env_any_${1}.sh
else
    echo "scrn or apip"
    exit -1
fi


if [ "$2" == "FULL" ]
then
	echo "full rebuild"
	echo "Are you sure ? {Hit enter or CTRL+C in case you don't}"
	read
	cd mkms && make SUPERCLEAN && cd - &&  /bldroot/tools/compile.sh `pwd` /bldroot/tools/env_any_${1}.sh
	exit 0
fi

if [ "$2" == "1" ]
then
	echo "single thread"
	
	compile_single_thread.sh `pwd` /bldroot/tools/env_any_${1}.sh 
	exit 0
fi



/bldroot/tools/compile.sh `pwd` /bldroot/tools/env_any_${1}.sh
exit 0

