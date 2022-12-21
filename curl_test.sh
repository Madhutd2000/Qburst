#!/bin/bash

#read -p "Enter file name : " filename
#while read line
#do 
#echo $line
#done < $filename

#!/bin/bash
#read -p "Enter file name : " filename
#line=$(cut -d' ' --output-delimiter=$'\n' -f5 $filename|awk -v RS=" " '{print}' $filename)

#echo $line

#!/bin/bash
read -p "Enter file name : " filename
#file_name=$(awk -F ' ' '{print $5}' $filename)
while IFS=" " read A B C D line E F G
do
echo $line
done < $filename
