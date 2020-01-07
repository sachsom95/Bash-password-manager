#!/bin/bash
user=$1
folder=$2
echo "$#"
ADDR=()
       str=$folder
       IFS='/'
       read -ra ADDR <<< "$str"

if [ "$#" -gt 2 ];
then
  echo Error: parameters problem
  exit
fi


if [ "$#" -eq 1 ];
then
  if [ -d $user ];
 then
  tree -a $user
  else
    echo Error: user does not exist
    fi
elif [ "$#" -eq 2 ];
then
  if [ -d "$user/${ADDR[0]}" ];
  then
    tree $user/${ADDR[0]}
    else
      echo Error: folder does not exist
      fi
      fi