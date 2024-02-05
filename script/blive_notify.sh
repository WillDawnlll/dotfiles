#!/bin/sh

# https://github.com/SocialSisterYi/bilibili-API-collect

sleep_time=60
room_id=7777
#room_id=24678311
while :
do
    bdate=$(LANG=zh_CN.UTF-8 date)
    binfo=$(curl -s "https://api.live.bilibili.com/room/v1/Room/get_info?room_id=${room_id}")
    btime=$(echo $binfo|sed 's/[{},]/\n/g'|grep "live_time.*")
    bstatus_1=$(echo $binfo|sed 's/[{},]/\n/g'|grep "live_status\":.")
    bstatus=$(echo $bstatus_1|grep live_status\":1)
    is_live=$?

    blog="${room_id} ${bdate} ${btime} ${bstatus_1}"
    if [ $is_live -eq 0 ]
    then
        curl -d "$blog" "ntfy.sh/blive${room_id}"
        if [ -n "${ANDROID_DATA}" ];
        then
            rish -c "cmd notification post -S bigtext -t ${room_id} blive ${blog}"
        else
            notify-send ${room_id} "${blog}" -t 10000 -u normal
        fi
        exit
    else
        #curl -d "NO $blog" "ntfy.sh/blive${room_id}"
        echo "LOG: $blog"
        sleep $sleep_time
    fi
done


