#!/bin/bash


echo "Creando un contenedor web2"
newgrp lxd
sudo snap install lxd --channel=4.0/stable
#Si te sale error quitas la siguiente linea.
lxd init --auto 
lxc launch ubuntu:18.04 web2
lxc exec web2 /bin/bash -- apt update && apt upgrade -y
lxc exec web2 /bin/bash -- apt-get install apache2 -y
lxc exec web2 /bin/bash -- systemctl enable apache2
lxc file push /vagrant/servidor2.html web2/var/www/html/index.html
lxc exec web2 -- systemctl restart apache2
sudo lxc config device add web2 ser280 proxy listen=tcp:192.168.100.7:80 connect=tcp:127.0.0.1:80

echo "Creando un contenedor serbackup2"
newgrp lxd
sudo snap install lxd --channel=4.0/stable
#Si te sale error quitas la siguiente linea.
lxd init --auto 
lxc launch ubuntu:18.04 serback2
lxc exec serback2 /bin/bash -- apt update && apt upgrade -y
lxc exec serback2 /bin/bash -- apt-get install apache2 -y
lxc exec serback2 /bin/bash -- systemctl enable apache2
lxc file push /vagrant/serback2.html serback2/var/www/html/index.html
lxc exec serback2 -- systemctl restart apache2
sudo lxc config device add serback2 serback280 proxy listen=tcp:192.168.100.7:7580 connect=tcp:127.0.0.1:80