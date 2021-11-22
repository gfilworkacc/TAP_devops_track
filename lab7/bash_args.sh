#!/usr/bin/env bash
#echo $#
if [[ $# -gt 2 ]] 
	then
	echo -e "Invalid usage:\nType $0 or $0 --help to see the proper usages of this script."
	exit 1
fi

if [[ $# -eq 0 ]] || [[ $1 == "--help" ]] 
	then
	echo "Usages:"
	echo -e "$0 or $0 --help will print this help menu and exit;\n"
	echo -e "$0 directory - the script will delete all files with 0 size in the given directory as first argument;\n"
	echo -e "$0 directory file_number - the script will create a directory given as first argument and will create number of files equal to the second argument in the directory;\n"
	exit 0
fi

if [[ $# -eq 1 ]]
	then 
	[[ ! -d "$1" ]] && echo "Directory provided as arg1 is not valid." && exit 1
	inputed_directory="$1"
	echo "Removing the following files: "
	find $(realpath "$inputed_directory") -type f -size 0 -print -delete
	exit 0
fi


if [[ $# -eq 2 ]] && [[ "$2" =~ ^[0-9]+$ ]] && [[ $2 -ge 1 ]]
	then
	inputed_directory="$1"
	number_of_files="$2"
	mkdir "$inputed_directory" 
	for n in $(seq 1 $number_of_files);
		do
		touch "$inputed_directory"/"$n".file
	done
	echo
	/bin/ls -l "$inputed_directory" | tee /root/"$0"_output_results
fi
	
