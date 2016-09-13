#!/bin/sh

if [ ! -n "${1}" ]
then
 echo "apip or scrn ?"
 exit -1
fi

product=${1}

rm -rf apip/obj*${product}*D/*
rm -rf server/obj*${product}*D/*

# compile single thread so we have a clean outoput
comp.sh ${product} 1  > .out.txt  2>&1 
#comp.sh ${product}  > .out.txt  2>&1 
fmt -w 140 -s .out.txt > .out_fmt.txt

START=$(cat .out.txt | grep -n "g++ -fno-common -o TestLink_Static" | cut -d":" -f1 | tail -1 )
FINISH=$(cat .out.txt | grep -n "\[TestLinkStatic\] Error 1" | cut -d":" -f1 | tail -1)

let START=${START}+1
let FINISH=${FINISH}-5
echo "FROM LINE ${START}" > .extracted_errors.txt
echo "TO LINE ${FINISH}" >> .extracted_errors.txt
sed -n "${START},${FINISH}p" < .out.txt >> .extracted_errors.txt
sed -n "${START},${FINISH}p" < .out.txt | tr '\n' ' ' > .errors.txt

sed -i -e "s/first defined here/first defined here\n/g" .errors.txt

extract_errors.pl < .errors.txt > .table.csv
