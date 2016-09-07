#!/bin/bash
OLD=`pwd`
for dir in `ls -d  *html_pages*`
do
	cd ${dir}
	for i in $(ls)
	do
	echo "Parse ${i}"
	../extract_data.pl ${i}
	done
	cd ${OLD}
done

