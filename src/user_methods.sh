#!/bin/bash
. basic_print.sh


function user_menu {
    clear
    userSettingsDisplay

    #Menu for user and Group settings
    echo ""
    INFO "Commands:"
    echo "[ 1 ] Add User                       [ 2 ] Remove User"
    echo "[ 3 ] Create Group                   [ 4 ] Remove Group"
    echo "[ 5 ] Add user to Group              [ 6 ] Remove user from Group"
    echo "[ 7 ] List local users               [ 8 ] List Local Groups"
    echo "[ 9 ] List members of group          [ 10 ] List the groups an user is in"
    echo "[ 11 ] Change password     "
    echo ""
    BANNER "[ b ] Back to Main Menu"
    echo ""
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo ""
    read -p 'Which command would you like to use? : ' com

    if [[ ${com} = 1 ]]; then
        add_user
    elif [[ ${com} = 2 ]]; then
        remove_user
    elif [[ ${com} = 3 ]]; then
        create_group
    elif [[ ${com} = 4 ]]; then
        remove_group
    elif [[ ${com} = 5 ]]; then
        user_to_group
    elif [[ ${com} = 6 ]]; then
        remove_user_from_group
    elif [[ ${com} = 7 ]]; then
        list_users
    elif [[ ${com} = 8 ]]; then
        list_groups
    elif [[ ${com} = 9 ]]; then
        group_members
    elif [[ ${com} = 10 ]]; then
        user_group_mem
    elif [[ ${com} = 11 ]]; then
        change_password
    elif [[ ${com} = 'b' ]]; then
        main_menu
    else
        user_menu
    fi
    sleep 1s
    user_menu
}


#add user
function add_user {
    clear
    echo "" | tee -a CliLog.text
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~ ADD USER ~~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    read -p 'Would you like to add a user? [y/n] : ' adduseryn
    if [[ ${adduseryn} = 'y' ]]; then
        adduser=1
        while [[ ${adduser} = 1 ]]; do
        read -p 'What would you like to name this new user? : ' name
        read -p 'Is this user an Admin? [y/n] : ' adminyn
        if [[ ${adminyn} = 'y' ]]; then
            sudo adduser --force-badname ${name}
            sudo usermod -a -G sudo ${name}		#adds user to sudo group
            sudo usermod -a -G adm ${name}   #adds user to admin group
            SUCCESS "User ${name} has been created and has been added to admin and sudo groups" | tee -a CliLog.text
        else
            sudo useradd ${name}
            SUCCESS "User ${name} has been added!" | tee -a CliLog.text
        fi
        read -p 'Would you like to add another user? [y/n] : ' aga
        if [[ ${aga} = 'n' ]]; then
            adduser=0
        fi
        done
        sleep 1s
    else
        user_menu
    fi
}


#remove users
function remove_user {
    clear
    echo "" | tee -a CliLog.text
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~ REMOVE USER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    read -p 'Would you like to remove a user from this system? [y/n] : ' rmuseryn
    if [[ ${rmuseryn} = 'y' ]]; then
        rmuser=1
        while [[ ${rmuser} = 1 ]]; do
        cat /etc/passwd | grep "/home" | cut -d":" -f1
        read -p 'Which user would you like to remove from the system? : ' name
        userdel -r ${name}
        SUCCESS "User ${name} has been removed from this system!" | tee -a CliLog.text
        echo ""
        read -p 'Would you like to remove another user from this system? [y/n] : ' aga
        if [[ ${aga} = 'n' ]]; then
            rmuser=0
        fi
        done
    else
        user_menu
    fi
}


#creat group
function create_group {
    clear
    echo "" | tee -a CliLog.text
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~ CREATE GROUP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    read -p 'Would you like to create a new group? [y/n] : ' crtgruyn
    if [[ ${crtgruyn} = 'y' ]]; then
        crtgru=1
        while [[ ${crtgru} = 1 ]]; do
        read -p 'What would you like to name the new group? : ' name

        sudo groupadd ${name}

        SUCCESS "The new group, ${name} has been created!" | tee -a CliLog.text
        echo ""
        read -p 'Would you like to create another group? [y/n] : ' aga
        if [[ ${aga} = 'n' ]]; then
            crtgru=0
        fi
        done
    else
        user_menu
    fi
}


#remove group
function remove_group {
    clear
    echo "" | tee -a CliLog.text
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~ REMOVE GROUP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    read -p 'Would you like to delete a group? [y/n] : ' rmgruyn
    if [[ ${rmgruyn} = 'y' ]]; then
        rmgru=1
        while [[ ${rmgru} = 1 ]]; do
        getent group | cut -d: -f1 #List out groups
        read -p 'What group would you like to remove from the system? : ' name
        sudo groupdel ${name}
        SUCCESS "The group, ${name} has been removed from the system!" | tee -a CliLog.text
        echo ""
        read -p 'Would you like to remove another user from the system? [y/n] : ' aga
        if [[ ${aga} = 'n' ]]; then
            rmgru=0
        fi
        done
    else
        user_menu
    fi
}


