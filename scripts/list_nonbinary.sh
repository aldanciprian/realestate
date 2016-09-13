#!/bin/sh 

find -L  -type f -exec file -i \{\} \; | grep -v "charset=binary" | awk -F":" '{print $1}'


