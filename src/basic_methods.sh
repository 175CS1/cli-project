#!/bin/bash

# import
. menu_methods.sh
. user_methods.sh

#Connectivity check.
function INETERNET_CHECK(){
    IP="$(curl -s http://ifconfig.me)"

    if [ $? -eq 0 ]; then 
        echo "IP Address: $IP" 
        SUCCESS "INTERNET IS AVAILABLE"
        echo ""
    else 
        WARNING "No INTERNET CONNECTION" | tee -a CliLog.text
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> CliLog.text
        sleep 4s
        exit
    fi
}

#this statement checks for if you are running as superuser (sudo)
function check_sudo() {

    if [[ $(/usr/bin/id -u) -ne 0 ]]; then	
        ERROR "You are not root user." | tee -a CliLog.text
        WARNING "You must run as root user to use this script" | tee -a CliLog.text
        echo "" | tee -a CliLog.text
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> CliLog.text
        sleep 3s
        exit
    fi
}


function main_menu {
    clear
    menuDisplay

    echo ""
    INFO "Commands:"
    echo "[ 1 ] User Settings. "
    echo "[ 2 ] System Updates. "
    echo "[ 3 ] Basic Configuration. "
    echo "[ 4 ] Firewall Settings. "
    echo "[ 5 ] Extensive Health Scan. "
    echo "[ 6 ] Search Prohibited Media. "
    echo "[ 7 ] Malware Removal. "
    echo "[ 8 ] Read Log and Analysis Files. "
    echo "[ 9 ] Install Basic Applications. "
    echo ""
    BANNER "[ r ] REBOOT. "
    ERROR "[ q ] QUIT. "
    echo ""
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo ""
    read -p 'Which command would you like to use? : ' com

    echo "You have choosen the command : $com"

    sleep 1s

    if [[ ${com} = 1 ]]; then
        clear
        user_menu
    elif [[ ${com} = 2 ]]; then
        clear
        updateDisplay
        sytem_update

    elif [[ ${com} = 3 ]]; then
        clear
        basic_configuration

    elif [[ ${com} = 4 ]]; then
        clear
        firewall_settings

    elif [[ ${com} = 5 ]]; then
        clear
        audit_lynis

    elif [[ ${com} = 6 ]]; then
        clear
        search_media


    elif [[ ${com} = 7 ]]; then
        clear
        malware_analysis

    elif [[ ${com} = 8 ]]; then
        clear
        report_analysis

    elif [[ ${com} = 9 ]]; then
        clear
        install_from_config

    elif [[ ${com} = "r" ]]; then
        clear
        echo ""
        WARNING "You have choosen to reboot the system, press y to continue"
        read rconfirm
        if [[ ${rconfirm} = 'y' ]]; then
            sudo reboot
        fi
        sleep 1s

    elif [[ ${com} = "q" ]]; then
        clear
        echo ""
        INFO "Do you wish to Quit the process ?"
        read -p "Press [y/n] and Enter: " con_exit
        if [[ ${con_exit} = 'n' ]]; then
            main_menu
        fi
        clear
        exit
    
    else
        echo ""
        ERROR " Wrong Command Selected"
        sleep 2s
        main_menu
    fi
    sleep 1s
    main_menu

}