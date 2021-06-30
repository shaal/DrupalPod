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
    2 )
      result=$(df -h)
      display_result "Disk Space"
      ;;
    3 )
      if [[ $(id -u) -eq 0 ]]; then
        result=$(du -sh /home/* 2> /dev/null)
        display_result "Home Space Utilization (All Users)"
      else
        result=$(du -sh $HOME 2> /dev/null)
        display_result "Home Space Utilization ($USER)"
      fi
      ;;
    4 )
      chmod a+rwx m2-install.sh && ./m2-install.sh && clear
      result=$(url=$(gp url | awk -F"//" {'print $2'}) && url+="/" && url="https://8002-"$url;echo $url)
      display_result "Installation completed! Please visit"
      ;;
    5 )
      chmod a+rwx m2-install-solo.sh && ./m2-install-solo.sh && clear
      result=$(url=$(gp url | awk -F"//" {'print $2'}) && url+="/" && url="https://8002-"$url;echo $url)
      display_result "Installation completed! Please visit"
      ;;
    6 )
      result=$(git clone https://github.com/magento/baler.git && cd baler && npm install && npm run build;alias baler='/workspace/magento2gitpod/baler/bin/baler'&)
      display_result "Baler tool successfully installed! Press enter to continue ..."
      ;;
    7 )
      result=$(cd /workspace/magento2gitpod && /usr/bin/php -dmemory_limit=20000M /usr/bin/composer require creativestyle/magesuite-magepack && n98-magerun2 setup:upgrade && n98-magerun2 setup:di:compile && n98-magerun2 setup:static-content:deploy && n98-magerun2 cache:clean && n98-magerun2 cache:flush && nvm install 14.5.0 && npm install -g magepack)
      display_result "MagePack tool successfully installed! Press enter to continue ... visit https://nemanja.io/speed-up-magento-2-page-load-rendering-using-magepack-method/ for more details how to proceed further"
      ;;
    8 )
      result=$(redis-server &)
      display_result "Redis service started! Press enter to continue ...Installation completed! Press enter to continue ..."
      ;;
    9 )
      result=$(ps aux | grep redis | awk {'print $2'} | xargs kill -s 9)
      display_result "Redis service stopped! Press enter to continue ..."
      ;;
    10 )
      result=$($ES_HOME/bin/elasticsearch -d -p $ES_HOME/pid -Ediscovery.type=single-node &)
      display_result "ElasticSearch service started! Press enter to continue ..."
      ;;
    11 )
      result=$(ps aux | grep elastic | awk {'print $2'} | xargs kill -s 9)
      display_result "ElasticSearch service stopped! Press enter to continue ..."
      ;;
    12 )
      result=$(chmod a+rwx ./blackfire-run.sh && ./blackfire-run.sh && service php7.3-fpm reload)
      display_result "Blackfire service started! Press enter to continue ..."
      ;;
    13 )
      result=$(ps aux | grep blackfire | awk {'print $2'} | xargs kill -s 9)
      display_result "Blackfire service stopped! Press enter to continue ..."
      ;;
    14 )
      result=$(newrelic-daemon -c /etc/newrelic/newrelic.cfg &)
      display_result "Newrelic service started! Press enter to continue ... Please update .gitpod.Dockerfile (https://github.com/nemke82/magento2gitpod/blob/master/.gitpod.Dockerfile) with license key."
      ;;
    15 )
      result=$(ps aux | grep newrelic | awk {'print $2'} | xargs kill -s 9)
      display_result "Newrelic service stopped! Press enter to continue ..."
      ;;
    16 )
      result=$(/usr/bin/tideways-daemon --address 0.0.0.0:9135 &)
      display_result "Tideways service started! Press enter to continue ... Starting Tideways service, Please update .env-file located in repo with TIDEWAYS_APIKEY"
      ;;
    17 )
      result=$(ps aux | grep tideways | awk {'print $2'} | xargs kill -s 9)
      display_result "Tideways service stopped! Press enter to continue ..."
      ;;
    18 )
      rm -f /etc/php/7.3/mods-available/xdebug.ini &&
      wget http://xdebug.org/files/xdebug-2.9.8.tgz && tar -xvf xdebug-2.9.8.tgz &&
      cd xdebug-2.9.8 && phpize && ./configure && make && clear &&
      result=$(echo "Configuring xDebug PHP settings" &&
    echo "xdebug.remote_autostart=on" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "xdebug.profiler_enable=On" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "xdebug.remote_enable=1" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "xdebug.remote_port=9003" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "xdebug.profiler_output_name = nemanja.log" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "xdebug.show_error_trace=On" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "xdebug.show_exception_trace=On" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "zend_extension=/workspace/magento2gitpod/xdebug-2.9.8/modules/xdebug.so" >> /etc/php/7.3/mods-available/xdebug.ini;
    ln -s /etc/php/7.3/mods-available/xdebug.ini /etc/php/7.3/fpm/conf.d/20-xdebug.ini;
    ln -s /etc/php/7.3/mods-available/xdebug.ini /etc/php/7.3/cli/conf.d/20-xdebug.ini;
    service php7.3-fpm reload;clear)
      display_result "Services successfully configured and php-fpm restarted! Press enter to continue ..."
      ;;
    19 )
      result=$(echo "Configuring xDebug PHP settings" && echo "xdebug.remote_autostart=off" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "xdebug.profiler_enable=Off" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "xdebug.remote_enable=0" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "xdebug.remote_port=9003" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "xdebug.profiler_output_name = nemanja.log" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "xdebug.show_error_trace=Off" >> /etc/php/7.3/mods-available/xdebug.ini;
    echo "xdebug.show_exception_trace=Off" >> /etc/php/7.3/mods-available/xdebug.ini;
    mv /etc/php/7.3/fpm/conf.d/20-xdebug.ini /etc/php/7.3/fpm/conf.d/20-xdebug.ini-bak;
    mv /etc/php/7.3/cli/conf.d/20-xdebug.ini /etc/php/7.3/cli/conf.d/20-xdebug.ini-bak;
    service php7.3-fpm reload;)
      display_result "xDebug stopped! Press enter to continue ..."
      ;;
    20 )
      result=$(while true; do /usr/bin/php /workspace/magento2gitpod/bin/magento cron:run >> /workspace/magento2gitpod/var/log/cron.log && /usr/bin/php /workspace/magento2gitpod/update/cron.php >> /workspace/magento2gitpod/var/log/cron.log && /usr/bin/php /workspace/magento2gitpod/bin/magento setup:cron:run >> /workspace/magento2gitpod/var/log/cron.log; sleep 60; done &)
      display_result "Magento 2 Cron service started successfully. Press enter to continue ..."
      ;;
  esac
done

