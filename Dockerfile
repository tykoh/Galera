# from http://galeracluster.com/2015/05/getting-started-galera-with-docker-part-1/

FROM ubuntu:14.04
MAINTAINER TYKOH <tzeyong@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 BC19DDBA
RUN add-apt-repository 'deb http://releases.galeracluster.com/ubuntu trusty main'
RUN apt-get update
RUN apt-get install -y galera-3 galera-arbitrator-3 mysql-wsrep-5.6 rsync lsof
RUN \
    echo "deb http://repo.percona.com/apt trusty main testing" > /etc/apt/sources.list.d/percona.list && \
    echo "deb-src http://repo.percona.com/apt trusty main testing" >> /etc/apt/sources.list.d/percona.list && \
    apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && \
    apt-get update && apt-get install -y percona-xtrabackup
COPY my.cnf /etc/mysql/my.cnf
ENTRYPOINT ["mysqld"]
