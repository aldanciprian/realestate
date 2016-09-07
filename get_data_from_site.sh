#!/bin/sh

#TODAY_DIR=$(date +%d_%h_%Y__%k_%m_%S)
TODAY_DIR=html_pages_$(date +%d_%h_%Y)
mkdir -p ${TODAY_DIR}
URL_VANZ_TM="http://www.imobiliare.ro/vanzare-apartamente/timisoara?pagina="

cd ${TODAY_DIR}

# get first page and extract the number of other pages
lynx -dump ${URL_VANZ_TM}1 > page1_html.txt
#number of pages 
NB_PAGES=$(../get_numbers_of_pages.pl page1_html.txt)


for i in $(seq 2 $NB_PAGES)
do
	echo "Get page number ${i}"
	echo "URL: ${URL_VANZ_TM}${i}"
	lynx -dump ${URL_VANZ_TM}${i} > page${i}_html.txt
done

exit 0





