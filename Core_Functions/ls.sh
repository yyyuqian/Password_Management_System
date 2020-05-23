#!/bin/bash
user=$1
folder=$2
#echo "$folder $#"

if [ $# -ne 2 ] && [ $# -ne 1 ] ; then
        echo "Error: parameters proble"
    elif [ -d ./"$user" ] ; then
        if [ $# -eq 1 ]; then
             ./P.sh $user
             echo "OK:"
             tree --noreport $user
             ./V.sh $user
             fi
         if [ $# -eq 2 ]; then
            if [ -d "$user"/"$folder" ] || [ -f "$user"/"$folder" ]; then
             ./P.sh $user
             echo "OK:"
             cd $user
             tree --noreport "$folder"
             cd ..
             ./V.sh $user
            else
             echo "Error: folder does not exit"
             fi
         fi
    else
        echo " Error: user does not exis"
fi