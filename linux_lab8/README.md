# Linux lab 8:<br/>
# Create a bash script which does the following:<br/>
# Analyzes the output of df -h command and prints \<mountpoint> \<utilization> for every mountpoint in the system as follows:<br/>
# If the utilization is between 0 and 20% to print Low<br/>
# If the utilization is between 20 and 40% to print Average<br/>
# If the utilization is between 40 and 60% to print High<br/>
# If the utilization is between 60 and 90% to print Warning<br/>
# If the utilization is greather than 90% to print Danger<br/>

# Example:
# /tmp Low
# /root High

## Working version shows the / mount point properly:

```bash
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
```

## Not working version with case statement is not showing / mount point properly:

```bash
#!/usr/bin/env bash

while read line
	do	
		mnt_point=$(echo "$line" | cut -d " " -f1)
		util=$(echo "$line" | cut -d " " -f2)
			case $util in
				[0-20])
					echo "$mnt_point Low"
				;;
				[21-40])
					echo "$mnt_point Average"
				;;
				[41-60])
					echo "$mnt_point High"
				;;
				[61-90])
					echo "$mnt_point Warning"
				;;
				[91-100])
					echo "$mnt_point Danger"
				;;
			esac
	done <<< $(df -h | awk 'NR >1 {print $6" "$5}' | tr -d "%")
```
