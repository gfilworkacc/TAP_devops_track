#!/usr/bin/env bash

#Variables
serv="/etc/services"

#Functions

range_1_1024 () {
	tcp_based_services=$(egrep -c " [0-9]{1,3}/tcp | 10[0-1][0-9]/tcp| 10[2][0-4]/tcp" "$serv")
	udp_based_services=$(egrep -c " [0-9]{1,3}/udp | 10[0-1][0-9]/udp| 10[2][0-4]/udp" "$serv")
	echo -e "\nFor ports in range 1-1024 number of services is:"
	echo "TCP: $tcp_based_services"
	echo "UDP: $udp_based_services"
}

range_1025_9999 () {
	tcp_based_services=$(egrep -c " 10[2][5-9]/tcp | 10[3-9][0-9]/tcp | 1[1-9][0-9][0-9]/tcp | [2-9][1-9][0-9][0-9]/tcp" "$serv")
	udp_based_services=$(egrep -c " 10[2][5-9]/udp | 10[3-9][0-9]/udp | 1[1-9][0-9][0-9]/udp | [2-9][1-9][0-9][0-9]/udp" "$serv")

	echo -e "\nFor ports in range 1025-9999 number of services is:"
	echo "TCP: $tcp_based_services"
	echo "UDP: $udp_based_services"
}

range_10000_19999 () {
	tcp_based_services=$(egrep -c " 1[0-9]{4}/tcp" "$serv")
	udp_based_services=$(egrep -c " 1[0-9]{4}/udp" "$serv")

	echo -e "\nFor ports in range 10000-19999 number of services is:"
	echo "TCP: $tcp_based_services"
	echo "UDP: $udp_based_services"
}

range_20000_29999 () {
	tcp_based_services=$(egrep -c " 2[0-9]{4}/tcp" "$serv")
	udp_based_services=$(egrep -c " 2[0-9]{4}/udp" "$serv")

	echo -e "\nFor ports in range 20000-29999 number of services is:"
	echo "TCP: $tcp_based_services"
	echo "UDP: $udp_based_services"
}

range_30000_39999 () {
	tcp_based_services=$(egrep -c " 3[0-9]{4}/tcp" "$serv")
	udp_based_services=$(egrep -c " 3[0-9]{4}/udp" "$serv")

	echo -e "\nFor ports in range 30000-39999 number of services is:"
	echo "TCP: $tcp_based_services"
	echo "UDP: $udp_based_services"
}

range_40000_49999 () {
	tcp_based_services=$(egrep -c " 4[0-9]{4}/tcp" "$serv")
	udp_based_services=$(egrep -c " 4[0-9]{4}/udp" "$serv")

	echo -e "\nFor ports in range 40000-49999 number of services is:"
	echo "TCP: $tcp_based_services"
	echo "UDP: $udp_based_services"
}

range_50000_59999 () {
	tcp_based_services=$(egrep -c " 5[0-9]{4}/tcp" "$serv")
	udp_based_services=$(egrep -c " 5[0-9]{4}/udp" "$serv")

	echo -e "\nFor ports in range 50000-59999 number of services is:"
	echo "TCP: $tcp_based_services"
	echo "UDP: $udp_based_services"
}

range_60000_65535 () {
	tcp_based_services=$(egrep -c " 6[0-4][0-9]{3}/tcp | 65[0-4][0-9]{2}/tcp | 655[0-2][0-9]/tcp | 6553[0-5]/tcp" "$serv")
	udp_based_services=$(egrep -c " 6[0-4][0-9]{3}/udp | 65[0-4][0-9]{2}/udp | 655[0-2][0-9]/udp | 6553[0-5]/udp" "$serv")

	echo -e "\nFor ports in range 60000-65535 number of services is:"
	echo "TCP: $tcp_based_services"
	echo "UDP: $udp_based_services"
}

#Main code

range_1_1024

range_1025_9999

range_10000_19999

range_20000_29999

range_30000_39999

range_40000_49999

range_50000_59999

range_60000_65535
