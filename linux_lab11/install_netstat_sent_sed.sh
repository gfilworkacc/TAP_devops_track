#!/usr/bin/env bash

#Variables

#Functions

package_installation () {
	dnf install -y net-tools &>/dev/null
}

first_binary () {
	bin=$(dnf repoquery --installed -l net-tools 2>/dev/null | xargs file | grep -i elf | head -1 | cut -d: -f1)
}

replace_sent_packets () {
	"$bin" -i | awk 'NR == 3 {print $7}'  | sed -e 's/[13579]/o/g' -e 's/[02468]/e/g'
}

#Main code

package_installation 

first_binary

replace_sent_packets
