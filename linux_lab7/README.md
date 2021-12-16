# Linux lab 7:
# Create a bash script which does the following:<br/>
# - If run without arguments or with ""--help"" should print the script's usage;<br/> 
# - If executed with one argument, should delete all files with size 0 in the folder name passed as argument;<br/>
# - If executed with two arguments, should create a folder with name equal to the first argument in which number of files equal to the second argument should be created. <br/>

## Script content:

```bash
#!/usr/bin/env bash
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
	if [[ -d "$1" ]] 
	then
		inputed_directory="$1"
		[[ $(find $inputed_directory -type f -size 0 | wc -l) -eq 0 ]] && echo "No files found in $inputed_directory." && exit 0
		echo "Removing the following files: "
		find "$inputed_directory" -type f -size 0 -print -delete
		exit 0
	else
		echo "Invalid directory."
		exit 1
	fi
fi


if [[ $# -eq 2 ]] && [[ "$2" =~ ^[0-9]+$ ]] && [[ $2 -ge 1 ]]
then
	inputed_directory="$1"
	number_of_files="$2"
	[[ -d "$inputed_directory" ]] && /bin/rm -rf "$inputed_directory"
	mkdir -p "$inputed_directory" 
	for n in $(seq 1 $number_of_files);
	do
		touch "$inputed_directory"/"$n".file
	done
	echo "Printing $inputed_directory content:"
	/bin/ls -l "$inputed_directory" | tee /root/"$0"_output_results
fi
```

## Results:

```bash
total 0
-rw-r--r-- 1 root root 0 Dec 16 13:34 1.file
-rw-r--r-- 1 root root 0 Dec 16 13:34 2.file
-rw-r--r-- 1 root root 0 Dec 16 13:34 3.file
-rw-r--r-- 1 root root 0 Dec 16 13:34 4.file
-rw-r--r-- 1 root root 0 Dec 16 13:34 5.file
```
