#!/usr/bin/env bash

export ANSIBLE_LIBRARY=/etc/ansible/roles/
if ! grep -qe "export ANSIBLE_LIBRARY=/etc/ansible/roles/" "/home/vagrant/.bashrc"; then
    cat >> /home/vagrant/.bashrc <<EOF
export ANSIBLE_LIBRARY=/etc/ansible/roles/
EOF
fi

sudo ip r a 10.10.0.0/22 via 172.16.0.1
sudo ip r a 192.168.10.0/24 via 172.16.0.1
sudo ip r a 172.15.0.0/24 via 172.16.0.1
sudo ip r a 10.11.12.0/24 via 172.16.0.1

cat >> /etc/network/interfaces <<EOF
post-up route add -net 10.10.0.0 netmask 255.255.252.0 gw 172.16.0.1
post-up route add -net 192.168.10.0 netmask 255.255.255.0 gw 172.16.0.1
post-up route add -net 172.15.0.0 netmask 255.255.255.0 gw 172.16.0.1
post-up route add -net 10.11.12.0 netmask 255.255.255.0 gw 172.16.0.1
EOF

sudo apt-get purge network-manager -y
sudo ifdown eth1
sudo ifup eth1


sudo apt-get update
sudo apt-get install -y python-dev libxml2-dev python-pip libxslt-dev build-essential libssl-dev libffi-dev libffi-dev sqlite3 libsqlite3-dev libxss1 aptitude
sudo pip install --upgrade setuptools
sudo pip install --upgrade setuptools pip
sudo pip install markupsafe
sudo pip install pyOpenSSL pyasn1 ndg-httpsclient
sudo pip install cryptography==1.5 junos-eznc ansible==2.3.2.0 jxmlease
sudo ansible-galaxy --force install Juniper.junos,1.4.3
sudo ansible-playbook  -i /vagrant/scripts/hosts  /vagrant/scripts/site.yml
