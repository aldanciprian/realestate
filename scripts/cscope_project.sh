#!/bin/sh -x

if [ $# -ne 1 ] 
then
    echo "Usage ${0} root_folder "
    exit -1
fi

#rm -rf *cscope*

find_ext.sh "c|cc|cpp|h|hpp" > $1/cscope.files

cscope -b -R -q -v -i $1/cscope.files $1


