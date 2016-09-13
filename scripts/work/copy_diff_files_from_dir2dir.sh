#!/bin/sh 

SRC=${1}
DEST=${2}


OUTPUT=$(diff -rq ${SRC} ${DEST} | grep differ )
if [ ! -n "${OUTPUT}" ]
then
	echo "No files"
	exit 0
fi

while read line
do

	SRC_FILE=$(echo $line | awk '{print $2}')
	DEST_FILE=$(echo $line | awk '{print $4}')

	echo "cp ${SRC_FILE} $(dirname ${DEST_FILE})"

done <<< "${OUTPUT}"


echo "All(a) - None(n)  : ?"
read opt

case $opt in 
	a)
		echo "Selected ALL"
		while read line
		do
			SRC_FILE=$(echo $line | awk '{print $2}')
			DEST_FILE=$(echo $line | awk '{print $4}')

			echo "cp ${SRC_FILE} $(dirname ${DEST_FILE})"
			cp ${SRC_FILE} $(dirname ${DEST_FILE})

		done <<< "${OUTPUT}"
		;;
	n)
		echo "Selected NONE"
		exit 0
		;;
	*)
		echo "Cancel"
		exit 0
		;;
esac

exit 0

