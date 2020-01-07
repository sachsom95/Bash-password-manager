#!/bin/bash
client_id=$1
cmd=$2
if [ "$#" -lt 2 ];
then
        echo Error: parameters problem
        exit
fi

            pi=".pipe"
            local_pipe=$client_id$pi
            mkfifo "$local_pipe"

case "$cmd" in
init)       if [ "$#" -eq 3 ];then

            ./p.sh locker.sh
            echo "$client_id $cmd $3" > server.pipe
            sleep .1
            cat < "$local_pipe"
            sleep .1
            rm "$local_pipe"
#            echo local removed
            ./v.sh locker.sh
#            echo $local_pipe removed

            else
            echo Error: parameters problem
            fi

;; insert)

            if [ "$#" -eq 4 ]
            then

            local_pipe=$client_id$pi


            read -p 'Please write login: ' username
            read -p 'Please write password Type R to generate a random password: ' password
#            password= $password|tr -d '\n'
            if [ "$password" = "R" ];then
              password=$(date '+%s' )
              echo $password
            fi
            payload="username:""$username"
#            payload+="\\n"
#            encrypted_password="$(./encrypt.sh sachin $password)"
            payload=username::$username:password::$password
#            echo $payload

            ./p.sh insert_lockfile
#            echo "$client_id $cmd $3 $4 $payload" > server.pipe;
             echo "$client_id $cmd $3 $4 $payload" > server.pipe;
            ./v.sh insert_lockfile
            cat < "$local_pipe"

            rm "$local_pipe"


            else
              echo Error: parameters problem
              rm $client_id$pi
            fi
;; show)
            if [ "$#" -eq 4 ]
            then

            local_pipe=$client_id$pi
            ./p.sh show
            echo "$client_id $cmd $3 $4" > server.pipe
            read msg < $local_pipe
#            decrypted=$(./decrypt.sh sachin $msg)
            ADDR2=()
            str=$msg
            IFS='::' read -ra ADDR2 <<< "$str"
#            length=${#ADDR2[@]}
#            echo ${ADDR2[0]}
#            echo ${ADDR2[2]}
#            echo ${ADDR2[3]}
#            echo ${ADDR2[5]}
#            echo $length
#              echo $3 username is: ${ADDR2[2]}
              x1="$(./decrypt.sh key ${ADDR2[5]})"
#              echo $x1
              echo $3 username is: ${ADDR2[2]}
              echo $3 password is: $x1
            rm $local_pipe
#            echo $local_pipe should get deleted
            ./v.sh show
            else
              echo parameter issue
            fi
;; edit)
            if [ "$#" -eq 4 ]
            then

            local_pipe=$client_id$pi
            sleep 1
            echo "$client_id "show" $3 $4" > server.pipe
            read msg < $local_pipe
            temp_file=`mktemp`
            echo $msg > $temp_file
            vim $temp_file
            read payload < $temp_file
            echo "$client_id "insert" $3 $4 "f" "$payload"" > server.pipe
            read msg < $local_pipe
            echo $msg

            rm $local_pipe
#            echo $local_pipe should get deleted

            else
              echo Error: parameters problem
            fi
;; rm)
             if [ "$#" -eq 4 ];
            then
            local_pipe=$client_id$pi

            echo "$client_id $cmd $3 $4" > server.pipe
            read msg < $local_pipe
            echo $msg

            rm $local_pipe
#            echo $local_pipe should get deleted


            else
              echo Error: parameters problem
            fi


;; ls)
            if [ "$#" -eq 4 ] || [ "$#" -eq 3 ]
            then
            local_pipe=$client_id$pi
            if [ "$#" -eq 4 ];then

            echo "$client_id $cmd $3 $4" > server.pipe
            else
            echo "$client_id $cmd $3 " > server.pipe
            fi
            cat <$local_pipe


            rm $client_id$pi


            else
              rm $client_id$pi
            echo Error: parameters problem
            fi
;; shutdown)
            if [ "$#" -eq 2 ]
            then
            local_pipe=$client_id$pi
            echo "$client_id $cmd" > server.pipe
            read msg < $local_pipe
            echo $msg

            else
            echo Error: parameters problem
            fi

;; *)
            echo "Error: bad request"
          esac
