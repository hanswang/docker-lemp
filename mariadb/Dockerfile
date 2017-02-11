FROM phusion/baseimage:latest

ENV \
  HOME /root \
  DEBIAN_FRONTEND noninteractive

RUN \
  rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh && \
  locale-gen en_US.UTF-8 && \
  export LANG=en_US.UTF-8 && \
  echo "deb http://mirror.optus.net/ubuntu xenial main universe" > /etc/apt/sources.list && \
  apt-get update -y && \
  apt-get -yq --no-install-recommends --fix-missing --force-yes install wget strace lsof netcat software-properties-common && \
  update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 && \
  add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.aarnet.edu.au/pub/MariaDB/repo/10.1/ubuntu xenial main' && \
  apt-get update

RUN \
  DEBIAN_FRONTEND=noninteractive; \
  echo mariadb-server-10.1 mysql-server/root_password password 'unused' | debconf-set-selections; \
  echo mariadb-server-10.1 mysql-server/root_password_again password 'unused' | debconf-set-selections; \
  apt-get install -yq mariadb-server && \
  apt-get install -y mariadb-client mariadb-common && \
  mkdir -p /etc/my_init.d && \
  mkdir -p /etc/service/mariadb/log/main && \
  apt-get clean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD my_init.d /etc/my_init.d
ADD runit/mariadb /etc/service/mariadb/run
ADD runit/log /etc/service/mariadb/log/run

VOLUME ["/var/lib/mysql","/var/log/mysql"]

EXPOSE 3306

ENV TERM xterm

CMD ["/sbin/my_init"]
