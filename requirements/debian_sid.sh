#!/bin/bash -x
N=spyne-test-debian-sid
sudo lxc launch images:debian/sid $N
sudo lxc start $N
sudo lxc exec $N -- apt-get update
sudo lxc exec $N -- apt-get upgrade
sudo lxc exec $N -- apt-get install -y git python3-spyne tox
sudo lxc exec $N -- git clone https://github.com/arskom/spyne
sudo lxc exec $N -- bash -c "cd spyne; virtualenv -p python3 virt-3; source virt-3/bin/activate; pip install -r requirements/test_requirements.txt; python setup.py test"
