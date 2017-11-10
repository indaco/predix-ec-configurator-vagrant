#!/bin/bash

set -o errexit

echo '>>> Setting up ECDemo Vagrant Box'

# Assign permissions to "vagrant" user
sudo chown -R vagrant /usr/local

# Updating the system
sudo apt-get -y update

### Installing Git
echo '>>> Installing Git'
sudo apt-get install -y git
git config --global user.name "Admin"
git config --global user.email "admin@example.com"

### Installing CF CLI
echo ">>> Installing CF CLI"
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
sudo apt-get update
sudo apt-get install cf-cli

### Installing Go 1.9.2
echo '>>> Installing Go 1.9.2'
wget -q -O /home/vagrant/go1.9.2.linux-amd64.tar.gz https://redirector.gvt1.com/edgedl/go/go1.9.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf /home/vagrant/go1.9.2.linux-amd64.tar.gz
rm /home/vagrant/go1.9.2.linux-amd64.tar.gz

VAGRANT_HOME=/home/vagrant
GOPATH=$VAGRANT_HOME/gowork
mkdir $GOPATH

# Setting Go env variables
echo '>>> Setting Go env variables'

echo 'export GOROOT=/usr/local/go' >> $VAGRANT_HOME/.profile
echo 'export PATH=$PATH:$GOROOT/bin' >> $VAGRANT_HOME/.profile
source $VAGRANT_HOME/.profile

echo 'export VAGRANT_HOME=/home/vagrant' >> $VAGRANT_HOME/.bash_profile
echo 'export GOPATH=$VAGRANT_HOME/gowork' >> $VAGRANT_HOME/.bash_profile
echo 'export GOBIN=$GOPATH/bin' >> $VAGRANT_HOME/.bash_profile
echo 'export PATH=$GOBIN:$PATH' >> $VAGRANT_HOME/.bash_profile
source $VAGRANT_HOME/.bash_profile

echo '>>> Checking Go installation (You should see go version number below this)'
go version

# Assign permissions to "vagrant" user on GOPATH
sudo chown vagrant:vagrant -R $GOPATH

# Installing GoVendor
echo '>>> Installing GoVendor'
go get -u github.com/kardianos/govendor

# Getting predix-ec-configurator
echo '>>> Getting predix-ec-configurator'
go get -u github.com/indaco/predix-ec-configurator
cd $GOPATH/src/github.com/indaco/predix-ec-configurator

echo '>>> Downloading dependencies'
$GOPATH/bin/govendor sync
go get

echo '>>> Building predix-ec-configurator'
go build

### Installing Nginx
echo '>>> Installing Nginx'
sudo apt-get install -y nginx

# set up nginx server
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.bk.conf
sudo sed -i 's/www-data/vagrant/' /etc/nginx/nginx.conf
sudo rm /etc/nginx/sites-enabled/default
sudo cp /vagrant/scripts/mysite /etc/nginx/sites-available/mysite
sudo chmod 644 /etc/nginx/sites-available/mysite
sudo ln -s /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/mysite

# clean /var/www
sudo rm -Rf /var/www
# symlink /var/www => /vagrant
ln -s /vagrant /var/www

### Installing PostgreSQL
echo '>>> Installing PostgreSQL'
POSTGRESQL_VERSION=9.6
sudo apt-get update
sudo apt-get install -y software-properties-common python-software-properties
sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql-$POSTGRESQL_VERSION

# Allowing external connections
sudo sed -i 's/#listen_addresses/listen_addresses/' /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf
sudo sed -i 's/localhost/*/' /etc/postgresql/9.6/main/postgresql.conf

# Configuring Postgres
sudo bash -c "cat > /etc/postgresql/${POSTGRESQL_VERSION}/main/pg_hba.conf" << EOL
local   all             all                                     trust
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
host    all             all             10.0.0.0/16             md5
EOL

# Restarting PostgreSQL
sudo /etc/init.d/postgresql restart

# Creating a new ecdemodb database
# Setting password for ecdemouser
psql -U postgres <<EOF
\x
CREATE USER ecdemouser;
ALTER USER ecdemouser PASSWORD 'ecdemo';
CREATE DATABASE ecdemodb OWNER ecdemouser;
EOF

# Storing sample data on PostgreSQL
psql -U ecdemouser ecdemodb < /vagrant/scripts/dbexport.pgsql

### Finished! ###
echo '>>> predix-ec-configurator Vagrant box is ready!'
