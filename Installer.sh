#!/bin/bash

ZENITY=1

if [ ! $(type -p zenity) ]; then
    ZENITY=0
fi

if [[ " $* " == *" --no-zenity "*  ]] || [[ " $* " == *" -t "* ]]; then
    ZENITY=0
fi

if [[ -f "$(pwd)/log.txt" ]]; then
    rm -f "$(pwd)/log.txt"
fi

if [[ $EUID -eq 0 ]]; then
    if [ $ZENITY -eq 1 ]; then
        zenity --info --text="Script must not be ran as root!" --icon=dialog-warning > /dev/null
        exit 1
    else
        echo "Script must not be ran as root!"
        read -n 1 -r -s -p "Press any key to continue..."
        echo ""
        exit 1
    fi
   exit 1
fi

if [ ! $(type -p wget) ]; then
    if [ $ZENITY -eq 1 ]; then
        zenity --info --text="wget is not installed. It is required to download RuBeta's jar." --icon=dialog-warning > /dev/null
        exit 1
    else
        echo "wget is not installed. It is required to download RuBeta's jar."
        read -n 1 -r -s -p "Press any key to continue..."
        echo ""
        exit 1
    fi
fi

wget -q -O ./RuBetaLauncher.jar "https://rubeta.net/launcher/RuBetaLauncher.jar" 

pkexec bash -c "cd \"$(pwd)\";  if [ -f /opt/rubeta ]; then rm -f /opt/rubeta; fi; if [ -d /opt/rubeta/ ]; then rm -rf /opt/rubeta/; fi; mkdir /opt/rubeta/; cp ./RuBetaLauncher.jar /opt/rubeta/RuBetaLauncher.jar; chmod -R 777 /opt/rubeta; echo -e \"[Desktop Entry]\nComment=Minecraft Beta 1.7.3 Server\nIcon=minecraft\nExec=java -jar /opt/rubeta/RuBetaLauncher.jar\nName=RuBeta\nTerminal=false\nStartupNotify=false\nType=Application\nCategories=Game;ArcadeGame;\nKeywords=rubeta;minecraft;\" > /usr/share/applications/RuBeta.desktop;" 2>&1 | tee -a "$(pwd)/log.txt"
rm -f ./RuBetaLauncher.jar

INSTALLED=1

if [ ! -d "/opt/rubeta" ]; then
    INSTALLED=0
fi
if [ ! -f "/opt/rubeta/RuBetaLauncher.jar" ]; then
    INSTALLED=0
fi
if [ ! -f "/usr/share/applications/RuBeta.desktop" ]; then
    INSTALLED=0
fi

if [ $INSTALLED -eq 1 ]; then
    if [ $ZENITY -eq 1 ]; then
        zenity --info --text="RuBeta has been installed!" --icon=face-cool > /dev/null
        if [[ -f "$(pwd)/log.txt" ]]; then
            rm -f "$(pwd)/log.txt"
        fi
        exit 1
    else
        echo "RuBeta has been installed!"
        read -n 1 -r -s -p "Press any key to continue..."
        if [[ -f "$(pwd)/log.txt" ]]; then
            rm -f "$(pwd)/log.txt"
        fi
        echo ""
        exit 1
    fi
else
    if [ $ZENITY -eq 1 ]; then
        zenity --info --text="Something went wrong." --icon=dialog-error > /dev/null
        zenity --text-info --title="Log" --filename="$(pwd)/log.txt"
        if [[ -f "$(pwd)/log.txt" ]]; then
            rm -f "$(pwd)/log.txt"
        fi
        exit 1
    else
        echo "Something went wrong."
        read -n 1 -r -s -p "Press any key to read log..."
        less "$(pwd)/log.txt"
        echo ""
        read -n 1 -r -s -p "Press any key to continue..."
        echo ""
        exit 1
    fi
fi