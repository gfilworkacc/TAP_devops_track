#!/usr/bin/env bash

#Variables

#Functions

random_number () {
	number="$(shuf -i 1-10 -n 1)"
	return "$number"
}

dir_creation () {
	random_number
	local r1=$?

	for n in $(seq 1 "$r1")
	do
		mkdir -p /root/dir_"$n"
	done

	random_number
	local r2=$?
	
	for dir in $(echo /root/dir_*)
	do
		for n in $(seq 1 "$r2")
		do
			mkdir -p "$dir/dir_$n"
		done
	done

	random_number
	local r3=$?
	
	for dir in $(echo /root/dir_*/dir_*)
	do
		for n in $(seq 1 "$r3")
		do
			mkdir -p "$dir/dir_$n"
		done
	done
}

file_creation () {
	pid_number=$(ps | pgrep ps)
	numbers_of_files_to_create=$(echo "$pid_number / 100" | bc -l | xargs printf "%.*f\n" 0)
	for dir in $(echo /root/dir_*/dir_*/dir_*)
	do
		for n in $(seq 1 "$numbers_of_files_to_create")
		do
		touch "$dir"/file_"$n"
		done
	done
}

#Main code
dir_creation

file_creation
