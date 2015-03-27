FROM marvambass/nginx-ssl-secure
MAINTAINER MarvAmBass

ADD docker-registry.conf /etc/nginx/conf.d/docker-registry.conf
ADD start_nginx.sh /opt/
RUN chmod a+x /opt/start_nginx.sh

CMD ["/opt/start_nginx.sh"]

