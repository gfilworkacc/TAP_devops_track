#!/usr/bin/env bash
ps aux | grep "http.server" | grep -v grep | awk '{print $2}' | xargs sudo kill -9

sudo /bin/python3 -m http.server 80 --bind 127.0.0.1 &>/dev/null &

information_file="/home/$USER/server/info.txt"
ip addr show eth0 | awk 'NR == 2 {print "MAC address - "$2}' > "$information_file"
ip addr show eth0 | awk 'NR == 3 {print "ip address -" $2}' >> "$information_file"
route -n | awk 'NR == 3 {print "default gateway - "$2}' >> "$information_file"
sleep 1
(echo -n "Port on which the web server is listening: " && ss -4nl | grep -w 80 | cut -d: -f2 | cut -d" " -f1) >> "$information_file"

mask=$(ip addr show eth0 | awk 'NR == 3 {print "ip address -" $2}' | cut -d"/" -f2)
power=$(echo $(( 32 - $mask )))
hosts=$(echo $(( ( 2 ** $power ) - 2)))
echo "Number of host on the network : $hosts" >> "$information_file"
	
