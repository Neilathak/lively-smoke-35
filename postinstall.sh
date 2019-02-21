#!/usr/bin/env bash

hst=($hostname -s)

if [ ${hst} = "nginx-lb-*" ]; then 
    echo "Yep, that is the hostname"
else
    echo "Nope, not working"
fi

if [ ${hst} = "web-*" ]; then 
    echo "Yep, that is the hostname"
else
    echo "Nope, not working"
fi