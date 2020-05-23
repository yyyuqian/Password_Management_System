#!/bin/bash
user=$1
service=$2
if [ $# -ne 2 ]; then
        echo "Error: parameters proble"
    elif [ -d "./$user" ] ; then
     ./P.sh $user
     sleep 2
            if [ -f "$user/$service" ]; then
             filedir=`cat $user/$service`
             echo -e "$filedir"
            else
             echo "Error: service does not exit"
             fi
     ./V.sh $user
    else
        echo " Error: user does not exis"
fi