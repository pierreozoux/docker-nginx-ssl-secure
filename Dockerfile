FROM nginx
MAINTAINER MarvAmBass

RUN apt-get update && apt-get install -y \
    php5-fpm

RUN rm -rf /etc/nginx/conf.d/*
RUN mkdir -p /etc/nginx/external

RUN sed -i 's/access_log.*/access_log \/dev\/stdout;/g' /etc/nginx/nginx.conf
RUN sed -i 's/error_log.*/error_log \/dev\/stdout info;/g' /etc/nginx/nginx.conf
RUN sed -i 's/^pid/daemon off;\npid/g' /etc/nginx/nginx.conf

ADD basic.conf /etc/nginx/conf.d/basic.conf
ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

# fix pathinfo see: (https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-14-04)
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini

# add 'service php5-fpm start' to entrypoint.sh
RUN sed -i 's/#!\/bin\/bash/#!\/bin\/bash\n\/etc\/init.d\/php5-fpm start\nchmod a+rwx \/var\/run\/php5-fpm.sock/g' /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["nginx"]
