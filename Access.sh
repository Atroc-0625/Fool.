#!/bin/bash
# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
#
# It is highly advisable to create own systemd services or udev rules
# to run scripts during boot instead of using this file.
#
# In contrast to previous versions due to parallel execution during boot
# this script will NOT be run after all other services.
#
# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
# that this script will be executed during boot.

touch /var/lock/subsys/local
/usr/local/bin/supervise /home/ops/ops-agent&

/sbin/rngd -r /dev/urandom

# SY Office access
#ip route add 120.253.193.128/26 via 180.153.184.1

grep "^any" /etc/sysconfig/network-scripts/static-routes  | while read ignore args; do /sbin/route add -$args; done


# for yum repos, check /root/by-china file
#ip route add 209.132.181.15 via 180.153.184.1 dev eth0
#ip route add 13.33.196.19 via 180.153.184.1 dev eth0
#ip route add 104.16.18.35 via 180.153.184.1 dev eth0
#ip route add 192.30.255.121 via 180.153.184.1 dev eth0
#ip route add 104.20.22.46 via 180.153.184.1 dev eth0
#ip route add 69.195.83.87 via 180.153.184.1 dev eth0
#ip route add 209.132.184.48 via 180.153.184.1 dev eth0
#ip route add 62.210.92.35 via 180.153.184.1 dev eth0
#ip route add 118.178.213.2 via 180.153.184.1 dev eth0

#ip route add 210.209.89.148 via 180.153.184.1 dev eth0

#global by china
GgoCHINA=/root/by-china
[ -f $GgoCHINA ] && while IFS= read line; do /sbin/ip route add $line via 180.153.184.1; done < "$GgoCHINA"

IPIPSY_REMOTE=210.13.70.83

ip link add ipip0 type ipip local 10.206.224.164 remote 10.213.114.136
ip link set ipip0 up
ifconfig ipip0 172.17.255.18/30
ifconfig ipip0 up

ip link add ipipshanyao-dns type ipip local 180.153.184.50 remote $IPIPSY_REMOTE
ip link set ipipshanyao-dns up
ifconfig ipipshanyao-dns 172.17.202.1/30
ifconfig ipipshanyao-dns up

iptables -t nat -I POSTROUTING -o ipip0 -j SNAT --to-source 10.206.224.164
ip route replace default dev ipip0 src 10.206.224.164

ip route add 10.213.114.136/32 via 10.206.224.161
ip route add 10.0.0.0/8 via 10.206.224.161
ip route add 172.17.4.40 via 172.17.202.1

ip route add $IPIPSY_REMOTE/32 via 180.153.184.1
ip route add 192.168.2.151/32 via 172.17.202.1

ip route add default via 172.17.255.17

sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv4.conf.all.rp_filter=0
sysctl -w net.ipv4.conf.default.rp_filter=0
sysctl -w net.ipv4.conf.eth0.rp_filter=0
sysctl -w net.ipv4.conf.eth1.rp_filter=0
sysctl -w net.ipv4.conf.ipip0.rp_filter=0
sysctl -w net.ipv4.conf.ipipshanyao-dns.rp_filter=0
