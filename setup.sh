#!/bin/bash

cd $(dirname "$0")
directory=$(pwd)

# Check that the user has python and pip installed
python_path=$(which python)
if [ "$python_path" == "" ];
then
    echo "TEST"
    python_path=$(which python3)
    if [ "$python_path" == "" ];
    then
        echo "Pip install not found. Please install pip or pip3 then rerun this setup script."
    fi
fi
pip_path=$(which pip)
if [ "$pip_path" == "" ];
then
    pip_path=$(which pip3)
    if [ "$pip_path" == "" ];
    then
        echo "Pip install not found. Please install pip or pip3 then rerun this setup script."
    fi
fi

get_confirmation() {
        while true; do
            local message="$1"
            read -p "$message" yn
            case $yn in
                [Yy]* ) return 0;;  # If user input starts with 'y' or 'Y', return true (0)
                [Nn]* ) return 1;;  # If user input starts with 'n' or 'N', return false (1)
                * ) echo "Please answer yes or no.";;
            esac
        done
    
}

if [ -e ".env" ];
then
    message="It looks like the program has already been set up. Would you like to override your current config? [y/N] "
    if ! get_confirmation "$message"; then
        exit
    fi
fi

read -p "Please enter your OpenAI API key: " apiKey
echo "API_KEY=\"$apiKey\"" > .env
echo "DIRECTORY=\"$directory/\"" >> .env

echo "Please accept permission to edit automation on your mac"
cron_job="* * * * * export PATH=\$PATH:$pip_path; $directory/generate.sh;"

if crontab -l | grep -q "$cron_job"; then
    echo "The cron job already exists in the crontab."
else 
    echo "$cron_job" | crontab -
fi

message="You must enable cron to access system events to run automation. Continue to System Preferences? [y/N] " 
if get_confirmation "$message"; then
    open "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation"
fi