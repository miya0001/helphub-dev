#!/usr/bin/env bash

set -ex

cd /var/www/html/wp-content
if [ -d .git ]; then
  git pull origin master
else
  git init
  git remote add origin https://github.com/Kenshino/HelpHub.git
  git fetch origin
  git clean -fdx
  git pull origin master
fi

wp plugin install bbpress --activate --force
wp plugin activate support-helphub
wp theme activate wporg-support

wp plugin install wordpress-importer --activate
wp import helphub.wordpress.2017-10-30.xml --authors=create

wp plugin deactivate wordpress-importer
wp plugin uninstall wordpress-importer

php -d memory_limit=-1 /usr/local/bin/wp package install git@github.com:miya0001/helphub-command.git
wp helphub migrate
