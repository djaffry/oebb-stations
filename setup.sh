#!/usr/bin/env bash

echo ""
echo "#############################"
echo "#                           #"
echo "#     ÖBB Station Setup     #"
echo "#                           #"
echo "#############################"

echo ""
echo "### checking system dependencies ###"

if ! hash python3 2>/dev/null; then
    install_msg="$install_msg\n python3:"
    install_msg="$install_msg\n\t required for executing"
fi

satisfied_msg="all system dependencies"

if ! hash dpkg 2>/dev/null; then
    sleep 0.5
    echo -e "dpkg not installed. Probably not running Raspbian..."
    echo -e "dpkg:"
    echo -e "\t used to check if package python3-venv is installed."
    sleep 1
    echo >&2 -e "\nPlease install python3-venv before continuing!"

    check=true
    while ${check}; do
        sleep 1
        echo "continue? y/n"
        read yn
        case ${yn} in
            [Yy]* ) check=false; satisfied_msg="$satisfied_msg probably";;
            [Nn]* ) check=false; echo >&2 -e "Exiting..."; exit;;
        esac
    done

else
    if ! dpkg -s python3-venv > /dev/null 2>&1; then
        install_msg=" python3-venv:"
        install_msg="$install_msg\n\t required for creating python3 virtual environments"
    fi
fi

if [[ -z ${install_msg} ]]; then
    echo "$satisfied_msg satisfied! Proceeding..."
else
    if hash apt 2>/dev/null; then
        # if apt exists, install required packages
        echo "Installing python3 python3-venv"
        sudo apt update && sudo apt upgrade -y # update to latest  packages
        if ! sudo apt install python3 python3-venv; then
        sleep 0.5
            echo >&2 "Some error occured. Exiting..."
            exit 1
        fi
    else
        sleep 0.5
        # if apt does not exist, prompt to user
        echo >&2 "Please use your distribution's package manager to install following dependencies:"
        echo >&2 -e ${install_msg}
        echo >&2 "You might have to install:"
        echo >&2 -e "\t python3-venv"
        exit 1
    fi
fi



echo ""
echo "### installing python3 venv ###"

if ! python3 -m venv venv; then
    sleep 0.5
    echo >&2 "Some error occured. Have you python3-venv installed?"
    echo >&2 "Exiting..."
    exit 1
fi
echo "created"

echo ""
echo "### installing python dependencies from requirements.txt ###"

venv/bin/pip3 install --upgrade pip
if ! venv/bin/pip3 install -r requirements.txt; then
    sleep 0.5
    echo >&2 "Some error occured. Exiting..."
    exit 1
fi

echo ""
echo "### all done ###"
echo "INFO: use './start.sh' to run"
