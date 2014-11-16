FROM marvambass/nginx-ssl-secure
MAINTAINER MarvAmBass

ADD docker-registry.conf /etc/nginx/conf.d/docker-registry.conf
