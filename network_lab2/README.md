# Network lab2

## Run script "net_lab2.sh" to start launch python3 http server and gather information
```bash
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
```

## Install nginx on ec2

```bash
sudo amazon-linux-extras enable nginx1
yum install -y nginx
sudo yum install -y nginx
nginx -v
```

## Configure nginx

Change nginx configuration to listen from port 80 to port 8080 by editing /etc/nginx/nginx.conf:

```bash
listen       8080;
listen       [::]:8080;
```

Add the proxy_pass statement in /etc/nginx/nginx.conf for the backend server:

```bash
	location /server {
		proxy_pass http://localhost:80;
	}
```

Configuration snippet how it should look like:

```bash
server {
        listen       8080;
        listen       [::]:8080;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

	location /server {
		proxy_pass http://localhost:80;
	}
        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```

Test the configuration and enable the service:

```bash
sudo nginx -t
sudo systemctl enable --now nginx.service
```

## Test the reverse proxy

Set tcpdump to listen on localhost port 80, curl for content from the local machine and stop tcpdump after that:

```bash
sudo tcpdump -i lo port 80 -s 65535 -w /home/ec2-user/server/rev_proxy.cap
curl 18.193.105.182:8080/server/info.txt
```

Get the results on your local machine and examine them in Wireshark:

```bash
curl 18.193.105.182:8080/server/rev_proxy.cap --output rev_proxy.cap --silent
```
