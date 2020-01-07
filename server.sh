#!/bin/bash
pi=".pipe";

if [ -p $server.pipe ]
then
  :
else
    mkfifo server.pipe
fi

sleep .2
while true; do
  sleep .5
  read var < server.pipe
  echo $var
  sleep .5
  echo $var
       ADDR=()
       str=$var
       IFS=' '
       read -ra ADDR <<< "$str"
       length=${#ADDR[@]}

case "${ADDR[1]}" in
init)
            echo came to init
            if [ "$length" -eq 3 ];
            then
            echo inside the condition
            local_pipe=${ADDR[0]}$pi
            echo $local_pipe
            echo ${ADDR[2]}

             ./init.sh ${ADDR[2]} > $local_pipe &

            else
              echo Error: parameters problem

            fi
;; insert)
            local_pipe=${ADDR[0]}$pi

            if [ "$length" -eq 5 ] || [ "$length" -eq 4 ] || [ "$length" -eq 6 ];
            then
              echo ${ADDR[2]}
              echo ${ADDR[3]}
              echo ${ADDR[4]}
            ./p.sh insert.sh
            if [ "$length" -eq 6 ]
            then
            ./insert.sh  ${ADDR[2]} ${ADDR[3]} ${ADDR[4]} ${ADDR[5]}> $local_pipe &
            ./v.sh insert.sh
            elif [ "$length" -eq 5 ]; then
            ./insert.sh  ${ADDR[2]} ${ADDR[3]} ${ADDR[4]} > $local_pipe &
            ./v.sh insert.sh
            fi

            else
              echo Error: parameters problem
            fi
;; show)
#            echo came to show
#            echo $length
            local_pipe=${ADDR[0]}$pi
            if [ "$length" -eq 4 ]
            then

             ./show.sh ${ADDR[2]} ${ADDR[3]} > $local_pipe &
#             echo execute show arguments ${ADDR[2]} ${ADDR[3]}
            else
              echo Error: parameters problem
            fi
;; update)
#            echo came to show
#            echo $length
            local_pipe=${ADDR[0]}$pi
            if [ "$length" -eq 4 ]
            then

             ./show.sh ${ADDR[2]} ${ADDR[3]} > $local_pipe &
             echo execute show arguments ${ADDR[2]} ${ADDR[3]}
            else
              echo Error: parameters problem
            fi
;; rm)
            echo came to rm
            echo $length
            local_pipe=${ADDR[0]}$pi

            if [ "$length" -eq 4 ];
            then
            ./remove.sh ${ADDR[2]} ${ADDR[3]} > $local_pipe &
            echo execute arguments ${ADDR[2]} ${ADDR[3]}
            else
              echo Error: parameters problem
            fi
;; ls)
  echo $length
            if [ "$length" -eq 3 ] || [ "$length" -eq 4 ]
            then
            echo came to ls inside
            local_pipe=${ADDR[0]}$pi

            ./ls.sh ${ADDR[2]} ${ADDR[3]}>$local_pipe &
            ./ls.sh ${ADDR[2]} ${ADDR[3]}

            else
              echo Error: parameters problem
            fi
;; shutdown)
            local_pipe=${ADDR[0]}$pi
            echo shutting down > $local_pipe &
            exit 1
;; *)
            echo "Error: bad request"
#            echo $var
          esac
done