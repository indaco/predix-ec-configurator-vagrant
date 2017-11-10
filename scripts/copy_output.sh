#!/bin/bash

VAGRANT_HOME=/home/vagrant
GOPATH=$VAGRANT_HOME/gowork
PREDIX_EC_CONFIGURATOR_HOME=$GOPATH/src/github.com/indaco/predix-ec-configurator

OUTPUT_FOLDER=/vagrant/output
cp -R $PREDIX_EC_CONFIGURATOR_HOME/output $OUTPUT_FOLDER
