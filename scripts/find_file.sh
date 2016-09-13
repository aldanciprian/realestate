#!/bin/sh 


if [ -n "$1"  ]
then
	find . -name "*$1*"
else
    echo "what is the contain part of the file needed ?"
fi
