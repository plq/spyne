#!/bin/bash -x
export N=spyne-test-debian-sid
{ sudo lxc launch images:debian/sid $N || sudo lxc start $N; } && exit 1

until sudo lxc exec $N -- apt-get update; do sleep 1; done

set -e

sudo lxc exec $N -- apt-get upgrade || exit 20
sudo lxc exec $N -- apt-get install -y git tox python3-{spyne,twisted,coverage,pytest-{cov,twisted,django},lxml,colorama,django,pyparsing,sqlalchemy,yaml,msgpack,pyramid,webtest,zeep,zmq,werkzeug}
sudo lxc exec $N -- bash -c 'if [ ! -d spyne ]; then git clone https://github.com/arskom/spyne; fi'
sudo lxc exec $N -- bash -c 'cd spyne && git pull'
#sudo lxc exec $N -- bash -c 'cd spyne && python3 -m pytest --ignore=spyne/test/interop --ignore=examples'
sudo lxc exec $N -- bash -c 'cd spyne && python3 setup.py test'
