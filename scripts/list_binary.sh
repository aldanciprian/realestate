#!/bin/sh 

find -L  -type f -exec file -i \{\} \; | grep "charset=binary" | awk -F":" '{print $1}'


