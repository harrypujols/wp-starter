#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='root'
PROJECT='wordpress'
PORT=$1

# update / upgrade
sudo apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# install php latest
sudo apt-get install -y php libapache2

# install composer
sudo apt-get install -y zip unzip composer

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server php-mysql

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin
sudo phpenmod mcrypt

# setup mysql user
MY=$(cat <<EOF
[client]
user=root
password=root
host=localhost
EOF
)
echo "${MY}" > /home/vagrant/.my.cnf

# create a database
mysql --user=$PASSWORD --password=$PASSWORD -e "create database ${PROJECT};"

# install apache
sudo apt-get install -y apache2

# enable mods
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod expires
sudo a2enmod include

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName $PROJECT.local
	  ServerAlias www.$PROJECT.local
    DocumentRoot /var/www/html
    <Directory "/var/www/html">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)

echo "${VHOST}" > /etc/apache2/sites-available/$PROJECT.local.conf
sudo a2ensite $PROJECT.local.conf

# change apache configurations
sudo sed -i "/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/" /etc/apache2/apache2.conf

# restart apache
sudo service apache2 restart

# install git
sudo apt-get -y install git

# install sendmail
sudo apt-get install -y sendmail

# installing wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# installing wordpress
sudo rm /var/www/html/index.html
cd /var/www/html/
wp core download --allow-root
wp config create --dbname=$PROJECT --dbuser=$PASSWORD --dbpass=$PASSWORD --allow-root
wp core install --url=localhost:8000 --title=wp-starter --admin_user=admin --admin_password=password --admin_email=hpujols@sullivannyc.com --allow-root
wp plugin install timber --allow-root

# installing theme
ln -s /home/vagrant/shared/ /var/www/html/wp-content/themes/wp-starter
# wp theme activate wp-starter --allow-root
# wp plugin activate timber --allow-root

# all done
echo "${PROJECT} username is \"admin\" password is \"password\""
printf "\033[0;36m${PROJECT} site running on \033[0;35mhttp://localhost:${PORT}\033[0m"
