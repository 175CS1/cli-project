#!/bin/bash

. ./configfiles/basicconfig.sh

function sytem_update() {
    INFO "~~~~~~~~~~~~~~~~~ Updates starting ~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "$(date)" >> CliLog.text
    INFO "-----------------------------------------" >> CliLog.text
    echo "" | tee -a CliLog.text
    sudo apt update && apt upgrade -y | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    INFO "~~~~~~~~~~~~~~~~ Updates Completed ~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    INFO "Restart System for full update to complete"
    read -p "Press Enter to Continue :"
}


function basic_configuration() {
    echo ""
    projectName
    echo ""
    INFO "~~~~~~~~~~~~~~~~~~~ Basic Configuration Settings ~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "$(date)" >> CliLog.text
    echo "" | tee -a CliLog.text

    test -e ./configfiles/basicconfig.sh

    if [[ $? -ne 0 ]]; then
        echo "!#/bin/bash" | tee ./configfiles/basicconfig.sh
        echo -e "\n\n#Created On : $(date)" >> ./configfiles/basicconfig.sh
        echo ""
        INFO "Choose your system required services." 
        echo ""
        read -p 'Does this system require SSH functionality? [y/n] : ' ssh_option
        echo -e "ssh_option=$ssh_option" | tee -a ./configfiles/basicconfig.sh
        read -p 'Does this system require FTP functionality? [y/n] : ' ftp_
        if [[ ${ftp_} = 'y' ]]; then
            INFO "For secured connection, prefer ssh than ftp."
            echo "[ 1 ] Proftpd."
            echo "[ 2 ] Vsftpd."
            echo ""
            ERROR "[ q ] Cancel."
            BANNER "[ m ] Other's Mannualy"
            echo ""
            read -p "Choose the option :" ftp_option
            if [[ ${ftp_option} = 'q' ]]; then
                ftp_='n'
            elif [[ ${ftp_option} = 'm' ]]; then
                ftp_option_name='mannual'
            elif [[ ${ftp_option} = 1 ]]; then
                ftp_option_name='Proftpd'
            elif [[ ${ftp_option} = 2 ]]; then
                ftp_option_name='Vsftpd'
            else
                ftp_='n'
            fi
            
        fi
        echo -e "ftp_=$ftp_" >> ./configfiles/basicconfig.sh
        echo -e "ftp_option_name=$ftp_option_name" >> ./configfiles/basicconfig.sh

        clear
        projectName
        echo ""
        INFO "~~~~~~~~~~~~~~~~~~~ Basic Configuration Settings ~~~~~~~~~~~~~~~~~~~~"
        echo ""
        read -p 'Does this system need to host a website? [y/n] : ' web
        if [[ ${web} = 'y' ]]; then
            INFO "---------- OPTIONS ----------"
            echo "[ 1 ] Apache2"
            echo "[ 2 ] Nginx"
            echo ""
            BANNER "[ m ] Other's Mannualy"
            echo ""
            read -p "Choose the option :" web_option
            if [[ ${web_option} = 1 ]]; then
                web_option_name='Apache'
            elif [[ ${web_option} = 2 ]]; then
                web_option_name='Ngnix'
            else
                web_option_name='mannual'
            fi
        fi
        echo -e "web=${web}" >> ./configfiles/basicconfig.sh
        echo -e "web_option_name=$web_option_name" >> ./configfiles/basicconfig.sh

        clear
        projectName
        echo ""
        INFO "~~~~~~~~~~~~~~~~~~~ Basic Configuration Settings ~~~~~~~~~~~~~~~~~~~~"
        echo ""
        read -p 'Does this system need to host a DataBase? [y/n] : ' dbsys
        if [[ ${dbsys} = 'y' ]]; then
            INFO "---------- OPTIONS ----------"
            echo "[ 1 ] MySQL"
            echo "[ 2 ] PostgresSql"
            echo "[ 3 ] MongoDB"
            echo ""
            BANNER "[ m ] Other's Mannualy"
            echo ""
            read -p "Choose the option :" db_option
            if [[ ${db_option} = 1 ]]; then
                db_option_name='MySQL'
            elif [[ ${db_option} = 2 ]]; then
                db_option_name='PostgresSql'
            elif [[ ${db_option} = 3 ]]; then
                db_option_name='MongoDB'
            else
                db_option_name='mannual'
            fi
        fi
        echo -e "dbsys=$dbsys" >> ./configfiles/basicconfig.sh
        echo -e "db_option_name=$db_option_name" >> ./configfiles/basicconfig.sh
        clear
        echo ""
        projectName
        echo ""
        INFO "~~~~~~~~~~~~~~~~~~~ Basic Configuration Settings ~~~~~~~~~~~~~~~~~~~~"
        echo ""

    fi
    
    INFO "--------------basicConfig.sh--------------"
    cat ./configfiles/basicconfig.sh
    INFO "------------------------------------------"
    echo ""
    read -p "Press Enter to Continue :"


}


