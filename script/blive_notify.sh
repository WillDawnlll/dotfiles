#!/bin/sh

# https://github.com/SocialSisterYi/bilibili-API-collect

sleep_time=10*60
room_id=7777
#room_id=24678311
while :
do
    binfo=$(curl -s "https://api.live.bilibili.com/room/v1/Room/get_info?room_id=${room_id}")
    bstatus=$(echo $binfo|sed 's/[{},]/\n/g'|grep live_status\":1)
    is_live=$?
    if [ $is_live -eq 0 ]
    then
        btime=$(echo $binfo|sed 's/[{},]/\n/g'|grep "live_time.*")
        #cmd notification post -S bigtext ${room_id} ${btime}
        notify-send ${room_id} "${btime}" -t 10000 -u normal
        exit
    else
        sleep $sleep_time
    fi
done


