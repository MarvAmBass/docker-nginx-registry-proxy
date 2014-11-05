FROM nginx
MAINTAINER MarvAmBass

RUN rm -rf /etc/nginx/conf.d/*
ADD docker-registry.conf /etc/nginx/conf.d/docker-registry.conf
