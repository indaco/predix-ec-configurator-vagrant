#!/bin/bash

VAGRANT_HOME=/home/vagrant
GOPATH=$VAGRANT_HOME/gowork
PREDIX_EC_CONFIGURATOR_HOME=$GOPATH/src/github.com/indaco/predix-ec-configurator

source $VAGRANT_HOME/.profile
source $VAGRANT_HOME/.bash_profile

sudo chown vagrant:vagrant -R $GOPATH

echo '>>> copying your config.json file'
cp /home/vagrant/config.json $GOPATH/src/github.com/indaco/predix-ec-configurator/config.json

cd $PREDIX_EC_CONFIGURATOR_HOME/
echo '>>> Starting predix-ec-configurator'
nohup ./predix-ec-configurator > $VAGRANT_HOME/predix-ec-configurator-output.log 2>&1&

# 'Starting nginx'
sudo service nginx restart

cat << EOF

Alright! predix-ec-configurator is up and running.
usage: open a browser window at http://localhost:8080

EOF
