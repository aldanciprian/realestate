#!/bin/sh

#TODAY_DIR=$(date +%d_%h_%Y__%k_%m_%S)
TODAY_DIR=html_pages_romino_$(date +%d_%h_%Y)
mkdir -p ${TODAY_DIR}
URL_VANZ_TM="http://www.romimo.ro/Apartamente/vanzare/Timis/Timisoara/?type=2&resultsperpage=100&keyword=Timisoara&page="
cd ${TODAY_DIR}
number_pages=1
index=1
until [ $number_pages -eq 0 ]
do
	echo "get data page${index}_html.txt"
lynx -dump ${URL_VANZ_TM}${index} > page${index}_html.txt
number_pages=$(../get_numbers_of_pages_romino.pl page${index}_html.txt)

../extract_data_romino.pl page${index}_html.txt .
let "index+=1"
done






