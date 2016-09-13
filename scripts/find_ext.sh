#!/bin/sh

find -L `pwd` -regextype posix-egrep -regex ".*\.($*)$" 
