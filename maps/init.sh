#!/usr/bin/env bash

# Install Maps dependencies via composer
cd "$(dirname $(readlink -f "$0"))"
git submodule update --init
cd src/maps && make
cd "$(dirname $(readlink -f "$0"))"
# Build containers
docker-compose up -d --build --force-recreate
echo "Wait while Docker builds and launches containers..."
while ! curl -L localhost:8000 >/dev/null 2>&1; do
	echo "Waiting for Apache server to come online..."
	sleep 3
done
echo "Apache server online. Copy in Maps app files and set permissions..."
set -x
# Copy intial Nextcloud Maps app into web root
docker exec -it maps_app_1 cp -r /opt/maps/ /var/www/html/apps/maps/
# Allow read/write for "other" so that user on host can edit live files
docker exec -it maps_app_1 chown -R www-data:www-data /var/www/html 
docker exec -it maps_app_1 chmod -R a+rwX /var/www/html/
set +x
while ! docker exec maps_db_1 mysql --user=nextcloud --password=password -e "SELECT 1" >/dev/null 2>&1; do
	echo "Waiting for mysql database to come online..."
	sleep 5
done
echo "mysql database online. Proceeding with automated installation..."
# Complete Nextcloud installation
docker exec -it --user www-data maps_app_1  php occ maintenance:install \
  --database "mysql" \
  --database-name "nextcloud" \
  --database-user "nextcloud" \
  --database-pass "password" \
  --database-host "maps_db_1" \
  --admin-user "admin" \
  --admin-pass "password" \
  --data-dir "/var/www/html/data"
# Enable apps
echo "Enabling Contacts and Maps apps..."
docker exec -it --user www-data maps_app_1 php occ app:enable maps contacts
echo "Nextcloud instance is online. Happy coding!"
exit 0
