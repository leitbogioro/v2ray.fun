#!/bin/bash
h2yfile="/usr/bin/v2ray/h2y.dat"
v2ray_log="/var/log/v2ray"

service v2ray stop

if [ -f ${h2yfile} ]; then
    rm -rf ${h2yfile}
fi
wget https://raw.githubusercontent.com/ToutyRater/V2Ray-SiteDAT/master/geofiles/h2y.dat
mv h2y.dat ${h2yfile}

if [ -f ${v2ray_log} ]; then
    rm -rf ${v2ray_log}
    mkdir ${v2ray_log}
fi

service v2ray start
