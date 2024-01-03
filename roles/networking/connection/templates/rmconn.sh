#!/bin/sh

sleep 30

/usr/bin/nmcli connection down {{ net_interface }}      > /dev/null 2>&1
/usr/bin/nmcli connection down "Wired connection 1"     > /dev/null 2>&1
/usr/bin/nmcli connection down {{ conn_name }}          > /dev/null 2>&1
/usr/bin/nmcli connection up   {{ conn_name }}          > /dev/null
