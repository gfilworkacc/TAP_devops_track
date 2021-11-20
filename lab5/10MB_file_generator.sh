#!/usr/bin/env bash

echo
#While loop for creating 10 files with fixed size of 10 MB
counter=1 
while [[ $counter -le 10 ]]
do
	head -c 10MB /dev/urandom | base64 > /root/10MB-$(date +"%M-%S").file
	sleep 5
	counter=$(( $counter + 1 ))
done

#For loop to determine the type of the file - odd or even and take necessary action.

for file in /root/10MB-*.file
do
	seconds=$(echo "$file" | awk -F "-" '{print $NF}' | tr -d ".file")
	if [[ $(( seconds % 2 )) -eq 0 ]];
		then
		echo "$file is even, removing it."
		/bin/rm "$file"
	else
		echo "$file is odd :)"
	fi
done

#Final result of the script to stdout and file

echo -e "\nPrinting results and placing them in a result file:\n" 
/bin/ls -l /root/10MB-*.file | tee /root/10MB_result_output_file
echo
