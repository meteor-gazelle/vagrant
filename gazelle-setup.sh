#!/bin/sh

#The installation directory is set to /var/www. If you want to change it, make sure you change all
#instances of /var/www

if [ -f ~/.runonce ]
then
  echo "Gazelle is already setup"
  echo "Aborting"
  exit
fi

#Setup locales for apt-get
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure -f noninteractive locales

echo "Installing dependencies..."

sudo apt-get update
sudo apt-get install -y build-essential curl screen python-software-properties git openjdk-7-jdk

#Get rid of openresty
sudo rm /etc/init.d/openresty
sudo rm -rf /usr/local/openresty/
sudo rm /usr/sbin/openresty

#Install meteor
##TODO Install this as the user 'vagrant' instead of 'root'
curl https://install.meteor.com/ | sh

echo "Dependencies installed"

echo "Updating gazelle codebase..."
rm -rf /var/www/*
rm -rf /var/www/.*

sudo mkdir -p /var/www/tmp
git clone https://github.com/meteor-gazelle/meteor-gazelle /var/www/tmp
sudo rsync -a /var/www/tmp/ /var/www/
sudo rm -rf /var/www/tmp

if [ ! -f /var/www/settings.json.template ]
then
  echo "Cloning of git repo failed!"
  echo "Aborting."
  exit
fi

cp /var/www/settings.json.template /var/www/settings.json

echo "Gazelle update done"

echo "Installing node..."
sudo sh -c "curl -sL https://deb.nodesource.com/setup | bash -"
sudo apt-get install -y nodejs
echo "Installing new version of NPM..."
cd ~/
sudo npm -g install npm@2.1.1 #Install the "fixed" version of npm to avoid lock file errors
echo "Node installed"

echo "Installing elasticsearch..."
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb
dpkg -i elasticsearch-1.4.2.deb
update-rc.d elasticsearch defaults 95 10
/etc/init.d/elasticsearch start
rm elasticsearch-1.4.2.deb
echo "elasticsearch installed"

#Build and symlink .meteor
echo "Moving .meteor and creating symlinks..."
cd /var/www/ && meteor run --settings settings.json
sudo cp -R /var/www/.meteor/local/db /var/db
sudo rm -rf /var/www/.meteor/local/db
cd /var/www/.meteor/local && ln -s /var/db
chown -R vagrant /var/db
chown vagrant /var/www/.meteor
echo "Meteor setup successfully"

echo ""
echo "Setup completed! You can now login with 'vagrant ssh' to see your new box"
echo "See the readme for running the app"

touch ~/.runonce
