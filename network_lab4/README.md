# Networking lab 4:
# Create two network namespaces ns A and ns B in the 192.168.100.0/28 and 192.168.200.0/28 address.<br/>
# Add a veth pair in each of the namespaces connecting to the default namespace.<br/>
# Enable routing in the linux kernel and show that there is reachability between NS A and NS B.<br/>

## Creating network namespaces:

```bash
ip netns add A
ip netns add B
```

## Creating veth devices pairs:

```bash
ip link add vethA type veth peer name veth0
ip link add vethB type veth peer name veth1
```

## Setting veth devices to namespaces, setting ip address and bringing the devices up:

```bash
ip link set veth0 netns A
ip link set veth1 netns B
ip addr add 192.168.100.1/28 dev vethA
ip addr add 192.168.200.1/28 dev vethB
ip netns exec A ip addr add 192.168.100.2/28 dev veth0
ip netns exec B ip addr add 192.168.200.2/28 dev veth1
ip link set vethA up
ip link set vethB up
ip netns exec A ip link set veth0 up
ip netns exec B ip link set veth1 up
```

## Final results and connectivity:

```bash
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 06:38:38:2b:e8:c2 brd ff:ff:ff:ff:ff:ff
    inet 172.31.44.97/20 brd 172.31.47.255 scope global dynamic eth0
       valid_lft 2431sec preferred_lft 2431sec
    inet6 fe80::438:38ff:fe2b:e8c2/64 scope link 
       valid_lft forever preferred_lft forever
14: vethA@if13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 52:a5:ac:2d:2b:55 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.100.1/28 scope global vethA
       valid_lft forever preferred_lft forever
    inet6 fe80::50a5:acff:fe2d:2b55/64 scope link 
       valid_lft forever preferred_lft forever
16: vethB@if15: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 12:20:ea:f1:c6:44 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet 192.168.200.1/28 scope global vethB
       valid_lft forever preferred_lft forever
    inet6 fe80::1020:eaff:fef1:c644/64 scope link 
       valid_lft forever preferred_lft forever

1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
13: veth0@if14: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether d2:03:86:cf:68:67 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.100.2/28 scope global veth0
       valid_lft forever preferred_lft forever
    inet6 fe80::d003:86ff:fecf:6867/64 scope link 
       valid_lft forever preferred_lft forever

1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
15: veth1@if16: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether aa:1b:ab:1f:d2:57 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.200.2/28 scope global veth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a81b:abff:fe1f:d257/64 scope link 
       valid_lft forever preferred_lft forever
```

```bash
ip netns exec B ping -c 1 192.168.100.2
```

```bash
PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
64 bytes from 192.168.100.2: icmp_seq=1 ttl=63 time=0.026 ms

--- 192.168.100.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.026/0.026/0.026/0.000 ms
```

```bash
ip netns exec A ping -c 1 192.168.200.2
```

```bash
PING 192.168.200.2 (192.168.200.2) 56(84) bytes of data.
64 bytes from 192.168.200.2: icmp_seq=1 ttl=63 time=0.047 ms

--- 192.168.200.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.047/0.047/0.047/0.000 ms
```