function install_from_config {
    clear
    test -e ./configfiles/basicconfig.sh

    if [[ $? -ne 0 ]]; then
        ERROR "Basic Configuration is required for installing " | tee -a CliLog.text
        sleep 2s
        basic_configuration
    fi
    echo ""
    INFO "~~~~~~~~~~~~~~~~~~~ Installation Process Started ~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    if [[ ${ssh_option} = 'y' ]]; then
        sudo apt install ssh | tee -a CliLog.text
    fi
    sleep 2s
    echo "" | tee -a CliLog.text
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FTP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    if [[ ${ftp_} = 'y' ]]; then
        if [[ ${ftp_option_name} = 'Vsftpd' ]]; then
            sudo apt install vsftpd -y | tee -a CliLog.text
        elif [[ ${ftp_option_name} = 'Proftpd' ]]; then
            sudo apt install proftpd -y | tee -a CliLog.text
        elif [[ ${ftp_option_name} = 'mannual' ]]; then
            INFO "Installtion of ftp should be done mannualy" | tee -a CliLog.text
        else
            INFO "Installtion of ftp should be done mannualy" | tee -a CliLog.text
        fi
    fi
    sleep 2s
    echo "" | tee -a CliLog.text
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ WEB ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    if [[ ${web} = 'y' ]]; then
        if [[ ${web_option_name} = 'Apache' ]]; then
            sudo apt install apache2 -y | tee -a CliLog.text
        elif [[ ${web_option_name} = 'Ngnix' ]]; then
            sudo apt install nginx -y | tee -a CliLog.text
        elif [[ ${web_option_name} = 'mannual' ]]; then
            INFO "Installtion of web server should be done mannualy" | tee -a CliLog.text
        else
            INFO "Installtion of web server should be done mannualy" | tee -a CliLog.text
        fi
    fi
    sleep 2s
    echo "" | tee -a CliLog.text
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Data Base ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    if [[ ${dbsys} = 'y' ]]; then
        if [[ ${db_option_name} = 'MySQL' ]]; then
            sudo apt install mysql-server -y | tee -a CliLog.text
        elif [[ ${db_option_name} = 'PostgresSql' ]]; then
            sudo apt install postgresql -y | tee -a CliLog.text
        elif [[ ${db_option_name} = 'MongoDB' ]]; then
            sudo apt-get install gnupg | tee -a CliLog.text
            curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
            echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
            sudo apt-get update | tee -a CliLog.text
            sudo apt-get install -y mongodb-org | tee -a CliLog.text
        elif [[ ${db_option_name} = 'mannual' ]]; then
            INFO "Installtion of Data Base should be done mannualy" | tee -a CliLog.text
        else
            INFO "Installtion of Data Base should be done mannualy" | tee -a CliLog.text
        fi
    fi
    sleep 2s
    echo "" | tee -a CliLog.text
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Fail2Ban ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    sudo apt install fail2ban -y | tee -a CliLog.text

    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> CliLog.text
    sleep 2s
    read -p "Press Enter to Continue :"
}


function search_media {
    clear
    searchDisplay
    echo "$(date)" >> CliLog.text
    INFO "-----------------------------------------" >> CliLog.text
    echo "Prohibited Media Search log is placed in the media_log.txt for further review..." | tee -a CliLog.text
    sleep 1s
    INFO "--------------- Prohibited Media Search Started ---------------" | tee media_log.txt
    INFO "$(date)" >> media_log.txt
    sleep 1s
    find / -name '*.jpg' -o -name '*.mp4' -o -name '*.flv' -o -name '*.avi' -o -name '*.wmv' -o -name '*.mov' -o -name '*.png' -o -name '*.jpg' -o -name '*.tif' -o -name '*.gif' -o -name '*.mp3' -o -name '*.wmv' -o -name '*.wma' -o -name '*.aif' -o -name '*.jar' | tee -a media_log.txt
    INFO "----------------- Prohibited Media Search Ended -------------- " | tee -a media_log.txt
    sleep 1s
    echo ""
    read -p "Press Enter to Continue :"
}


