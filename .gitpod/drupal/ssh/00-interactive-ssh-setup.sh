#!/bin/bash


# Copy your public key
# php -S localhost:8000 id_rsa.backup & sleep 3 & gp preview $(gp url 8000)
# killall php

# while-menu-dialog: a menu driven system information program

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Installer/Services menu" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 4 \
    "1" "Setup SSH" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
    1 )
      result=$(code .gitpod/drupal/ssh/instructions-template.md)
      display_result "If you completed the instructions above - click OK"
      .gitpod/drupal/ssh/04-confirm-ssh-setup.sh
      # gp preview https://drupal.org/user --external
      ;;
  esac
done

