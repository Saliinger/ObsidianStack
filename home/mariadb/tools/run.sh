#! /bin/sh

if [ ! -d /var/lib/mysql/mysql ]; then
	mysql_install_db
	mariadbd &
	while ! mariadb-admin ping --silent; do
		sleep 1
	done
	mariadb -e "CREATE DATABASE ${DB_NAME};"
	mariadb -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PWD}';"
	mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
	mariadb-admin shutdown
fi

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

exec mariadbd --user=mysql