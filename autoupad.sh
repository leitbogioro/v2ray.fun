#!/bin/bash
h2yfile="/usr/bin/v2ray/h2y.dat"
service v2ray stop
if [ -f ${h2yfile} ]; then
    rm -rf ${h2yfile}
fi
wget https://raw.githubusercontent.com/ToutyRater/V2Ray-SiteDAT/master/geofiles/h2y.dat
mv h2y.dat ${h2yfile}
service v2ray start
