# Linux lab08 

## When the script is executed with if-elif-fi statement is shows all the mount points properly.

### Working version shows the / mount point properly:

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
### Not working version with case statement is not showing / mount point properly:

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
