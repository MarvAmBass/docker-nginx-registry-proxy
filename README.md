# Docker Registry Reverse Proxy with Basic Auth Nginx Server
_maintained by MarvAmBass_

## What is it

This Dockerfile (available as ___marvambass/nginx-registry-proxy___) gives you a nginx reverse proxy with SSL and Basic Auth to use with your Docker Registry (___registry___)

## Running marvambass/nginx-registry-proxy Container 

To run this container, you need a running ___registry___ with the name _registry_ for example:

    docker run -d --name registry \
    -v $YOUR_REGISTRY_DIR:/registry \
    -e "SETTINGS_FLAVOR=local" \
    -e "STORAGE_PATH=/registry" \
    -e "SEARCH_BACKEND=sqlalchemy" \
    registry

You also need a htpasswd-file [howto](#creating-a-htpasswd-file) and a ssl keypair [howto](#creating-a-self-signed-ssl-cert)

Put the new files in a folder to get a result like this:

    ~/your/path/external$ ls
    cert.pem  docker-registry.htpasswd  key.pem

You're now ready to run the nginx-registry-proxy Server ;)

    docker run -d -p 80:80 \
    -v $PATH\_TO\_YOUR/external:/etc/nginx/external \
    --link registry:registry --name nginx-registry-proxy \
    marvambass/nginx-registry-proxy

## Based on

This Dockerfile bases on the [/\_/nginx/](https://registry.hub.docker.com/_/nginx/) Official Image.

I got inspired by the following DigitalOcean Tutorial [https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-14-04
](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-14-04)

## Building the Dockerfile yourself

Just use the following command to build and publish your/this Docker Container.

  docker build -t username/nginx-registry-proxy .
  docker push username/nginx-registry-proxy

## Cheat Sheet

### Creating a self-signed ssl cert

Please note, that the Common Name (CN) is important and should be the FQDN to the secured server:

    openssl req -x509 -newkey rsa:4086 -keyout key.pem -out cert.pem -days 3650 -nodes

### Creating a htpasswd file

You need the _htpasswd_ command (on _Ubuntu_ you can simply install it with _sudo apt-get install -y apache2-utils_)

The first time you wanna __create__ the htpasswd-file, you need to use the _-c_ parameter (it stands for create).

    htpasswd -c docker-registry.htpasswd user1

Any other new User you want to add, simply use the following command:

    htpasswd docker-registry.htpasswd userN

_if you use the -c on a existing htpasswd-file, all existing user will be deleted and you create a new file which only contains the new user_
