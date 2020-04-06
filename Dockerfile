FROM ubuntu:18.04
MAINTAINER vshepelev@wallarm.com

RUN apt-get -y update && \
    apt-get -y install gnupg2 curl apt-transport-https supervisor && \
    curl https://download.tarantool.org/tarantool/2.2/gpgkey | apt-key add - && \
    echo "deb https://download.tarantool.org/tarantool/2.2/ubuntu/ bionic main" > /etc/apt/sources.list.d/tarantool_2_2.list && \
    echo "deb-src https://download.tarantool.org/tarantool/2.2/ubuntu/ bionic main" >> /etc/apt/sources.list.d/tarantool_2_2.list && \
    apt-get -y update && \
    apt-get -y install tarantool

COPY apps/tarantool-guest.lua /etc/tarantool/instances.enabled/
COPY apps/tarantool-auth.lua  /etc/tarantool/instances.enabled/
COPY apps/tarantool-strong-auth.lua /etc/tarantool/instances.enabled/
COPY conf/supervisord.conf /etc/supervisor/
RUN mkdir /var/lib/tarantool-guest /var/lib/tarantool-auth /var/lib/tarantool-strong-auth &&\
    chown -R tarantool:tarantool /var/lib/tarantool-*


EXPOSE 3301 3302 3303
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf" ]
