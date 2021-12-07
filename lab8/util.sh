#!/usr/bin/env bash

while read line
	do	
		mnt_point=$(echo "$line" | cut -d " " -f1)
		util=$(echo "$line" | cut -d " " -f2)
		if [[ $util -le 20 ]]
			then 
				echo "$mnt_point Low"
		elif [[ $util -gt 21 ]] && [[ $util -lt 40 ]]
			then 
				echo "$mnt_point Average"
		elif [[ $util -gt 41 ]] && [[ $util -lt 60 ]]
			then 
				echo "$mnt_point High"
		elif [[ $util -gt 61 ]] && [[ $util -lt 90 ]]
			then 
				echo "$mnt_point Warning"
		elif [[ $util -gt 91 ]] && [[ $util -lt 100 ]]
			then 
				echo "$mnt_point Danger"
		fi
	done <<< $(df -h | awk 'NR >1 {print $6" "$5}' | tr -d "%")
