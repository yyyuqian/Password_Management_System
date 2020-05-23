#!/bin/bash
user=$1
service=$2
override=$3
playload=${4}

# echo $1
# echo $2
# echo $3
#echo "$playload"
if [ $# -ne 4 ]; then
        echo "Error: parameters proble"
    elif [ -d "./$user" ] ; then
     ./P.sh $user
     sleep 2
        if [[ "$service" = *"/"* ]]; then
                A="$(cut -d '/' -f1 <<<"$2")"
                B="$(cut -d '/' -f2 <<<"$2")"
                if [  -f "./$user/$A/$B" ] && [ "$override" = "" ];then
                    echo "Error: service already exis"
                elif [ -f "./$user/$A/$B" ] && [ "$override" = "f" ]; then
                    echo "$playload">"$user"/"$A"/"$B"

                    echo "OK: service update"
                else
                    mkdir -p "$user"/"$A"
                    touch "$user"/"$A"/"$B"
                    echo "$playload">>"$user"/"$A"/"$B"
                    echo "OK: service create"
                 fi
        else 
            if [ -f "./$user/$service" ] && [ "$override" = "" ]; then
                echo "Error: service already exis"
            elif [ -f "./$user/$service" ] && [ "$override" = "f" ]; then
                 echo "$playload">$user/$service
                 echo "OK: service update"
            else
             touch $user/$service
             echo "$playload"> $user/$service
             echo "OK: service create"
             fi
         fi  
     ./V.sh $user
    else
        echo " Error: user does not exis"
  
fi
