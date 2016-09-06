#!/bin/bash

for i in $(ls)
do
echo "Parse ${i}"
../extract_data.pl ${i}
done