#add user to group
function user_to_group {
    clear
    echo "" | tee -a CliLog.text
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~ ADD USER TO GROUP ~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    read -p 'Would you like to add a user to a group? [y/n] : ' usrtogruyn
    if [[ ${usrtogruyn} = 'y' ]]; then
        usrtogru=1
        while [[ ${usrtogru} = 1 ]]; do
        cat /etc/passwd | grep "/home" | cut -d":" -f1
        read -p 'Which user would you like to add to a group? : ' name
        getent group | cut -d: -f1
        read -p 'Which group would you like to add user ${name} to? : ' group

        sudo usermod -a -G ${group} ${name}

        SUCCESS "User ${name} has been added to group ${group}." | tee -a CliLog.text
        echo ""
        read -p 'Would you like to add another user to another group? [y/n] : ' aga
        if [[ ${aga} = 'n' ]]; then
            usrtogru=0
        fi
        done
    else
        user_menu
    fi
}


#remove user from group
function remove_user_from_group {
    clear
    echo "" | tee -a CliLog.text
    INFO "~~~~~~~~~~~~~~~~~~~~~~ REMOVE USER FROM GROUP ~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    BANNER "At a point, if you wish to cancel the process, PRESS q "
    WARNING "If user is not available in the group, this leads to removal of user."
    echo ""
    read -p 'Would you like to remove a user from a group? [y/n] : ' rmfrogruyn
    if [[ ${rmfrogruyn} = 'y' ]]; then
        rmfrogru=1
        while [[ ${rmfrogru} = 1 ]]; do
        cat /etc/passwd | grep "/home" | cut -d":" -f1
        read -p 'Which user would you like to remove from a group? : ' name
        if [[ ${name} = 'q' ]]; then
            break
        fi
        # getent group | cut -d: -f1
        sudo groups ${name}
        read -p 'Which group would you like to remove the user from? : ' gruname
        if [[ ${gruname} = 'q' ]]; then
            break
        fi
        # gpasswd -d ${name} ${gruname}
        sudo deluser ${name} ${gruname}

        if [ $? -eq 0 ]; then
            SUCCESS "User ${name} has been removed from group ${gruname}!" | tee -a CliLog.text
        else
            ERROR "Error while removing user $name from group $gruname." | tee -a CliLog.text
        fi

        read -p 'Would you like to remove another user from another group? [y/n] : ' aga
        if [[ ${aga} = 'n' ]]; then
            rmfrogru=0
        fi
        done
    else
        user_menu
    fi
}


#list users
function list_users {
    clear
    echo ""
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ USERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo ""
    cat /etc/passwd | grep "/home" | cut -d":" -f1
    read -p 'Press Enter to continue...'
}


#list groups
function list_groups {
    clear
    echo ""
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GROUP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo ""
    getent group | cut -d: -f1 
    read -p 'Press Enter to continue...'
}


function user_group_mem {
    clear
    echo ""
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~~ USER GROUP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo ""
    read -p 'Would you like to see what groups a specific user is in? [y/n] : ' usrgrumemyn
    if [[ ${usrgrumemyn} = 'y' ]]; then
        cat /etc/passwd | grep "/home" | cut -d":" -f1
        read -p 'What is the name of the user that you want to know the groups of? : ' name
        echo ""
        INFO "~~~~~~ $name GROUP ~~~~~~"
        groups $name
    else
        user_menu
    fi
    read -p "Press Enter to Continue :"
}


function group_members {
    clear
    echo ""
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~~ GROUP MEMBERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo ""
    read -p 'Would you like to see what members are in a specific group? [y/n] : ' grumemyn
    if [[ ${grumemyn} = 'y' ]]; then
        getent group | cut -d: -f1
        read -p 'What group would you like to see the members of? : ' gruname
        echo ""
        INFO "~~~~~~ $gruname Members ~~~~~~"
        grep -i --color ${gruname} /etc/group
    else
        user_menu
    fi
    read -p "Press Enter to Continue :"
}


function change_password {
    clear
    echo "" | tee -a CliLog.text
    INFO "~~~~~~~~~~~~~~~~~~~~~~~~~~ Change Password ~~~~~~~~~~~~~~~~~~~~~~~~~~" | tee -a CliLog.text
    echo "" | tee -a CliLog.text
    read -p "Would you like to change the password? [y/n] :" passchange
    if [[ ${passchange} = 'y' ]]; then
        passwd
        if [ $? -eq 0 ]; then
            SUCCESS "Successfully Changed the User Password" | tee -a CliLog.text
        else
            ERROR "Error while changing User Password." | tee -a CliLog.text
        fi
    else
        user_menu
    fi
    read -p "Press Enter to Continue :"
}