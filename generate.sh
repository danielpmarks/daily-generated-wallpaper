#! /bin/bash

cd $(dirname "$0")
DIRECTORY=$(pwd)

# Get the name of the directory for today's wallpaper
DATE=$(date '+%Y-%m-%d')

# Gets the path to the current wallpaper
CUR_WALLPAPER_PATH=$(sqlite3 -readonly ~/Library/Application\ Support/Dock/desktoppicture.db \
    'SELECT * FROM data ORDER BY rowID DESC LIMIT 1;')

# Get the length of the string
length=${#CUR_WALLPAPER_PATH}

# Calculate the position to start from
start=$((length - 44))

# Save the relative path for setting the wallpaper later
CUR_WALLPAPER_REL_PATH="${CUR_WALLPAPER_PATH:0:start}"

# Get the relative path from the wallpaper directory, assuming the image's relative path is "generated/Wallpaper_YYYY-MM-DD"
CUR_WALLPAPER="${CUR_WALLPAPER_PATH: -44}"

# Today's wallpaper
TODAY_DIR="generated/Wallpaper_$DATE"


if [[ "$CUR_WALLPAPER" != "$TODAY_DIR/wallpaper.png" ]]; 
then
    if [ ! -d "$DIRECTORY/$TODAY_DIR/" ];
    then
        # Figure out the right command for python and pip
        python_cmd=python
        python_path=$(which python)
        if [ "$python_path" == "" ];
        then
            python_cmd=python3
            python_path=$(which python3)
            if [ "$python_path" == "" ];
            then
                echo "Pip install not found. Please install pip or pip3 then rerun the script."
                exit
            fi
        fi

        pip_cmd=pip
        pip_path=$(which pip)
        if [ "$pip_path" == "" ];
        then
            pip_cmd=pip3
            pip_path=$(which pip3)
            if [ "$pip_path" == "" ];
            then
                echo "Pip install not found. Please install pip or pip3 then rerun the script."
                exit
            fi
        fi

        # Add python to path variables
        # install python packages
        INSTALLED=$($pip_cmd show requests)
        if [ INSTALLED ==  "WARNING: Package(s) not found: requests" ];
        then
            $pip_cmd install requests
        fi

        INSTALLED=$($pip_cmd show openai)
        if [ INSTALLED ==  "WARNING: Package(s) not found: openai" ];
        then
            $pip_cmd install openai
        fi
        
        $pip_cmd install python-dotenv

        # generate a new image
        $python_cmd wallpaper.py
    fi
    # set the desktop wallpaper
    osascript -e "tell application \"System Events\" to set picture of desktop 1 to \"$CUR_WALLPAPER_REL_PATH$TODAY_DIR/wallpaper.png\""
fi

