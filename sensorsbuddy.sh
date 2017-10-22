#!/bin/bash


CLEVO_PATH="/usr/local/bin/clevo-indicator"
/usr/sbin/modprobe ec_sys

while true; do
    current_temp_float=$(/usr/bin/sensors -u  2> /dev/null| grep 'Package id 0' -A1 | grep -o '[0-9]*\.[0-9]*') 
    current_temp=${current_temp_float/.*}

    if [ $current_temp -le 60 ]; then
      level_f=$(echo "0.5*$current_temp" | bc -l)
    elif [ $current_temp -le 65 ]; then
      level_f=$(echo "0.75*$current_temp" | bc -l)
    else
      level_f=$(echo "$current_temp+15" | bc -l)
    fi

    level=${level_f/.*}
    echo " $current_temp, $level"
    $CLEVO_PATH $level &> /dev/null

    sleep 2
done
