#!/usr/bin/env bash

set -e

chown -R dockerregistry:dockerregistry /opt/dockerregistry 
chown dockerregistry:dockerregistry /opt/dockerregistry/.. 
chown dockerregistry:dockerregistry /opt/dockerregistry/.
mkdir -p /usr/lib/systemd/system
cp -fR /opt/dockerregistry/usr/lib/systemd/system/dockerregistry.service /usr/lib/systemd/system/dockerregistry.service
systemctl enable dockerregistry.service
systemctl daemon-reload

ln -s /opt/dockerregistry/logs/error.log
