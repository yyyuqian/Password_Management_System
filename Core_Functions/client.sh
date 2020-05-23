#!/bin/bash
#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Error: parameters problem"
else
    clientid=$1
    request=$2
    args="${@:3}"
    mkfifo $clientid.pipe
    trap client_shut INT 
    function client_shut()
    {
    echo "Ctrl_c to exit"
    rm $clientid.pipe
    exit 0
    } 
    echo "Welcome to the client side!"
    case "$request" in
     init)
     echo "client side OK!"
     if [ $# -ne 3 ]; then
         echo "Error: parameters problem"
     else
     echo "$clientid $request $args">server.pipe
     cat $clientid.pipe
     rm $clientid.pipe
     echo 
     fi
     exit 0
     ;;
     insert)
     if [ $# -ne 4 ]; then
         echo "Error: parameters problem"          
     else
     read -p "Please write login:" username
     read -p "Please write password, if you want to get a random password, enter R:" password  
     if [ "$password" = "R" ]; then
         password=`date +%s%N | md5 | head -c 10`
     fi
     enusername=$(./encrypt.sh "yuqian" "longin:$username")
     enpassword=$(./encrypt.sh "yuqian" "password:$password")  
     #echo "$enusername"
     echo "$clientid $request $args $enusername $enpassword">server.pipe
     cat $clientid.pipe
     rm $clientid.pipe    
     fi
     exit 0
     ;;
     show)
     if [ $# -ne 4 ]; then 
        echo "Error: parameters problem"
     else
     echo "start show process"
     echo "$clientid $request $args">server.pipe
     while read -r lines;do
         if [[ "$lines" =~ "Error" ]]; then
             echo "There is an error with directory or file"
         else
         enlines=$(./decrypt.sh "yuqian" "$lines")
         key="$(cut -d ':' -f1 <<<"$enlines")"
         value="$(cut -d ':' -f2 <<<"$enlines")"
         echo "$3's $key for $4 is: $value"
         fi
     done <"$clientid.pipe"
     rm $clientid.pipe
     fi
     exit 0
     ;;
     ls)
     if [ $# -ne 3 ] && [ $# -ne 4 ]; then
     echo "Error: parameters problem"
     else
     echo "start list process"
     echo "$clientid $request $args">server.pipe
     cat $clientid.pipe
     rm $clientid.pipe
     fi
     exit 0
     ;;
     edit)
     echo "Now is editting"
     { 
     if [ $# -eq 4 ]; then
     retrieve="$clientid show $args"
     echo -e "${retrieve}">server.pipe
     temp_file=`mktemp $clientid.temp.XXXX.txt`
     read -r line1<$clientid.pipe
     echo "$line1">>"$temp_file" 
     read -r line2<$clientid.pipe
     echo "$line2">>"$temp_file"
             
     rm $clientid.pipe
     vim "$temp_file"
     mkfifo $clientid.pipe 
     i=0
     while read line; do
         #if [[ "$line" =~ "password" ]] || [[ "$line" =~ "login" ]]; then
         #    enarr[${i}]=$(./encrypt.sh "yuqian" "$line")
          #   (( ++i ))
         #fi
         enarr[${i}]=$(./encrypt.sh "yuqian" "$line")
         (( ++i ))
     done <"$temp_file"
     echo "$clientid update $args ${enarr[@]}">server.pipe
     rm "$temp_file"
     cat $clientid.pipe
     rm $clientid.pipe
     else
     echo "Error: parameters problem"
     fi
     exit 0
     }
     ;;
     rm)
     if [ $# -eq 4 ]; then
         echo "$clientid $request $args">server.pipe
         cat $clientid.pipe
         rm $clientid.pipe
     else
     echo "Error: parameters problem"
     fi
     exit 0
     ;;
     shutdown)
     echo "$clientid $request">server.pipe
     cat $clientid.pipe
     rm $clientid.pipe
     echo "client side is shutdown"
     exit 0
     ;;
     *)
     echo $request
     echo "Error: bad request"
     rm $clientid.pipe
     exit 1
    esac
fi
