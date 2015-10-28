$ docker run --name mysql-zmara -e MYSQL_ROOT_PASSWORD=1234qwer -d mysql:5.7-zmara


Using a custom MySQL configuration file
$ docker run --name mysql-zmara \
-v /Users/TzeYong/work/docker/mysql/mysql-conf.d:/etc/mysql/conf.d \
-v /Users/TzeYong/work/ablpls/database/backup:/host \
-e MYSQL_ROOT_PASSWORD=1234qwer \
-d mysql:5.7-zmara
