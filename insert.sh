#!/bin/bash
user=$1
service=$2
switch_function=$3
#payload=$4
#encrypted_data="$(./encrypt.sh key $payload)"
#payload="$encrypted_data"
#echo $payload
if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]
then
        echo Error: parameters problem
        exit
fi

       ADDR=()
       str=$service
       IFS='/'
       read -ra ADDR <<< "$str"
       length=${#ADDR[@]}
#       echo $length
#       echo ${ADDR[0]}
#       echo ${ADDR[1]}
payload=$4

if [ $switch_function = "f" ];
then
if [ -d "$user" ];
then

       if [ $length -eq 1 ];
       then
         if [ -f "$user/${ADDR[0]}" ];
         then
#          yes | read encrypted_data | ./encrypt.sh key $payload
#          encrypted_data="$(./encrypt.sh key $payload)"
           echo -e $payload > $user/${ADDR[0]}
           echo OK: service created
           exit
           else
          echo $user/${ADDR[0]}
         touch $user/${ADDR[0]}
         echo $?
         echo -e $payload > $user/${ADDR[0]}
         echo OK: service created
         fi
        elif [ -d "$user/${ADDR[0]}" ];
          then
          touch $user/${ADDR[0]}/${ADDR[1]}
          echo -e $payload > $user/${ADDR[0]}/${ADDR[1]}
          echo OK: service created
          else
#            mkdir here
          mkdir $user/${ADDR[0]}
          touch $user/${ADDR[0]}/${ADDR[1]}
          echo -e $payload > $user/${ADDR[0]}/${ADDR[1]}
          echo OK: service created
      fi



else
        echo Error: user does not exist
fi

elif [ "$#" -eq 3 ];
then
payload=$3
            ADDR1=()
            str1=$payload
            IFS='::' read -ra ADDR1 <<< "$str1"
encrypted_data="$(./encrypt.sh key ${ADDR1[5]})"
test="username::${ADDR1[2]}:password::$encrypted_data"
payload=$test
if [ -d "$user" ];
then

       if [ "$length" -eq 1 ];
       then
         if [ -f "$user/${ADDR[0]}" ];
         then

           echo service already exist
           exit
           else

         touch $user/${ADDR[0]}
         echo -e $payload > $user/${ADDR[0]}
         echo OK: service created
         fi
        elif [ -d "$user/${ADDR[0]}" ];
          then
            if [ -f "$user/${ADDR[0]}/${ADDR[1]}" ];
            then
              echo service already exist
              exit
            fi
          touch $user/${ADDR[0]}/${ADDR[1]}
          echo -e $payload > $user/${ADDR[0]}/${ADDR[1]}
          echo OK: service created
          else
          mkdir $user/${ADDR[0]}
          touch $user/${ADDR[0]}/${ADDR[1]}
          echo -e $payload > $user/${ADDR[0]}/${ADDR[1]}
          echo OK: service created
      fi



else
        echo Error: user does not exist
fi


fi