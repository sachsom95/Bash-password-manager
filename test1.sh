#!/bin/bash

echo "this is output from test1"
#mkfifo test_pipe
if [ -p "test_pipe" ];
then
  echo y
fi
