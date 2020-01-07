#!/bin/bash
user=$1
number=$#

if [ $number -lt 1 ];
then
        echo Error: parameters problem
        exit
fi
        ./p.sh "$user"
if [ -d "$user" ];

then
        echo Error: user already exists
        ./v.sh "$user"
        exit
else
        mkdir $user
        echo OK: user created
       ./v.sh "$user"
fi
