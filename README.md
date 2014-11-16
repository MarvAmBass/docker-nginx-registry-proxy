# Docker Registry Reverse Proxy with Basic Auth Nginx Server
_maintained by MarvAmBass_

## What is it

This Dockerfile (available as ___marvambass/nginx-registry-proxy___) gives you a nginx reverse proxy with SSL and Basic Auth to use with your Docker Registry (___registry___)

View in Docker Registry [marvambass/nginx-registry-proxy](https://registry.hub.docker.com/u/marvambass/nginx-registry-proxy/)

## Running marvambass/nginx-registry-proxy Container 

To run this container, you need a running ___registry___ with the name _registry_ for example:

    docker run -d --name registry \
    -v $YOUR_REGISTRY_DIR:/registry \
    -e "SETTINGS_FLAVOR=local" \
    -e "STORAGE_PATH=/registry" \
    registry

You also need a htpasswd-file [howto](#creating-a-htpasswd-file) and a ssl keypair [howto](#creating-a-self-signed-ssl-cert)

Put the new files in a folder to get a result like this:

    ~/your/path/external$ ls
    cert.pem  docker-registry.htpasswd  key.pem

You're now ready to run the nginx-registry-proxy Server ;)

    docker run -d -p 443:443 \
    -v $PATH\_TO\_YOUR/external:/etc/nginx/external \
    --link registry:registry --name nginx-registry-proxy \
    marvambass/nginx-registry-proxy

## Use your private Docker Registry

Let's asume, you followed all steps until now. You've a Server (_https://mydockerreg.com:443_) with _https_ on port _443_ and a basicauth user named _tom_ with the password _jerry_.

Let's check if the Server is available by opening this URL _https://mydockerreg.com:443/v1/\_ping_. If the Server returns _true_ your Registry is up and running.

Let's get a new Docker Image from the offical Registry, rename it, and publish it into your private Registry.

    $ docker pull scratch # this pulls the scratch image from the offical registry

Now we have the image named _scratch_ in our local Docker Image Registry. You can check that with the command:

    $ docker images
    scratch              latest              511136ea3c5a        16 months ago       0 B

Let's rename the Image and publish it into your private Registry

    $ docker tag scratch mydockerreg.com:443/scratch

Now the command _docker images_ will show another Image

    scratch              latest              511136ea3c5a        16 months ago       0 B
    mydockerreg.com:443/scratch             latest              511136ea3c5a        16 months ago       0 B

At this Point we're able to publish it into your private Registry but first we need to login into the server

    $ docker login https://mydockerreg.com:443
    Username: tom
    Password: jerry
    Email: 
    $ docker push mydockerreg.com:443/scratch

You're successfully published you're first Image into your private Registry.
__Note__ that you need _docker login_ on every Server (you can also use arguments for password and username, but this is not secure because of the process list of linux _ps aux_)

Download the uploaded Image:

    $ docker login https://mydockerreg.com:443
    Username: tom
    Password: jerry
    Email: 
    $ docker pull mydockerreg.com:443/scratch
    
That's it - Have fun!
    
## Based on

This Dockerfile bases on the [marvambass/nginx-ssl-secure](https://registry.hub.docker.com/u/marvambass/nginx-ssl-secure) Image.

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
