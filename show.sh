#!/bin/bash
user=$1
service=$2
ADDR=()
       str=$service
       IFS='/'
       read -ra ADDR <<< "$str"
       length=${#ADDR[@]}
#        echo $length
#        echo "$#"
if [ "$#" -eq 1 ];
then
     ADDR1=()
       str1=$user
       IFS='/'
       read -ra ADDR1 <<< "$str1"

    if [ -d ${ADDR1[0]} ];
 then

   if [ -f ${ADDR1[0]}/${ADDR1[1]} ];
  then

    cat "${ADDR1[0]}/${ADDR1[1]}"
  else
    echo Error: service does not exist
  fi
  else
    echo Error: user does not exist
    fi
  fi

if [ "$#" -eq 2 ];
then
    if [ -d $user ];
    then
      if [ -f $user/${ADDR[0]} ];
      then
        cat $user/${ADDR[0]}
        exit
      fi
      if [ -d $user/${ADDR[0]} ];
      then
        if [ -f $user/${ADDR[0]}/${ADDR[1]} ];
        then
        cat $user/${ADDR[0]}/${ADDR[1]}
      else
        echo Error: service does not exist
      fi
      else
    echo Error: service does not exist
    fi
    else
    echo Error: user does not exist
fi



fi
