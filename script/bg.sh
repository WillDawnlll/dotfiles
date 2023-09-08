#!/usr/bin/env bash

jq=/usr/bin/jq
wget=/usr/bin/wget

image_folder_path="/home/$USER/Documents/Images/Bing/"
mkdir -p $image_folder_path

num=9
i=0
#Get Bing Image JSON
url="http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=$num&mkt=en-US"
echo $url
echo ""
json=$(curl $url)
echo $json

until [ $i -ge $num ]
do
    #Parse Json to get image_address and hash using jq
    image_address="http://www.bing.com$(echo $json | $jq ".images[$i].url" | sed -e 's/^"//'  -e 's/"$//')"
    image_name=$(echo "$json" | $jq ".images[$i].hsh" | sed -e 's/^"//'  -e 's/"$//')
    image_copyright=$(echo "$json" | $jq ".images[$i].copyright" | sed -e 's/^"//'  -e 's/"$//')

    #Image Path
    image_file_address=$image_folder_path$image_name

    #Check image existance
    if [ -e "$image_file_address" ]; then
        echo "File $i exists, Cancel progress."
    else
        echo "File $i does not exist, Download it."
    fi

    #Download image
    $wget -O $image_file_address $image_address
    ((i++))
done

#set image as background
#GNU/Linux
#gsettings set org.gnome.desktop.background picture-uri "file://$image_file_address"
#notify-send "New background :)" "$image_copyright"
feh --bg-fill $image_file_address
echo "feh $image_file_address"

