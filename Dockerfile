FROM nginx
MAINTAINER MarvAmBass

RUN apt-get update && apt-get install -y \

RUN rm -rf /etc/nginx/conf.d/*
RUN mkdir -p /etc/nginx/external

RUN sed -i 's/access_log.*/access_log \/dev\/stdout;/g' /etc/nginx/nginx.conf
RUN sed -i 's/error_log.*/error_log \/dev\/stdout info;/g' /etc/nginx/nginx.conf
RUN sed -i 's/^pid/daemon off;\npid/g' /etc/nginx/nginx.conf

ADD basic.conf /etc/nginx/conf.d/basic.conf
ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["nginx"]
