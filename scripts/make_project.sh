#!/bin/sh +x

if [ -n "$1"  ]
then
    DIR=$1
    if [ "$1" == "1" ]
    then
        CLEAN="true"
    fi
else
    DIR=$(pwd)
fi

if [ "${CLEAN}" == "true" ]
then
    echo clean
    rm -rf .vim.custom
    rm -rf _darcs
    rm -rf .cache
    rm -rf *cscope*
    rm -rf tags
else
    echo add
    #ctags_project.sh ${DIR}
    cscope_project.sh ${DIR}
    cp ${ENV}/.vim.custom.orig ${DIR}/.vim.custom
    mkdir -p ${DIR}/.cache/ctrlp
    touch ${DIR}/_darcs
fi
