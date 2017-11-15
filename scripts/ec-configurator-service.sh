#!/bin/bash

VAGRANT_HOME=/home/vagrant
GOPATH=$VAGRANT_HOME/gowork
PREDIX_EC_CONFIGURATOR_HOME=$GOPATH/src/github.com/indaco/predix-ec-configurator

case $1 in
  start)
    echo "Starting predix-ec-configurator."
    cd $PREDIX_EC_CONFIGURATOR_HOME/
    nohup ./predix-ec-configurator --vagrant true > $VAGRANT_HOME/predix-ec-configurator-output.log 2>&1&
    ;;
  stop)
    echo "Stopping predix-ec-configurator."
    sudo kill $(sudo lsof -t -i:9000)
    ;;
  *)
    echo "predix-ec-configurator app service."
    echo $"Usage $0 {start|stop}"
    exit 1
esac
exit 0
