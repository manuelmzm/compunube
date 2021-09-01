#!/bin/bash


echo "Creando un contenedor haproxy"
newgrp lxd
sudo snap install lxd --channel=4.0/stable
#Si te sale error quitas la siguiente linea.
lxd init --auto 
lxc launch ubuntu:18.04 haproxy
lxc exec haproxy /bin/bash -- apt update && apt upgrade -y
lxc exec haproxy /bin/bash -- apt-get install haproxy -y
lxc exec haproxy /bin/bash -- systemctl enable haproxy
lxc file push /vagrant/haproxy.cfg haproxy/etc/haproxy/haproxy.cfg
lxc exec haproxy -- systemctl start haproxy
sudo lxc config device add haproxy hap80 proxy listen=tcp:192.168.100.8:80 connect=tcp:127.0.0.1:80