function firewall_settings {
    clear
    firewallDisplay
    echo ""
    test -e ./configfiles/basicconfig.sh

    if [[ $? -ne 0 ]]; then
        ERROR "Choose Basic Config command before using Firewall Settings"
        read -p "Press y to run Basic Config or any other key for Main Menu : " u_ip
        if [[ ${u_ip} = 'y' ]]; then
            basic_configuration
        else
            main_menu
        fi
    else
        echo "" 
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~~ Firewall Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~" >> CliLog.text 
        echo "$(date)" >> CliLog.text 
        sudo ufw enable
        #ftp
        INFO "-------------- FTP -------------" | tee -a CliLog.text 
        if [[ ${ftp_} = 'y' ]]; then
            sudo ufw allow 21 | tee -a CliLog.text 
        else
            sudo ufw deny 21 | tee -a CliLog.text 
        fi

        #web
        INFO "-------------- WEB -------------" | tee -a CliLog.text 
        if [[ ${web} = 'y' ]]; then
            sudo ufw allow 80 | tee -a CliLog.text 
            sudo ufw allow 443 | tee -a CliLog.text 
        else
            sudo ufw deny 80 | tee -a CliLog.text 
            sudo ufw deny 443 | tee -a CliLog.text 
        fi

        #SSH
        INFO "-------------- SSH -------------" | tee -a CliLog.text 
        if [[ ${ssh_option} = 'y' ]]; then
            sudo ufw allow 22 | tee -a CliLog.text 
        else
            sudo ufw deny 22 | tee -a CliLog.text 
        fi


        #DB
        INFO "--------------- DB -------------" | tee -a CliLog.text 
        if [[ ${dbsys} = 'y' ]]; then
            if [[ ${db_option_name} = 'MySQL' ]]; then
                sudo ufw allow 3306 | tee -a CliLog.text 
            elif [[ ${db_option_name} = 'PostgresSql' ]]; then
                sudo ufw allow 5432 | tee -a CliLog.text 
            elif [[ ${db_option_name} = 'MongoDB' ]]; then
                sudo ufw allow 27017 | tee -a CliLog.text 
            fi
        else
            sudo ufw deny 3306 | tee -a CliLog.text 
            sudo ufw deny 5432 | tee -a CliLog.text 
            sudo ufw deny 27017 | tee -a CliLog.text 
        fi

        # DoS attack 
        INFO "-------------- DOS -------------" | tee -a CliLog.text 
        sudo ufw deny 19 | tee -a CliLog.text 
        sudo ufw deny 1434 | tee -a CliLog.text 

        # potential trojan 
        INFO "------------ trojan ------------" | tee -a CliLog.text 
        sudo ufw deny 123 | tee -a CliLog.text 
        # SNMP functionality
        INFO "------------ SNMP ------------" | tee -a CliLog.text 
        sudo ufw deny 161 | tee -a CliLog.text 
        # SNMPtrap functionality
        sudo ufw deny 162 | tee -a CliLog.text 
        
        # Telnet
        INFO "------------ Telnet ------------" | tee -a CliLog.text 
        
        sudo ufw deny 23 | tee -a CliLog.text 
        # DNS functionality
        INFO "------------ DNS -------------" | tee -a CliLog.text 
        sudo ufw deny 53 | tee -a CliLog.text 

    fi
    
    INFO "------------ Status -------------" | tee -a CliLog.text 
    sudo ufw status | tee -a CliLog.text 
    echo "" | tee -a CliLog.text 
    read -p "Press Enter to Continue : "
}


