# Nextcloud Maps Docker environment

The purpose of this repo is to make it easy to deploy Nextcloud Maps for development and testing purposes.

## Install

After cloning this repo, run the initialization script to build the Docker containers and automatically install Nextcloud and the Maps app for development:

	./maps/init.sh

Once the Nextcloud server is online, visit `http://localhost:8000` and log in with the default account `admin` with password `password`. You should see the Maps app link in the navigation bar.

## Develop

The web root of the local server is stored in `./maps/www` and the permissions are set to allow read-write access to "other". This keeps the file owner as the `www-data` user in the Docker container, but you can also edit files from the host and see the response immediately by refreshing your browser.
