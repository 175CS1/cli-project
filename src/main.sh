#!/bin/bash

# Import
. basic_methods.sh
. basic_print.sh



clear 
collegeBanner

echo "" >> CliLog.text
BANNER "~~~~~~~~~~~~~~~~~~~~~~~~ CLI APPLICATION LOG ~~~~~~~~~~~~~~~~~~~~~~~~" >> CliLog.text
echo "$(date)" >> CliLog.text
INFO "--------------------------------" >> CliLog.text

sleep 3s
clear

projectName

sleep 2s

#check superuser (sudo)
check_sudo

# Check Internet Connection.
INETERNET_CHECK

sleep 2s

# Show Main Menu
main_menu