function audit_lynis {
    clear
    healthSanDisplay
    echo ""
    INFO "Lynis :"
    sudo lynis show version
    if [[ $? -ne 0 ]]; then
        echo "$(date)" >> CliLog.text
        INFO "-----------------------------------------" >> CliLog.text
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~~ Installing Lynis ~~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
        sudo apt-get install lynis -y | tee -a CliLog.text
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~ Installing Complete ~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
        sleep 2s
    fi
    echo ""
    echo "Audit Report is placed in the LynisAuditLog.txt for further review..." | tee -a CliLog.text
    INFO "$(date) : Lynis Audit Started" | tee LynisAuditLog.txt
    echo -e "\n\n----------------------------------------------------" >> LynisAuditLog.txt
    sudo lynis audit system | tee -a LynisAuditLog.txt
    echo -e "\n\n----------------------------------------------------" >> LynisAuditLog.txt
    SUCCESS "$(date) : Lnis Audit Completed" | tee -a LynisAuditLog.txt
    echo ""
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> CliLog.text
    read -p "Press Enter to Continue :"

}

function malware_analysis {
    clear
    malwareDisplay
    echo ""
    WARNING "This command will take a long time!"
    WARNING "Once started you will no longer be able to use this terminal until the command has completed." 
    echo ""
    read -p "Are you sure you want to start this now? [y/n]" clams
    if [[ ${clams} = 'y' ]]; then
        echo "$(date)" >> CliLog.text
        INFO "-----------------------------------------" >> CliLog.text
        echo "Malware Report is placed in the MalwareAnalysis.txt for further review..." | tee -a CliLog.text
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CLAMV ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
        sudo apt install clamav -y | tee -a CliLog.text
        sudo freshclam | tee -a CliLog.text 
        #make sure clamav's virus and malware database is updated
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CLAM SCAN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
        echo "" | tee -a CliLog.text
        INFO "$(date): Analysis Started " | tee MalwareAnalysis.txt
        echo ""
        sudo clamscan -r --remove / | tee -a MalwareAnalysis.txt
        INFO "$(date): Analysis Finished " | tee -a MalwareAnalysis.txt
        echo ""
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> CliLog.text
        read -p "Press Enter to Continue : "
    fi
}


function report_analysis {
    clear
    reportDisplay
    echo ""
    INFO "~~~~~~~~~~~~~~~~~ Reports ~~~~~~~~~~~~~~~~~"
    echo ""
    #Menu for report reading
    INFO "Commands:"
    echo "[ 1 ] CLI Application Log. "
    echo "[ 2 ] Health Scan Report. "
    echo "[ 3 ] Malware Analysis Report. "
    echo "[ 4 ] Basic Configuration File. "
    echo "[ 5 ] Prohibited Media Log. "
    echo ""
    BANNER "[ m ] Main Menu. "
    echo ""
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo ""
    read -p 'Which command would you like to use? : ' com
    sleep 1s
    clear
    reportDisplay
    if [[ ${com} = 1 ]]; then
        INFO "~~~~~~~~~~~~~~~~ CLI Application Log ~~~~~~~~~~~~~~~~" 
        echo ""
        sudo cat CliLog.text
        echo ""
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        read -p "Press Enter to Continue : "
    elif [[ ${com} = 2 ]]; then
        INFO "~~~~~~~~~~~~~~~~ Health Scan Report ~~~~~~~~~~~~~~~~" 
        echo ""
        sudo cat LynisAuditLog.txt
        echo ""
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        read -p "Press Enter to Continue : "
    elif [[ ${com} = 3 ]]; then
        INFO "~~~~~~~~~~~~~~ Malware Analysis Report ~~~~~~~~~~~~~~" 
        echo ""
        sudo cat MalwareAnalysis.txt
        echo ""
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        read -p "Press Enter to Continue : "
    elif [[ ${com} = 4 ]]; then
        INFO "~~~~~~~~~~~~~~~~~~~ Config File ~~~~~~~~~~~~~~~~~~~~~" 
        echo ""
        sudo cat ./configfiles/basicconfig.sh
        echo ""
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        read -p "Press Enter to Continue : "
    elif [[ ${com} = 5 ]]; then
        INFO "~~~~~~~~~~~~~~~~ Prohibited Media ~~~~~~~~~~~~~~~~~~~" 
        echo ""
        sudo cat media_log.txt
        echo ""
        INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        read -p "Press Enter to Continue : "
    elif [[ ${com} = 'm' ]]; then
        sleep 1s
        main_menu
    fi
    
    sleep 1s
    report_analysis

}