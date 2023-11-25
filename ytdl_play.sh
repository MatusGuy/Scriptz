#!/bin/sh

echo "ytdl_play.sh [url|query]"
echo
echo "You can use this to play youtube on stupidly low-powered computers"
echo

if [[ -z $1 ]]
then
    exit 1
fi

function dlp {
    # arguments = arguments to ytdlp

    cmd="/usr/bin/python -m yt_dlp $@ --no-warnings"
    # check if python exists
    python -V > /dev/null
    if [[ $? -gt 0 ]]; then
        echo "python is not installed. use your package manager to install it."
        exit 1
    fi
    # check if the module exists
    python -c 'import importlib.util; print(1 if importlib.util.find_spec("yt_dlp") else 0)'
    if [[ $? -gt 0 ]];
        echo "yt_dlp is not installed in this environment; run 'pip install yt_dlp' to install it"
        exit 1
    fi
    
    >&2 echo "$ $cmd"
    $cmd
}

function get_dlp_url {
    # args:
    # 1 = url/query
    # 2 = search count (if query)
    #
    # output:
    # dlp url (normal url if 1 is url, ytsearch$2:$1 if is query
    #
    # return code:
    # 1 = query
    # 0 = url

    >&2 echo "get_dlp_url $1 $2"

    if [[ ! $1 = https://* ]]; then
        if [[ $1 = ytsearch* ]]; then
            # already ytsearch
            echo $1
            exit 1
        fi

        echo ytsearch$2:$1
        exit 1
    fi

    echo $1
    exit 0
}

function get_vid_title {
    # 1 = url/query
    # 2 = count

    >&2 echo "get_vid_title $1 $2"

    count=$2
    if [[ -z $2 ]]; then
        count=1
    fi

    dlp "$(get_dlp_url "$1" $count)" --get-title
}

function get_vid_url {
    # 1 = title

    >&2 echo "get_vid_url $1"

    vidid=$(dlp "$(get_dlp_url "$1")" --get-id)
    if [ ! $? -eq 0 ]; then
        code=$?
        echo
        exit $code
    fi
    echo "https://youtube.com/watch?v=$vidid"
}

function dlplay {
    # 1 = url
    # 2 = title

    >&2 echo "dlplay $1 $2"

    vidtitle="$2"

    if [[ -z $2 ]]; then
        vidtitle=$(get_vid_title "$1")
    fi

    outpath="$HOME/ytdl_play_vids/$(echo ${vidtitle// /_}).mp4"
    dlp "$1" -o "$outpath" -S res:480p -f mp4

    if [ ! $? -eq 0 ]; then
        exit $?
    fi

    xdg-open "$outpath" > /dev/null &
}

url=$(get_dlp_url "$1" 9)

if [ $? -eq 0 ]; then
    echo "URL detected. Downloading & playing."
    dlplay "$1"
    exit 0
fi

echo "Searching..."

vidsdlp=$(get_vid_title "$url")

if [ ! $? -eq 0 ]; then
    exit $?
fi

readarray -t vids <<< $vidsdlp

echo "Found:"
for i in "${!vids[@]}"; do
    echo "$(($i+1)) | ${vids[$i]}"
done

echo
echo "Select:"
read -n 1 selection
echo
vid=$(($selection-1))
vidtitle="${vids[$vid]}"
dlplay "$(get_vid_url "$vidtitle")" "$vidtitle"
