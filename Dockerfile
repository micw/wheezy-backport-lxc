# Dockerfile to backport lxc from debian jessie to wheezy.
# The commands are taken from https://blog.deimos.fr/2014/08/29/lxc-1-0-on-debian-wheezy/

FROM tianon/debian:wheezy

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://ftp.de.debian.org/debian/ wheezy-backports main" >> /etc/apt/sources.list.d/wheezy-backports.list

RUN apt-get update && apt-get -y install devscripts debian-keyring build-essential fakeroot \
    dpkg-dev dh-autoreconf doxygen docbook2x graphviz libapparmor-dev liblua5.2-dev \
    libseccomp-dev libselinux-dev pkg-config python3-dev \
    dh-systemd libcap-dev

RUN echo "deb-src http://ftp.de.debian.org/debian/ jessie main non-free contrib" >> /etc/apt/sources.list.d/jessie.list && apt-get update

WORKDIR /usr/src
RUN apt-get -y source lxc

RUN rm /etc/apt/sources.list.d/jessie.list && apt-get update

RUN mkdir -p /target

RUN echo "#!/bin/bash\ncd /usr/src/lxc-1.0.?/ && dpkg-buildpackage -rfakeroot -b && mv /usr/src/lxc*.deb /target/" > /build.sh && chmod 700 /build.sh

CMD ["/build.sh"]
