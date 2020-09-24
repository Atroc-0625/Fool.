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

# grep "^any" /etc/sysconfig/network-scripts/static-routes  | while read ignore args; do /sbin/route add -$args; done

ip link add ipip0 type ipip local 10.213.114.136 remote 10.206.224.164
ip link set ipip0 up
ifconfig ipip0 172.17.255.17/30
ifconfig ipip0 up

#ip link del ipipshanyao
ip link add ipipshanyao type ipip local 180.153.184.69 remote 210.13.70.83
ip link set ipipshanyao up
ifconfig ipipshanyao 172.16.201.1/30
ifconfig ipipshanyao up

ip route add 10.206.224.164/32 via 10.213.114.129
ip route add 10.0.0.0/8 via 10.213.114.129
ip route add 172.17.2.0/24 via 172.16.201.2

ip rule add from all iif ipip0 lookup 10
ip route add default via 172.16.201.2 table 10

ip rule add from all iif ipipshanyao lookup 2
ip route add table 2 0.0.0.0/0 via 172.17.255.18

ip route add 210.209.89.148 via 172.16.201.2
ip route add 103.15.180.227 via 172.16.201.2 dev ipipshanyao

sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv4.conf.all.rp_filter=0
sysctl -w net.ipv4.conf.default.rp_filter=0
sysctl -w net.ipv4.conf.eth0.rp_filter=0
sysctl -w net.ipv4.conf.eth1.rp_filter=0
sysctl -w net.ipv4.conf.ipip0.rp_filter=0
sysctl -w net.ipv4.conf.ipipshanyao.rp_filter=0

# for local net tracking
ip route add 8.8.8.8/32 via 172.16.201.2
ip route add 8.8.4.4/32 via 172.16.201.2

ip route add 203.84.157.10 via  172.16.201.2 dev ipipshanyao

iptables -t nat -A POSTROUTING  -o ipipshanyao -j MASQUERADE
