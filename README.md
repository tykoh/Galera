# Galera

Building the docker image
```sh
docker build --tag=galera .
```
## Local cluster setup
Starting the first node
``` sh
docker run \
--detach=true \
--name node1 \
-h node1 \
galera \
--wsrep-cluster-name=default-cluster \
--wsrep-cluster-address=gcomm://
```

Starting node 2
``` sh
docker run \
--detach=true \
--name node2 \
-h node2 \
--link node1:node1 \
galera \
--wsrep-cluster-name=default-cluster \
--wsrep-cluster-address=gcomm://node1
```

Starting node 3
```sh
docker run \
--detach=true \
--name node3 \
-h node3 \
--link node1:node1 \
galera \
--wsrep-cluster-name=default-cluster \
--wsrep-cluster-address=gcomm://node1
```

## Multi-node cluster
* Mysql port at 3306
* Galera cluster port at 4567
* Galera increamental state transfer (IST) port at 4568
* Galera state snapshot transfer (SST) port at 4444

We got to map the ports to different local port as we are all running in the same host machine.
If the containers are running on different host machine, there is no need to map to different local port. Just do a 1:1 mapping of the actual ports.

Get ip address of machine
```sh
export IP_NOW=`ifconfig | awk '/inet /{print substr($2,1)}' | tail -n 1`
```


Starting first node
```sh
docker run -d \
-p 33060:3306 \
-p 45670:45670 \
-p 44440:44440 \
-p 45680:45680 \
--name nodea \
galera \
--wsrep-cluster-address=gcomm:// \
--wsrep-node-address=192.168.99.100:45670 \
--wsrep-sst-receive-address=192.168.99.100:44440 \
--wsrep-provider-options="ist.recv_addr=192.168.99.100:45680"
```

Start node b

```sh
docker run -d \
-p 33061:3306 \
-p 45671:45671 \
-p 44441:44441 \
-p 45681:45681 \
--name nodeb \
galera \
--wsrep-cluster-address=gcomm://192.168.99.100:45670 \
--wsrep-node-address=192.168.99.100:45671 \
--wsrep-sst-receive-address=192.168.99.100:44441 \
--wsrep-provider-options="ist.recv_addr=192.168.99.100:45681"
```

Start node c

```sh
docker run -d \
-p 33062:3306 \
-p 45672:45672 \
-p 44442:44442 \
-p 45682:45682 \
--name nodec \
galera \
--wsrep-cluster-address=gcomm://192.168.99.100:45670 \
--wsrep-node-address=192.168.99.100:45672 \
--wsrep-sst-receive-address=192.168.99.100:44442 \
--wsrep-provider-options="ist.recv_addr=192.168.99.100:45682"
```

Post command to set up database
```sh
docker exec -t nodea mysql -e "create user 'username'@'localhost' identified by 'user_password';"

docker exec -t nodea mysql -e "create user 'username'@'192.168.0.0/255.255.0.0' identified by 'user_password';"

docker exec -t nodea mysql -e "grant all on *.* to 'username'@'192.168.0.0/255.255.0.0';"

docker exec -t nodea mysql -e "grant all on *.* to 'username'@'localhost';"
```
