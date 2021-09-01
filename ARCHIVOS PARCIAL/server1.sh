#!/bin/bash


echo "Creando un contenedor web1"
newgrp lxd
sudo snap install lxd --channel=4.0/stable
#Si te sale error quitas la siguiente linea.
lxd init --auto 
lxc launch ubuntu:18.04 web1
lxc exec web1 /bin/bash -- apt update && apt upgrade -y
lxc exec web1 /bin/bash -- apt-get install apache2 -y
lxc exec web1 /bin/bash -- systemctl enable apache2
lxc file push /vagrant/servidor1.html web1/var/www/html/index.html
lxc exec web1 -- systemctl restart apache2
sudo lxc config device add web1 server180 proxy listen=tcp:192.168.100.6:80 connect=tcp:127.0.0.1:80

echo "Creando un contenedor haproxy"
newgrp lxd
sudo snap install lxd --channel=4.0/stable
#Si te sale error quitas la siguiente linea.
lxd init --auto 
lxc launch ubuntu:18.04 serback1
lxc exec serback1 /bin/bash -- apt update && apt upgrade -y
lxc exec serback1 /bin/bash -- apt-get install apache2 -y
lxc exec serback1 /bin/bash -- systemctl enable apache2
lxc file push /vagrant/serback1.html serback1/var/www/html/index.html
lxc exec server2 -- systemctl restart apache2
sudo lxc config device add serback1 serback180 proxy listen=tcp:192.168.100.6:7580 connect=tcp:127.0.0.1:80