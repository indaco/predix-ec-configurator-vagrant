#!/bin/bash

VAGRANT_HOME=/home/vagrant
GOPATH=$VAGRANT_HOME/gowork
PREDIX_EC_CONFIGURATOR_HOME=$GOPATH/src/github.com/indaco/predix-ec-configurator

source $VAGRANT_HOME/.profile
source $VAGRANT_HOME/.bash_profile

sudo chown vagrant:vagrant -R $GOPATH

echo '>>> copying your config.json file'
cp /home/vagrant/config.json $PREDIX_EC_CONFIGURATOR_HOME/config.json

# Starting predix-ec-configurator
sudo /etc/init.d/ec-configurator-service start
if [ $? -eq 0 ]
then
  echo 'predix-ec-configurator Successfully started!'
else
  echo 'predix-ec-configurator can not start!' >&2
  exit -1
fi

# 'Starting nginx'
sudo service nginx restart
if [ $? -eq 0 ]
then
  cat << EOF

Alright! predix-ec-configurator is up and running.
usage: open a browser window at http://localhost:8080

EOF
else
  echo 'Nginx is facing some issues when starting!' >&2
fi
