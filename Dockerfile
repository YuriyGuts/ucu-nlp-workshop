FROM phusion/baseimage:0.9.22
MAINTAINER Yuriy Guts <yuriy.guts@gmail.com>

ENV TERM=xterm \
    EDITOR=nano

ADD ./docker-support /opt/docker

RUN cd /opt/docker && /bin/bash build.sh

EXPOSE 22 8888

WORKDIR /mnt/data
CMD ["/sbin/my_init"]
