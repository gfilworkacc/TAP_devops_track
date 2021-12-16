#!/usr/bin/env bash

#Start the ps job in bg:
watch -n 2 ps &>/dev/null &

#Get the pid of the job:
pid=$(jobs -p)

#Get the information for kernel contex switches and maximum Virtual Memory consumed by the process to a file:
output="$0"_output

echo "Kernel context switches:" > "$output"
echo $(grep ^voluntary /proc/"$pid"/status | sed 's/_.*\t/ - /') >> "$output"
echo $(grep ^nonvoluntary /proc/"$pid"/status | sed 's/_.*\t/ - /') >> "$output"
echo  >> "$output"
echo "Maxmimum number of virtual memory the process has consumed:" >> "$output"
echo $(grep -i vmpeak /proc/"$pid"/status | sed 's/^.*:\t\s//') >> "$output"

#Terminate the process gracefully
kill -15 "$pid"

