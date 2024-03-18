#!/bin/bash

cd $(dirname "$0")
directory=$(pwd)

# Check that the user has python and pip installed
python_path=$(which python)
if [ "$python_path" == "" ];
then
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
            read -p "It looks like the program has already been set up. Would you like to override your current config? [y/N] " yn
            case $yn in
                [Yy]* ) return 0;;  # If user input starts with 'y' or 'Y', return true (0)
                [Nn]* ) return 1;;  # If user input starts with 'n' or 'N', return false (1)
                * ) echo "Please answer yes or no.";;
            esac
        done
    
}

if [ -e ".env" ];
then
    if ! get_confirmation; then
        exit
    fi
fi

read -p "Please enter your OpenAI API key: " apiKey
echo "API_KEY=\"$apiKey\"" > .env
echo "DIRECTORY=\"$directory/\"" >> .env

echo "Please add the following string to your crontab via 'crontab -e':"
echo "* * * * * export PATH=\$PATH:$pip_path; $directory/generate.sh;"
