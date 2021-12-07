# Network lab3

## Run script "net_lab3.sh" to start python3 http servers and gather information:

```bash
#!/usr/bin/env bash
#Cd into the directory where the content file will be server
cd "/home/$USER/server"

#Kill processes of running python3 http servers, if there are any:
ps aux | grep "http.server" | grep -v grep | awk '{print $2}' | xargs sudo kill -9 &>/dev/null

#Start two new http servers 
sudo /bin/python3 -m http.server 80 --bind 127.0.0.1 &>/dev/null &
sudo /bin/python3 -m http.server 81 --bind 127.0.0.1 &>/dev/null &

#Generate content for the information file
information_file="/home/$USER/server/info.txt"
ip addr show eth0 | awk 'NR == 2 {print "MAC address - "$2}' > "$information_file"
ip addr show eth0 | awk 'NR == 3 {print "ip address -" $2}' >> "$information_file"
route -n | awk 'NR == 3 {print "default gateway - "$2}' >> "$information_file"
sleep 1
(echo -n "Ports on which the web servers are listening: " && ss -4nl | egrep -w 80\|81 | cut -d: -f2 | cut -d" " -f1 | xargs) >> "$information_file"

mask=$(ip addr show eth0 | awk 'NR == 3 {print "ip address -" $2}' | cut -d"/" -f2)
power=$(echo $(( 32 - $mask )))
hosts=$(echo $(( ( 2 ** $power ) - 2)))
echo "Number of host on the network : $hosts" >> "$information_file"
```

## Configure nginx

Add upstream directive in http context and and proxy_pass directive in server context in /etc/nginx/nginx.conf:

```bash
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    upstream backend {
	    server 127.0.0.1:80;
	    server 127.0.0.1:81;
    }

    server {
        listen       8080;
        server_name  localhost;

        location / {
	    proxy_pass http://backend;	
            #root   html;
            #index  index.html index.htm;
        }
```

## Test the reverse proxy and load balancing:

Set tcpdump to listen on localhost ports 80 and 81, curl for content from the local machine and stop tcpdump after that:

```bash
sudo tcpdump -i lo port 80 or port 81 -w server/lb.cap

curl 18.193.105.182:8080/info.txt
```

Get the results on your local machine and examine them in Wireshark:

```bash
curl 18.193.105.182:8080/lb.cap --output lb.cap --silent
```
