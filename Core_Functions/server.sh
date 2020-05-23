#!/bin/bash
#!/bin/bash

mkfifo server.pipe
trap server_shut INT 

# a fuction will execute when hit CTRL+C
function server_shut()
{
echo "Ctrl_c to exit"
rm server.pipe
exit 0
}

while true; do
    read -a arr < server.pipe 
    clientid=${arr[0]}
    command=${arr[1]}
    user=${arr[2]}
    service=${arr[3]}
    playload=${arr[@]:4}
    username=${arr[4]}
    password=${arr[5]}
    case "$command" in
         init)
         {
         ./init.sh $user > $clientid.pipe & 
         } 
         ;;
         insert)
         {
         #echo "$deusername"
         nplayload="${username}\\n${password}"
         #echo "$nplayload"
         ./insert.sh $user $service "" "$nplayload "> $clientid.pipe &
         }
         ;;
         show)
         {
         ./show.sh $user $service>$clientid.pipe &
         }
         ;;
         update)
         {
         echo "Now is update"
             IFS=' ' 
             j=0
             read -a arr <<<${playload}
             for i in "${arr[@]}"; do
                 dearr[${j}]=$(./decrypt.sh "Nowisedit" "$i")
                 (( ++j ))
             done
             echo "plaload is ${playload}"
             nplayload=`echo -n "${arr[@]}"|sed 's/ /\\\n/g'`
	      echo "key is $nplayload"
             ./insert.sh $user $service "f" $nplayload>$clientid.pipe & 
         }
         ;;
         rm)
         {
         ./rm.sh $user $service>$clientid.pipe  & 
         }
         ;;
         ls)
         {
         ./ls.sh $user $service>$clientid.pipe  & 
         }
         ;;
         shutdown)
         {
          echo "Now is shutdown">$clientid.pipe 
          rm server.pipe
          exit 0
         }
         ;;
         *)
         {
         echo "$command"
         echo "Error: bad request!!!"
         rm server.pipe
         exit 1
         }
         
    esac
done
