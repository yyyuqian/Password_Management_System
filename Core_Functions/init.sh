#!/bin/bash
user=$1
if [ $# -ne 1 ]; then
        echo "Error: parameters proble"
elif [ -d "./$user" ] ; then
        echo "Error: user already exist"
else
        ./P.sh $user
        mkdir $user
        sleep 1
        echo "OK: user created"
        ./V.sh $user
fi