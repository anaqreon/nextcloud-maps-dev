# Nextcloud Maps Docker environment

The purpose of this repo is to make it easy to deploy Nextcloud Maps for development and testing purposes.

## Deploy

Clone this repo _recursively_ and run the initialization script to build the Docker containers and automatically deploy Nextcloud and the Maps app for development:

```
git clone --recursive $THIS_REPO_URL $REPO_DIR
cd $REPO_DIR
./maps/deploy [maps_git_repo_commit] [nextcloud_docker_tag]
```

If the optional arguments are omitted, the `master` branch of the Maps repo is used and the `nextcloud:latest` Nextcloud Docker image tag is used.

As an example, if you wanted to test code committed as part of a pull request related to a new feature in development branch `issue-70-share-favorite-locations` using Nextcloud release candidate `18:0-rc`, you could deploy with
```
./maps/deploy issue-70-share-favorite-locations nextcloud:18.0-rc
```
or you could specify the immutable digest
```
./maps/deploy issue-70-share-favorite-locations nextcloud@sha256:cbfd9f8050220336f15d1586f93bebf31515c0f0aadc8eb5fd0f9bec4174052e
```

Once the Nextcloud server is online, visit `http://localhost:8000` and log in with the default account `admin` with password `password`. You should see the Maps app link in the navigation bar.

## Develop

The web root of the local server is mounted as a Docker volume at `./maps/www`. The Apache webserver runs with the same user ID as the host user, such that there should be no permission issues when editing the files on the host. File modifications take effect immediately by refreshing the page your browser.

## Delete

To delete the server and ***delete the database and all web files***, execute

```
maps/remove
```
