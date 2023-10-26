#!/bin/bash

loop=50000
count=0
num=698394
suffix=94
datetime=$(date +'%Y%m%d_%H%M%S')
output_file="10L_OTA_$datetime.txt"

while [ $count -lt $loop ]
do
    printf -v padded_num "%06d" $num
    printf -v padded_suffix "%02d" $suffix
    url="https://g2slave-ap-north-01.tclcom.com/36046b76899adec0492c04ad334c70b178def47a/${padded_suffix}/${padded_num}"

    content_length=$(curl -m 50 -sI "$url" | awk 'BEGIN {IGNORECASE = 1} /Content-Length/ {print $2}' | tr -d '\r')
    if [ -z "$content_length" ]; then
        echo "404 Not Found $suffix/$num"
    else
        content_length_mb=$((content_length/1024/1024))
        echo "URL: $suffix/$num, Size: ${content_length_mb} MB"
        echo "wget $url" >> "$output_file"
        echo "Size: ${content_length_mb}MB" >> "$output_file"
    fi

    if [ "$suffix" -eq 99 ]; then
        suffix=0
    else
        ((suffix++))
    fi

    if [ "$num" -eq 999999 ]; then
        num=834115
    else
        ((num++))
    fi

    ((count++))
done

# Prompt for user input to continue or exit
read -p "Press Enter to quit: " input
if [ "$input" == "exit" ]; then
    break
fi
