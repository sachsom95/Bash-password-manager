#!/bin/bash
user=$1
service=$2

if [ "$#" -ne 2 ];
then
  echo Error: parameters problem
  exit
fi

if [ -d "$user" ];
then

       ADDR=()
       str=$service
       IFS='/'
       read -ra ADDR <<< "$str"
       length=${#ADDR[@]}
       if [ $length -eq 1 ];
       then
         if [ -f "$user/${ADDR[0]}" ];
         then
           rm $user/${ADDR[0]}
           echo OK: service removed
           exit
           else
         echo Error: user does not exist
         fi
        elif [ -d "$user/${ADDR[0]}" ];
          then
          rm $user/${ADDR[0]}/${ADDR[1]}
          echo OK: service removed
          else

          echo Error: user does not exist
      fi



else
        echo Error: user does not exist
fi


